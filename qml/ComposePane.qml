import DeltaChat 1.0
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.12 as Kirigami

Pane {
    id: root
    required property DcContext context
    required property var chatId
    required property var chat
    property var attachFileUrl: ""
    property bool isContactBlocked: false
    property bool canSend: root.chat && root.chat.canSend
    property bool isContactRequest: root.chat && root.chat.isContactRequest
    readonly property string vChatUrl: root.context.getConfig("webrtc_instance")
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
            action: Action {
                shortcut: "Ctrl+O"
                onTriggered: {
                    if (attachButton.enabled) {
                        root.focus = true;
                        attachButton.focus = true;
                        attachButton.clicked();
                    }
                }
            }
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
            id: sendVChatUrl
            enabled: vChatUrl.length > 0 ? true : false
            visible: root.canSend
            hoverEnabled: true
            ToolTip.visible: hovered
            ToolTip.text: "Send videochat invitation"
            text: "📞"
            Layout.preferredWidth: attachButton.width / 2
            Layout.alignment: Qt.AlignBottom
            font.pixelSize: 20
            onClicked: {
                if(vChatUrl.length > 0)
                    root.context.sendVChatInv(chatId);
            }
        }

        Button {
            id: sendButton
            action: Kirigami.Action {
                checked: false
                shortcut: "Ctrl+S"
                onTriggered:{
                    if (sendButton.enabled) {
                        root.focus = true;
                        sendButton.focus = true;
                        sendButton.down = true;
                        sendButton.clicked();
                        sendButton.down = false;
                    }
                }
            }
            hoverEnabled: true
            ToolTip.visible: hovered
            ToolTip.text: "Ctrl+S"
            visible: root.canSend
            Layout.alignment: Qt.AlignBottom
            icon.name: "document-send"
            text: qsTr("Send")
            enabled: messageField.length > 0 | attachFileUrl.length > 0
            onClicked: {
                let msg = root.createMessage();
                root.context.sendMessage(root.chatId, msg);
                attachFileUrl = "";
                messageField.text = "";
                root.context.setDraft(chatId, null);
            }
        }

        Button {
            id: acceptCBtn
            Layout.alignment: Qt.AlignBottom
            Layout.fillWidth: true
            text: "Accept"
            onClicked: {
                root.context.acceptChat(root.chatId);
                root.isContactBlocked = 0;
            }
            visible: root.isContactRequest
            icon.name: "call-start"
        }

        Button {
            id: blockCBtn
            Layout.alignment: Qt.AlignBottom
            Layout.fillWidth: true
            text: "Block"
            onClicked: {
                root.context.blockChat(root.chatId)
                updateChatlist();
                acceptCBtn.visible = false;
                blockCBtn.visible = false;
                root.isContactBlocked = true;
            }
            visible: root.isContactRequest
            icon.name: "call-stop"
        }

        
        TextEdit {
            selectByMouse: true
            readOnly: true
            text: "This contact has been blocked.<br>You can see who you've blocked <br>in 'Settings' > 'View blocked users'"
            font.bold: true
            textFormat: TextEdit.RichText
            visible: root.isContactBlocked
            Layout.preferredWidth: root.width
            Layout.maximumWidth: root.width
            horizontalAlignment: TextEdit.AlignHCenter
            padding: Kirigami.Units.largeSpacing
        }
    }

}
