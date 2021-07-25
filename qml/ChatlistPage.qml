import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQml.Models 2.1
import org.kde.kirigami 2.13 as Kirigami

import DeltaChat 1.0

Kirigami.ScrollablePage {
    title: qsTr("Chats")
    id: chatlistPage

    required property DcContext context
    required property DcAccountsEventEmitter eventEmitter

    property bool archivedOnly: false

    Connections {
        target: chatlistPage.eventEmitter

        function onMessagesChanged() {
            // Reload chatlist
            updateChatlist();
        }
        function onMessagesNoticed() {
            // Reload chatlist
            updateChatlist();
        }
        function onChatModified() {
            // Reload chatlist
            updateChatlist();
        }
    }

    Component.onCompleted: {
        updateChatlist()
    }

    contextualActions: [
        Kirigami.Action {
            text: "Settings"
            iconName: "configure"
            onTriggered: {
                let settingsPageComponent = Qt.createComponent("qrc:/qml/SettingsPage.qml")
                if (settingsPageComponent.status == Component.Ready) {
                    let settingsPage = settingsPageComponent.createObject(pageStack, {context: chatlistPage.context})
                    pageStack.layers.push(settingsPage)
                } else {
                    console.log("Can't open Settings page")
                }
            }
        }
    ]

    ListModel {
        id: chatlistModel
    }

    function loadChat(chatId) {
        chatlistPage.context.marknoticedChat(chatId)

        console.log("Selected chat " + chatId)

        console.log("Depth is " + pageStack.depth)
        let chatPageComponent = Qt.createComponent("qrc:/qml/ChatPage.qml")
        if (chatPageComponent.status == Component.Ready) {
            let myPage = chatPageComponent.createObject(pageStack, {chatId: chatId, context: chatlistPage.context, eventEmitter: chatlistPage.eventEmitter})
            if (pageStack.depth == 1) {
                pageStack.push(myPage)
            } else if (pageStack.depth == 2) {
                pageStack.currentIndex = 1
                pageStack.replace(myPage)
            }
        } else if (chatPageComponent.status == Component.Error) {
            console.log("Error loading chat page: " + chatPageComponent.errorString())
        }
    }

    function updateChatlist() {
        let chatlist = chatlistPage.context.getChatlist(chatlistPage.archivedOnly ? 1 : 0)

        // Merge new chatlist with existing one.
        // To preserve selected item, we do not simply clear and fill
        // the model from scratch.

        for (let i = 0; i < chatlist.getChatCount(); i++) {
            const summary = chatlist.getSummary(i)
            const chatId = chatlist.getChatId(i)
            const chat = chatlistPage.context.getChat(chatId)
            const profileImage = chat.getProfileImage()

            const item = {
                chatId: chatId,
                msgId: chatlist.getMsgId(i),
                username: (summary.text1 != "" ? summary.text1 + ": " : "") + summary.text2,
                avatarSource: profileImage ? "file:" + profileImage : "",
                chatName: chat.name,
                freshMsgCnt: chatlistPage.context.getFreshMsgCnt(chatId)
            }

            let j;
            for (j = i; j < chatlistModel.count; j++) {
                if (chatlistModel.get(j).chatId == chatId) {
                    // This chat was already in the chatlist,
                    // move it to the new place and update.
                    chatlistModel.move(j, i, 1)
                    chatlistModel.set(i, item)
                    break
                }
            }

            // This chat is new, insert it.
            if (j == chatlistModel.count) {
                chatlistModel.insert(i, item)
            }
        }

        // Remove any chats that are not present in the new chatlist.
        if (chatlistModel.count > chatlist.getChatCount()) {
            chatlistModel.remove(chatlist.getChatCount(),
                                 chatlistModel.count - chatlist.getChatCount())
        }
    }

    ListView {
        id: chatlist

        anchors.fill: parent
        model: chatlistModel
        currentIndex: -1

        onCurrentItemChanged: {
            console.log("Current index is " + chatlist.currentIndex)
            if (currentIndex == -1) {
                return;
            }

            var chatId = chatlistModel.get(chatlist.currentIndex).chatId

            if (chatId > 9) {
                // chatId > DC_CHAT_ID_LAST_SPECIAL
                loadChat(chatId)

            } else if (chatId == 6) {
                chatlistPage.archivedOnly = true
                chatlist.currentIndex = -1
                updateChatlist();
            }
        }

        delegate: Kirigami.AbstractListItem {
            width: chatlist.width

            RowLayout {
                Kirigami.Avatar {
                    source: model.avatarSource
                    name: model.chatName
                    color: chatlistPage.context.getChat(model.chatId).getColor()
                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.RightButton
                        onClicked: {
                            if (mouse.button === Qt.RightButton)
                                contextMenu.popup()
                        }

                        Menu {
                            id: contextMenu

                            Action {
                                text: "Pin chat"
                                onTriggered: chatlistPage.context.setChatVisibility(model.chatId, 2)
                            }
                            Action {
                                text: "Unpin chat"
                                onTriggered: chatlistPage.context.setChatVisibility(model.chatId, 0)
                            }
                            Action {
                                text: "Archive chat"
                                onTriggered: chatlistPage.context.setChatVisibility(model.chatId, 1)
                            }
                            Action {
                                text: "Unarchive chat"
                                onTriggered: chatlistPage.context.setChatVisibility(model.chatId, 0)
                            }
                            Action {
                                text: "Delete chat"
                                onTriggered: chatlistPage.context.deleteChat(model.chatId)
                            }
                        }
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true

                    Label {
                        text: chatlistPage.context.getChat(model.chatId).getName()
                        font.weight: Font.Bold
                        Layout.fillWidth: true
                    }
                    Label {
                        text: model.username
                        font: Kirigami.Theme.smallFont
                        Layout.fillWidth: true
                    }
                }

                Label {
                    text: model.freshMsgCnt
                    visible: model.freshMsgCnt > 0

                    // Align label in the center of a badge.
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter

                    // Make sure badge is not too narrow.
                    Layout.minimumWidth: height

                    background: Rectangle {
                        color: Kirigami.Theme.alternateBackgroundColor
                        radius: 0.25 * height
                    }
                }
            }
        }
    }
}
