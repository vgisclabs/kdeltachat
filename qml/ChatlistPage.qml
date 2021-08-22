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

    header: Kirigami.SearchField {
        id: searchField

        onTextChanged: chatlistPage.updateChatlist()
    }

    mainAction: Kirigami.Action {
        text: "New chat"
        iconName: "list-add"
        onTriggered: {
            let newChatPageComponent = Qt.createComponent("qrc:/qml/NewChatPage.qml")
            if (newChatPageComponent.status == Component.Ready) {
                let newChatPage = newChatPageComponent.createObject(pageStack, {context: chatlistPage.context})
                pageStack.layers.push(newChatPage)
            } else if (newChatPageComponent.status == Component.Error) {
                console.log("Error loading new chat page: " + newChatPageComponent.errorString())
            }
        }
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

    function chatClicked(chatId) {
        if (chatId > 9) {
            // chatId > DC_CHAT_ID_LAST_SPECIAL
            loadChat(chatId)

        } else if (chatId == 6) {
            chatlistPage.archivedOnly = true
            chatlist.currentIndex = -1
            updateChatlist();
        }
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
        let chatlist = chatlistPage.context.getChatlist(chatlistPage.archivedOnly ? 1 : 0,
                                                        searchField.text)

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
                freshMsgCnt: chatlistPage.context.getFreshMsgCnt(chatId),
                isContactRequest: chat.isContactRequest,
                visibility: chat.visibility
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

        delegate: ChatlistItem {
            context: chatlistPage.context
            chatId: model.chatId
            chatName: model.chatName
            avatarSource: model.avatarSource
            username: model.username
            freshMsgCnt: model.freshMsgCnt
            isContactRequest: model.isContactRequest
            isPinned: model.visibility == 2

            width: chatlist.width
            onClicked: chatClicked(model.chatId)
        }
    }
}
