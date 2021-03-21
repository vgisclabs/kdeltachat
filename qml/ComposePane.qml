import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import DeltaChat 1.0

Pane {
    Layout.fillWidth: true
    padding: 0

    required property DcContext context
    required property var chatId

    RowLayout {
        width: parent.width

        TextArea {
            id: messageField

            Layout.fillWidth: true
            placeholderText: qsTr("Message")
            wrapMode: TextArea.Wrap
            selectByMouse: true
        }

        Button {
            id: sendButton

            Layout.alignment: Qt.AlignBottom

            icon.name: "document-send"
            text: qsTr("Send")
            enabled: messageField.length > 0
            onClicked: {
                chatPage.context.sendTextMessage(chatId, messageField.text)
                messageField.text = ""
            }
        }
    }
}
