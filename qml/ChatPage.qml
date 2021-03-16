import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQml.Models 2.1
import org.kde.kirigami 2.12 as Kirigami

import DeltaChat 1.0

Kirigami.ScrollablePage {
    id: chatPage

    title: chat ? chat.name : qsTr("Chat")

    required property DcContext context
    required property DcAccountsEventEmitter eventEmitter

    required property var chatId
    readonly property DcChat chat: context.getChat(chatId)

    function updateMessagelist() {
        // Reverse message list, because it is laid out from bottom to top.
        let messagelist = context.getMsgIdList(chatId).reverse()

        for (let i = 0; i < messagelist.length; i++) {
            const msgId = messagelist[i]

            const item = {
                msgId: msgId
            }

            let j;
            for (j = i; j < messagelistModel.count; j++) {
                if (messagelistModel.get(j).msgId == msgId) {
                    messagelistModel.move(j, i, 1)
                    messagelistModel.set(i, item)
                    break
                }
            }

            if (j == messagelistModel.count) {
                messagelistModel.insert(i, item)
            }
        }

        if (messagelistModel.count > messagelist.length) {
            messagelistModel.remove(messagelist.length,
                                    messagelistModel.count - messagelist.length)
        }
    }

    ListModel {
        id: messagelistModel
    }

    Connections {
        target: chatPage.eventEmitter

        function onIncomingEvent() {
            console.log("EVENT!")
        }
        function onChatModified() {
            console.log("CHAT MODIFIED!")
        }
        function onIncomingMessage(accountId, chatId, msgId) {
            console.log("Incoming message for chat " + chatId)

            if (chatId == chatPage.chatId) {
                chatPage.updateMessagelist()
            }
        }
        function onMessagesChanged(accountId, chatId, msgId) {
            console.log("Messages changed for chat " + chatId)

            if (chatId == chatPage.chatId) {
                chatPage.updateMessagelist()
            }
        }
    }

    Component.onCompleted: {
        chatPage.updateMessagelist()
    }

    background: Rectangle {
        color: Kirigami.Theme.alternateBackgroundColor
        anchors.fill: parent
    }

    Component {
        id: composePane

        Pane {
            Layout.fillWidth: true

            RowLayout {
                width: parent.width

                TextField {
                    id: messageField

                    Layout.fillWidth: true
                    placeholderText: qsTr("Message")
                    wrapMode: TextArea.Wrap
                    selectByMouse: true
                }

                Button {
                    id: sendButton

                    icon.name: "document-send"
                    text: qsTr("Send")
                    enabled: messageField.length > 0
                    onClicked: {
                        chatPage.context.sendTextMessage(chatPage.chatId, messageField.text)
                        messageField.text = ""
                    }
                }
            }
        }
    }

    ListView {
        id: messageListView

        anchors.fill: parent
        spacing: 10

        model: messagelistModel

        /*
         * Messages are laid out bottom to top, because their height
         * is not known in advance.
         *
         * Attempts to lay out messages top to bottom and scroll to the
         * bottom of the list with ListView.positionViewAtEnd() result in
         * imprecise scrollbar position, because this method estimates
         * item height from the height of currently visible messages.
         */
        verticalLayoutDirection: ListView.BottomToTop

        delegate: Message {message: context.getMessage(msgId)}
    }

    footer: Loader {
        sourceComponent: composePane
        Layout.fillWidth: true
        visible: chat && chat.canSend
    }
}
