import DeltaChat 1.0
import QtQml.Models 2.1
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.12 as Kirigami

Kirigami.ScrollablePage {
    id: root

    required property DcContext context
    required property DcAccountsEventEmitter eventEmitter
    required property var chatId
    property DcChat chat: context.getChat(chatId)

    function updateMessagelist() {
        // Reverse message list, because it is laid out from bottom to top.
        let messagelist = context.getMsgIdList(chatId).reverse();
        for (let i = 0; i < messagelist.length; i++) {
            const msgId = messagelist[i];
            const item = {
                "msgId": msgId
            };
            let j;
            for (j = i; j < messagelistModel.count; j++) {
                if (messagelistModel.get(j).msgId == msgId) {
                    messagelistModel.move(j, i, 1);
                    messagelistModel.set(i, item);
                    break;
                }
            }
            if (j == messagelistModel.count)
                messagelistModel.insert(i, item);

        }
        if (messagelistModel.count > messagelist.length)
            messagelistModel.remove(messagelist.length, messagelistModel.count - messagelist.length);

    }

    title: chat ? chat.name : qsTr("Chat")
    Component.onCompleted: {
        root.updateMessagelist();
    }

    ListModel {
        id: messagelistModel
    }

    Connections {
        function onChatModified() {
            console.log("CHAT MODIFIED!");
            root.chat = context.getChat(chatId);
        }

        function onIncomingMessage(accountId, chatId, msgId) {
            updateMessagelist();
            console.log("Incoming message for chat " + chatId);
        }

        function onMessagesChanged(accountId, chatId, msgId) {
            console.log("Messages changed for chat " + chatId);
            if (chatId == root.chatId || chatId == 0)
                root.updateMessagelist();

        }

        target: root.eventEmitter
    }

    ListView {
        id: messageListView

        anchors.fill: parent
        spacing: Kirigami.Units.largeSpacing
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
        ScrollBar.vertical: ScrollBar {
            wheelEnabled: true
            hoverEnabled: true
            background: Rectangle {
                opacity: hovered ? 1 : 0.0
            }
        }

        delegate: Message {
            message: root.context.getMessage(msgId)
            context: root.context
            width: ListView.view.width
        }

    }

    background: Rectangle {
        color: Kirigami.Theme.alternateBackgroundColor
        anchors.fill: parent
    }

    footer: ComposePane {
        context: root.context
        chatId: root.chatId
        chat: root.chat
        Layout.fillWidth: true
    }

}
