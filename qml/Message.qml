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
    readonly property DcContact from: context.getContact(message.fromId)
    readonly property DcMessage quoteMessage: message.quotedMessage
    readonly property DcContact quoteFrom: quoteMessage ? context.getContact(quoteMessage.fromId) : null

    width: ListView.view.width
    layoutDirection: message.fromId == 1 ? Qt.RightToLeft : Qt.LeftToRight

    readonly property string overrideName: message.getOverrideSenderName()
    readonly property string displayName: overrideName != "" ? ("~" + overrideName)
                                                             : messageObject.message.fromId > 0 ? messageObject.from.displayName
                                                                                                : ""

    Rectangle {
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
            onClicked: {
                if (mouse.button === Qt.RightButton)
                    contextMenu.popup()
            }
            onPressAndHold: {
                if (mouse.source === Qt.MouseEventNotSynthesized)
                    contextMenu.popup()
            }

            MessageDialog {
                id: messageDialog
                title: "Message info"
                text: context.getMessageInfo(messageObject.message.id)
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
                    onTriggered: context.decideOnContactRequest(message.id, 0)
                }
            }
        }

        ColumnLayout {
            id: messageContents

            Loader {
                sourceComponent: [20, 21, 23].includes(messageObject.message.viewtype) ? imageMessageView
                  : [40, 41].includes(messageObject.message.viewtype) ? audioMessageView : textMessageView
            }

            // Quote
            RowLayout {
                Layout.leftMargin: Kirigami.Units.smallSpacing
                visible: messageObject.message.quotedText
                implicitHeight: quoteTextEdit.height
                spacing: Kirigami.Units.smallSpacing
                Rectangle {
                    width: Kirigami.Units.smallSpacing
                    color: quoteFrom ? quoteFrom.color : "black"
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
                    font.pixelSize: 12
                }
            }

            // Message
            TextEdit {
                Layout.maximumWidth: messageObject.width > 30 ? messageObject.width - 30 : messageObject.width
                text: messageObject.message.text
                textFormat: Text.PlainText
                selectByMouse: true
                readOnly: true
                color: "black"
                wrapMode: Text.Wrap
                font.pixelSize: 14
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
