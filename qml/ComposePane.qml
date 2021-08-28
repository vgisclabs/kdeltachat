import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import DeltaChat 1.0

Pane {
    id: root

    required property DcContext context
    required property var chatId
    required property var chat

    property bool canSend: root.chat && root.chat.canSend
    property bool isContactRequest: root.chat && root.chat.isContactRequest

    function createMessage()
    {
        let DC_MSG_TEXT = 10;

        var msg = root.context.newMessage(DC_MSG_TEXT)
        msg.setText(messageField.text)
        return msg
    }

    padding: 0

    RowLayout {
        width: parent.width

        TextArea {
            id: messageField
            visible: root.canSend

            Layout.fillWidth: true
            placeholderText: qsTr("Message")
            wrapMode: TextArea.Wrap
            selectByMouse: true

            Component.onCompleted: {
                let draft = root.context.getDraft(chatId)
                if (draft) {
                    messageField.text = draft.text
                }
            }

            Connections {
                function onEditingFinished() {
                    let msg = root.createMessage()
                    root.context.setDraft(chatId, msg)
                }
            }
        }

        Button {
            id: sendButton
            visible: root.canSend

            Layout.alignment: Qt.AlignBottom

            icon.name: "document-send"
            text: qsTr("Send")
            enabled: messageField.length > 0
            onClicked: {
                let msg = root.createMessage()
                root.context.sendMessage(root.chatId, msg)

                messageField.text = ""
                root.context.setDraft(chatId, null)
            }
        }

        Button {
            Layout.alignment: Qt.AlignBottom
            Layout.fillWidth: true

            text: "Accept"
            onClicked: root.context.acceptChat(root.chatId)
            visible: root.isContactRequest
            icon.name: "call-start"
        }

        Button {
            Layout.alignment: Qt.AlignBottom
            Layout.fillWidth: true

            text: "Block"
            onClicked: root.context.acceptChat(root.chatId)
            visible: root.isContactRequest
            icon.name: "call-stop"
        }
    }
}
