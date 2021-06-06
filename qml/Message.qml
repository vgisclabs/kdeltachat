import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQml.Models 2.1
import QtQuick.Dialogs 1.1
import QtMultimedia 5.8
import org.kde.kirigami 2.12 as Kirigami

import DeltaChat 1.0

RowLayout {
    id: messageObject

    property DcMessage message
    property DcContext context

    readonly property DcContact from: context.getContact(message.fromId)
    readonly property DcMessage quoteMessage: message.quotedMessage
    readonly property DcContact quoteFrom: quoteMessage ? context.getContact(quoteMessage.fromId) : null

    width: ListView.view.width
    layoutDirection: message.fromId == 1 ? Qt.RightToLeft : Qt.LeftToRight

    readonly property string overrideName: message.getOverrideSenderName()
    readonly property string displayName: overrideName != "" ? ("~" + overrideName)
                                                             : messageObject.message.fromId > 0 ? messageObject.from.displayName
                                                                                                : ""

    Component.onCompleted: {
        // Only try to mark fresh and noticed messages as seen to
        // avoid unnecessary database calls when viewing an already read chat.
        if ([10, 13].includes(messageObject.message.state)) {
            // Do not mark DC_CHAT_ID_DEADDROP messages as seen to
            // avoid contact request chat disappearing from chatlist.
            if (messageObject.chatId != 1) {
                messageObject.context.markseenMsgs([messageObject.message.id])
            }
        }
    }

    Rectangle {
        Layout.leftMargin: Kirigami.Units.largeSpacing
        Layout.preferredWidth: messageContents.width
        Layout.preferredHeight: messageContents.height
        color: Kirigami.Theme.backgroundColor
        radius: 5

        Component {
            id: imageMessageView

            ColumnLayout {
                Image {
                    source: "file:" + messageObject.message.file
                    sourceSize.width: messageObject.message.width
                    sourceSize.height: messageObject.message.height
                    fillMode: Image.PreserveAspectCrop
                    Layout.maximumWidth: messageObject.width
                    Layout.maximumHeight: Kirigami.Units.gridUnit * 10
                    asynchronous: true
                }
                Label {
                    font.bold: true
                    color: messageObject.message.fromId > 0 ? messageObject.from.color : "black"
                    text: messageObject.displayName
                    textFormat: Text.PlainText
                }
            }
        }

        Component {
            id: audioMessageView

            ColumnLayout {
                MediaPlayer {
                    id: player
                    source: Qt.resolvedUrl("file:" + messageObject.message.file)
                    onError: console.log("Audio MediaPlayer error: " + errorString)
                }
                Label {
                    font.bold: true
                    text: "Audio"
                    textFormat: Text.PlainText
                }
                Button {
                    text: "play"
                    onPressed: player.play()
                }
            }
        }

        Component {
            id: videoMessageView

            ColumnLayout {
                MediaPlayer {
                    id: videoplayer
                    source: Qt.resolvedUrl("file:" + messageObject.message.file)
                    onError: console.log("Video MediaPlayer error: " + errorString)
                }
                VideoOutput {
                    source: videoplayer
                }
                Label {
                    font.bold: true
                    text: "Video"
                    textFormat: Text.PlainText
                }
                Button {
                    text: "play"
                    onPressed: videoplayer.play()
                }
            }
        }

        Component {
            id: textMessageView

            Label {
                font.bold: true
                color: messageObject.message.fromId > 0 ? messageObject.from.color : "black"
                text: messageObject.displayName
                textFormat: Text.PlainText
            }
        }

        MouseArea {
            anchors.fill: parent

            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: function(mouse) {
                if (mouse.button === Qt.RightButton)
                    contextMenu.popup()
            }
            onPressAndHold: function(mouse) {
                if (mouse.source === Qt.MouseEventNotSynthesized)
                    contextMenu.popup()
            }

            MessageDialog {
                id: messageDialog
                title: "Message info"
                text: messageObject.context.getMessageInfo(messageObject.message.id)
                onAccepted: { }
            }

            Menu {
                id: contextMenu
                Action {
                    text: "Info"
                    onTriggered: messageDialog.open()
                }
                Action {
                    text: "Start chat"
                    onTriggered: messageObject.context.decideOnContactRequest(messageObject.message.id, 0)
                }
            }
        }

        ColumnLayout {
            id: messageContents

            Loader {
                sourceComponent: [20, 21, 23].includes(messageObject.message.viewtype) ? imageMessageView
                : [40, 41].includes(messageObject.message.viewtype) ? audioMessageView
                : [50].includes(messageObject.message.viewtype) ? videoMessageView
                : textMessageView
            }

            // Quote
            RowLayout {
                Layout.leftMargin: Kirigami.Units.smallSpacing
                visible: messageObject.message.quotedText
                implicitHeight: quoteTextEdit.height
                spacing: Kirigami.Units.smallSpacing
                Rectangle {
                    width: Kirigami.Units.smallSpacing
                    color: messageObject.quoteFrom ? messageObject.quoteFrom.color : "black"
                    Layout.fillHeight: true
                }
                TextEdit {
                    id: quoteTextEdit
                    Layout.maximumWidth: messageObject.width > 30 ? messageObject.width - 30 : messageObject.width
                    text: messageObject.message.quotedText ? messageObject.message.quotedText : ""
                    textFormat: Text.PlainText
                    selectByMouse: true
                    readOnly: true
                    color: "grey"
                    wrapMode: Text.Wrap
                    font.pixelSize: 14
                }
            }

            // Message
            TextEdit {
                Layout.maximumWidth: messageObject.width > 30 ? messageObject.width - 30 : messageObject.width
                textFormat: Text.PlainText
                selectByMouse: true
                readOnly: true
                color: "black"
                wrapMode: Text.Wrap
                font.pixelSize: 14

                Component.onCompleted: {
                    text = messageObject.message.text
                }
            }
            Row {
                HtmlViewSheet {
                    id: htmlSheet
                    subject: ""
                    html: ""
                }

                Button {
                    text: "Show full message"
                    visible: messageObject.message.hasHtml
                    onPressed: {
                        htmlSheet.subject = messageObject.message.subject
                        htmlSheet.html = messageObject.context.getMessageHtml(messageObject.message.id)
                        htmlSheet.open()
                    }
                }
                Label {
                    Layout.fillWidth: true
                    text: messageObject.message.state == 26 ? "✓"
                        : messageObject.message.state == 28 ? "✓✓"
                        : messageObject.message.state == 24 ? "✗"
                        : "";
                }
            }
        }
    }
}
