import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQml.Models 2.1
import org.kde.kirigami 2.13 as Kirigami

import DeltaChat 1.0

Kirigami.Page {
    title: qsTr("Chats")
    id: chatlistPage

    required property DcContext context

    signal messagesChanged
    onMessagesChanged: {
        // Reload chatlist
        updateChatlist();
    }

    signal messagesNoticed
    onMessagesNoticed: {
        // Reload chatlist
        updateChatlist();
    }

    Component.onCompleted: {
        eventEmitter.onMessagesChanged.connect(messagesChanged)
        eventEmitter.onMessagesNoticed.connect(messagesNoticed)
        updateChatlist()
    }

    contextualActions: [
        Kirigami.Action {
            text: "Settings"
            iconName: "configure"
            onTriggered: {
                let settingsPageComponent = Qt.createComponent("qrc:/qml/SettingsPage.qml")
                if (settingsPageComponent.status == Component.Ready) {
                    let settingsPage = settingsPageComponent.createObject(chatlistPage, {context: chatlistPage.context})
                    pageStack.layers.push(settingsPage)
                }
            }
        }
    ]

    ListModel {
        id: chatlistModel
    }

    function updateChatlist() {
        let chatlist = chatlistPage.context.getChatlist()

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

        onCurrentItemChanged: {
            var chatId = chatlistModel.get(currentIndex).chatId
            chatlistPage.context.marknoticedChat(chatId)

            console.log("Current index is " + currentIndex)
            console.log("Selected chat " + chatId)

            console.log("Depth is " + pageStack.depth)
            let chatPageComponent = Qt.createComponent("qrc:/qml/ChatPage.qml")
            if (chatPageComponent.status == Component.Ready) {
                let myPage = chatPageComponent.createObject(chatlistPage, {chatId: chatId})
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

        delegate: Kirigami.BasicListItem {
            width: chatlist.width

            label: chatlistPage.context.getChat(model.chatId).getName()
            subtitle: model.username

            leading: Kirigami.Avatar {
                source: model.avatarSource
                name: model.chatName
                implicitWidth: height
                color: chatlistPage.context.getChat(model.chatId).getColor()
            }

            trailing: Label {
                text: model.freshMsgCnt
                visible: model.freshMsgCnt > 0
                verticalAlignment: Text.AlignVCenter
            }

            MouseArea {
                anchors.fill: parent

                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: {
                    if (mouse.button === Qt.RightButton)
                        contextMenu.popup()
                }
                onPressAndHold: {
                    if (mouse.source === Qt.MouseEventNotSynthesized)
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
                        text: "Delete chat"
                        onTriggered: chatlistPage.context.deleteChat(model.chatId)
                    }
                }
            }
        }

        ScrollBar.vertical: ScrollBar {}
    }
}
