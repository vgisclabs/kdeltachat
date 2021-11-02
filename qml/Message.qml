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
    property string saveAsUrl: ""
    property bool saveSuccess: false
    readonly property string attachFile: "file:" + root.message.fileReadOnly
    readonly property string attachFn: root.message.filename
    readonly property int maxW: Kirigami.Units.gridUnit * 30
    readonly property int maxH: Kirigami.Units.gridUnit * 20

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

    Popup {
        id: saveAsPopup

        modal: true
        focus: true
        anchors.centerIn: parent
        width: 400
        height: 100
        padding: 10
        onClosed: saveAsUrl = ""
        contentChildren: [
            Text {
                text: saveSuccess == true ? "Success !" : "Failure !"
                bottomPadding: 10
                font.bold: true
                font.pixelSize: 14
            },
            Text {
                text: saveSuccess == true ? "The file has been saved locally at <br><b>" + saveAsUrl + "</b>" : "An error was detected. Maybe you<br>dont have enough permissions to copy the file to <br><b>" + saveAsUrl + "</b>"
                topPadding: 20
                leftPadding: 10
                bottomPadding: 20
            }
        ]
    }

    FileDialog {
        id: saveAsDialog

        title: "Save attachment `" + attachFn + "` as ..."
        folder: shortcuts.home
        selectFolder: false
        selectExisting: false
        onAccepted: {
            var url = saveAsDialog.fileUrl.toString();
            if (url.startsWith("file://")) {
                saveAsUrl = url.substring(7);
                saveSuccess = root.message.saveAttach(saveAsUrl);
                saveAsPopup.open();
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
                Loader {
                    sourceComponent: textMessageView
                }

                Image {
                    source: attachFile
                    sourceSize.width: root.message.width
                    sourceSize.height: root.message.height
                    fillMode: Image.PreserveAspectCrop
                    Layout.preferredWidth: root.width
                    Layout.maximumWidth: maxW
                    Layout.maximumHeight: maxH
                    asynchronous: true

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Qt.openUrlExternally(attachFile)
                    }

                }

            }

        }

        Component {
            id: audioMessageView

            ColumnLayout {
                Loader {
                    sourceComponent: textMessageView
                }

                MediaPlayer {
                    id: player

                    source: attachFile
                    onError: console.log("Audio MediaPlayer error: " + errorString)
                    onPlaybackStateChanged: {
                        if (playbackState == 1)
                            audioBtn.text = "\u23F8 pause";
                        else
                            audioBtn.text = "\u25B6 play";
                    }
                }

                Label {
                    padding: 5
                    font.bold: true
                    text: "Audio - " + attachFn
                    textFormat: Text.PlainText
                }

                Button {
                    id: audioBtn

                    text: "\u25B6 play"
                    onPressed: {
                        if (player.playbackState == 1)
                            player.pause();
                        else
                            player.play();
                    }
                }

            }

        }

        Component {
            id: videoMessageView

            ColumnLayout {
                Loader {
                    sourceComponent: textMessageView
                }

                MediaPlayer {
                    id: videoplayer

                    autoPlay: true
                    autoLoad: true
                    muted: true
                    source: Qt.resolvedUrl(attachFile)
                    onError: console.log("Video MediaPlayer error: " + errorString)
                    // Credit to stackoverflow.com/questions/65909975/show-video-preview-thumbnail-of-video-using-qml for video thumbnail with Qt ver < Qt5.15
                    onStatusChanged: {
                        if (status == MediaPlayer.Buffered) {
                            pause();
                            seek(-1);
                        }
                        if (status == 7) {
                            pause();
                            seek(-1);
                        }
                    }
                }

                VideoOutput {
                    Layout.preferredWidth: root.width
                    Layout.preferredHeight: root.height
                    Layout.maximumWidth: maxW
                    Layout.maximumHeight: maxH
                    source: videoplayer

                    MouseArea {
                        cursorShape: Qt.PointingHandCursor
                        anchors.fill: parent
                        onClicked: {
                            videoplayer.muted = false;
                            if (videoplayer.playbackState == 1)
                                videoplayer.pause();
                            else
                                videoplayer.play();
                        }
                    }

                }

                Label {
                    padding: 5
                    font.bold: true
                    text: "Video - " + attachFn
                    textFormat: Text.PlainText
                }

            }

        }

        Component {
            id: gifView

            ColumnLayout {
                Loader {
                    sourceComponent: textMessageView
                }

                AnimatedImage {
                    source: Qt.resolvedUrl(attachFile)
                    fillMode: Image.PreserveAspectFit
                    Layout.maximumWidth: maxW
                    Layout.maximumHeight: maxH
                    asynchronous: true

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Qt.openUrlExternally("file:" + root.message.file)
                    }

                }

            }

        }

        Component {
            id: anyFileView

            ColumnLayout {
                Loader {
                    sourceComponent: textMessageView
                }

                Label {
                    padding: 5
                    font.bold: true
                    text: "File - " + attachFn
                }

                Button {
                    padding: 5
                    text: "<h1>\u2B07</h1> Save attachment"
                    onClicked: saveAsDialog.open()
                }

            }

        }

        Component {
            id: videoChatView
            ColumnLayout {
                Loader {
                    sourceComponent: textMessageView
                }
                
                Button {
                    text: "Join conference call"
                    icon.name: "call-start"
                    Layout.preferredWidth: root.width
                    Layout.maximumWidth: root.width
                    hoverEnabled: true
                    ToolTip.visible: hovered
                    ToolTip.text: "<u>"+root.message.videochatUrl+"</u>"
                    //Layout.leftMargin: 30
                    //Layout.rightMargin: 30
                    onClicked: Qt.openUrlExternally(root.message.videochatUrl)
                }
            }
        }

        // This is what show the display name in top of every messages
        Component {
            id: textMessageView

            Label {
                padding: 5
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

                Component.onCompleted: {
                    if (!attachFn.length > 0)
                        contextMenu.removeAction(saveAsContext);

                }

                Action {
                    text: "Info"
                    onTriggered: messageDialog.open()
                }

                Action {
                    id: saveAsContext

                    text: "Save attachment as ..."
                    onTriggered: saveAsDialog.open()
                }

            }

        }

        ColumnLayout {
            id: messageContents

            Loader {
                sourceComponent: [20, 23].includes(root.message.viewtype) ? imageMessageView
                : [21].includes(root.message.viewtype) ? gifView
                : [40, 41].includes(root.message.viewtype) ? audioMessageView
                : [50].includes(root.message.viewtype) ? videoMessageView
                : [60].includes(root.message.viewtype) ? anyFileView
                : [70].includes(root.message.viewtype) ? videoChatView
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
                    Layout.maximumWidth: maxW
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
                Layout.maximumWidth: Math.min(root.width, maxW)
                textFormat: Text.PlainText
                selectByMouse: true
                readOnly: true
                color: "black"
                wrapMode: Text.Wrap
                font.pixelSize: 14
                padding: 5
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
