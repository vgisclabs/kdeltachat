import DeltaChat 1.0
import QtMultimedia 5.8
import QtQml.Models 2.1
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.1
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.12 as Kirigami

RowLayout {
    id: root

    property DcMessage message
    property DcContext context
    readonly property DcContact from: context.getContact(message.fromId)
    readonly property DcMessage quoteMessage: message.quotedMessage
    readonly property DcContact quoteFrom: quoteMessage ? context.getContact(quoteMessage.fromId) : null
    readonly property string overrideName: message.getOverrideSenderName()
    readonly property string displayName: overrideName != "" ? ("~" + overrideName)
                                                             : root.message.fromId > 0 ? root.from.displayName
                                                                                                : ""

    layoutDirection: message.fromId == 1 ? Qt.RightToLeft : Qt.LeftToRight
    Component.onCompleted: {
        // Only try to mark fresh and noticed messages as seen to
        // avoid unnecessary database calls when viewing an already read chat.
        if ([10, 13].includes(root.message.state)) {
            // Do not mark DC_CHAT_ID_DEADDROP messages as seen to
            // avoid contact request chat disappearing from chatlist.
            if (root.chatId != 1)
                root.context.markseenMsgs([root.message.id]);

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
                    source: "file:" + root.message.file
                    sourceSize.width: root.message.width
                    sourceSize.height: root.message.height
                    fillMode: Image.PreserveAspectCrop
                    Layout.preferredWidth: root.width
                    Layout.maximumWidth: Kirigami.Units.gridUnit * 30
                    Layout.maximumHeight: Kirigami.Units.gridUnit * 20
                    asynchronous: true

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Qt.openUrlExternally("file:" + root.message.file)
                    }

                }

                Label {
                    font.bold: true
                    color: root.message.fromId > 0 ? root.from.color : "black"
                    text: root.displayName
                    textFormat: Text.PlainText
                }

            }

        }

        Component {
            id: audioMessageView

            ColumnLayout {
                MediaPlayer {
                    id: player

                    source: Qt.resolvedUrl("file:" + root.message.file)
                    onError: console.log("Audio MediaPlayer error: " + errorString)
                    onPlaybackStateChanged: playbackState == 1 ? audioBtn.text = "pause" : audioBtn.text = "play"
                }

                Label {
                    font.bold: true
                    text: "Audio - " + root.message.filename
                    textFormat: Text.PlainText
                }

                Button {
                    id: audioBtn

                    text: "play"
                    onPressed: player.playbackState == 1 ? player.pause() : player.play()
                }

            }

        }

        Component {
            id: videoMessageView

            ColumnLayout {
                MediaPlayer {
                    id: videoplayer

                    source: Qt.resolvedUrl("file:" + root.message.file)
                    onError: console.log("Video MediaPlayer error: " + errorString)
                }

                VideoOutput {
                    source: videoplayer
                }

                Label {
                    font.bold: true
                    text: "Video - " + root.message.filename
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
                color: root.message.fromId > 0 ? root.from.color : "black"
                text: root.displayName
                textFormat: Text.PlainText
            }

        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: function(mouse) {
                if (mouse.button === Qt.RightButton)
                    contextMenu.popup();

            }
            onPressAndHold: function(mouse) {
                if (mouse.source === Qt.MouseEventNotSynthesized)
                    contextMenu.popup();

            }

            MessageDialog {
                id: messageDialog

                title: "Message info"
                text: root.context.getMessageInfo(root.message.id)
                onAccepted: {
                }
            }

            Menu {
                id: contextMenu

                Action {
                    text: "Info"
                    onTriggered: messageDialog.open()
                }

            }

        }

        ColumnLayout {
            id: messageContents

            Loader {
                sourceComponent: [20, 21, 23].includes(root.message.viewtype) ? imageMessageView
                : [40, 41].includes(root.message.viewtype) ? audioMessageView
                : [50].includes(root.message.viewtype) ? videoMessageView
                : textMessageView
            }

            // Quote
            RowLayout {
                Layout.leftMargin: Kirigami.Units.smallSpacing
                visible: root.message.quotedText
                implicitHeight: quoteTextEdit.height
                spacing: Kirigami.Units.smallSpacing

                Rectangle {
                    width: Kirigami.Units.smallSpacing
                    color: root.quoteFrom ? root.quoteFrom.color : "black"
                    Layout.fillHeight: true
                }

                TextEdit {
                    id: quoteTextEdit

                    Layout.maximumWidth: Kirigami.Units.gridUnit * 30
                    text: root.message.quotedText ? root.message.quotedText : ""
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
                Layout.maximumWidth: Math.min(root.width, Kirigami.Units.gridUnit * 30)
                textFormat: Text.PlainText
                selectByMouse: true
                readOnly: true
                color: "black"
                wrapMode: Text.Wrap
                font.pixelSize: 14
                Component.onCompleted: {
                    text = root.message.text;
                }
            }

            Button {
                text: "Show full message"
                visible: root.message.hasHtml
                onPressed: {
                    htmlSheet.subject = root.message.subject;
                    htmlSheet.html = root.context.getMessageHtml(root.message.id);
                    htmlSheet.open();
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignRight

                HtmlViewSheet {
                    id: htmlSheet

                    subject: ""
                    html: ""
                }

                Kirigami.Icon {
                    source: "computer"
                    visible: root.message.isBot
                    Layout.preferredHeight: Kirigami.Units.gridUnit
                    Layout.preferredWidth: Kirigami.Units.gridUnit
                }

                Kirigami.Icon {
                    source: root.message.showPadlock ? "lock" : "unlock"
                    Layout.preferredHeight: Kirigami.Units.gridUnit
                    Layout.preferredWidth: Kirigami.Units.gridUnit
                }

                Label {
                    font.pixelSize: 14
                    color: Kirigami.Theme.disabledTextColor
                    text: Qt.formatDateTime(root.message.timestamp, "dd. MMM yyyy, hh:mm")
                        + (root.message.state == 26 ? "✓"
                        : root.message.state == 28 ? "✓✓"
                        : root.message.state == 24 ? "✗"
                        : "");
                }

            }

        }

    }

}
