import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import DeltaChat 1.0

Pane {
    id: root

    required property DcContext context
    required property var chatId

    padding: 0

    RowLayout {
        width: parent.width

        TextArea {
            id: messageField

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
                    var msg = root.context.newMessage(10)
                    msg.setText(messageField.text)
                    root.context.setDraft(chatId, msg)
                }
            }
        }

        Button {
            id: sendButton

            Layout.alignment: Qt.AlignBottom

            icon.name: "document-send"
            text: qsTr("Send")
            enabled: messageField.length > 0
            onClicked: {
                root.context.sendTextMessage(chatId, messageField.text)
                messageField.text = ""
                root.context.setDraft(chatId, null)
            }
        }
    }
}
