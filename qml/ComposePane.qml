import DeltaChat 1.0
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.12

Pane {
    id: root

    required property DcContext context
    required property var chatId
    required property var chat
    property var attachFileUrl: ""
    property bool canSend: root.chat && root.chat.canSend
    property bool isContactRequest: root.chat && root.chat.isContactRequest

    function createMessage() {
        let DC_MSG_TEXT = 10;
        let DC_MSG_FILE = 60;
        if (attachFileUrl.length > 0) {
            var msg = root.context.newMessage(DC_MSG_FILE);
            msg.setFile(attachFileUrl);
        } else {
            var msg = root.context.newMessage(DC_MSG_TEXT);
        }
        msg.setText(messageField.text);
        return msg;
    }

    padding: 0

    Shortcut {
        sequence: "Ctrl+S"
        onActivated: {
            if (sendButton.enabled) {
                sendButton.focus = true;
                sendButton.clicked();
                sendButton.focus = false;
            }
        }
    }

    Shortcut {
        sequence: "Ctrl+O"
        onActivated: {
            if (attachButton.enabled) {
                attachButton.focus = true;
                attachButton.clicked();
                attachButton.focus = false;
            }
        }
    }

    FileDialog {
        id: attachFileDialog

        title: "Attach"
        folder: shortcuts.home
        onAccepted: {
            var url = attachFileDialog.fileUrl.toString();
            if (url.startsWith("file://")) {
                attachFileUrl = url.substring(7);
                console.log("Attaching " + attachFileUrl);
            }
        }
    }

    RowLayout {
        width: parent.width

        Button {
            id: attachButton

            visible: root.canSend
            text: attachFileUrl.length > 0 ? qsTr("Detach") : qsTr("Attach")
            hoverEnabled: true
            ToolTip.visible: hovered
            ToolTip.text: attachFileUrl.length > 0 ? "Ctrl+O<br>Attached file is <b>" + attachFileUrl + "</b>" : "Ctrl+O"
            Layout.alignment: Qt.AlignBottom
            icon.name: "mail-attachment"
            onClicked: {
                if (attachFileUrl.length > 0)
                    attachFileUrl = "";
                else
                    attachFileDialog.open();
            }
        }

        TextArea {
            id: messageField

            visible: root.canSend
            Layout.fillWidth: true
            placeholderText: qsTr("Message")
            wrapMode: TextArea.Wrap
            selectByMouse: true
            Component.onCompleted: {
                let draft = root.context.getDraft(chatId);
                if (draft)
                    messageField.text = draft.text;

            }

            Connections {
                function onEditingFinished() {
                    let msg = root.createMessage();
                    root.context.setDraft(chatId, msg);
                }

            }

        }

        Button {
            id: sendButton

            hoverEnabled: true
            ToolTip.visible: hovered
            ToolTip.text: "Ctrl+S"
            visible: root.canSend
            Layout.alignment: Qt.AlignBottom
            icon.name: "document-send"
            text: qsTr("Send")
            enabled: messageField.length > 0 | attachFileUrl.length > 0
            onClicked: {
                sendButton.down = true;
                let msg = root.createMessage();
                root.context.sendMessage(root.chatId, msg);
                sendButton.down = false;
                attachFileUrl = "";
                messageField.text = "";
                root.context.setDraft(chatId, null);
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
