import DeltaChat 1.0
import QtQml.Models 2.1
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.13 as Kirigami

ItemDelegate {
    id: root

    property DcContext context
    property int chatId
    property string chatName
    property string avatarSource
    property string username
    property int freshMsgCnt
    property bool isContactRequest
    property bool isPinned

    contentItem: RowLayout {
        Kirigami.Avatar {
            source: root.avatarSource
            name: root.chatName
            color: root.context.getChat(root.chatId).getColor()

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.RightButton
                onClicked: {
                    if (mouse.button === Qt.RightButton)
                        contextMenu.popup();

                }

                Menu {
                    id: contextMenu

                    Action {
                        icon.name: "pin"
                        text: "Pin chat"
                        onTriggered: root.context.setChatVisibility(root.chatId, 2)
                    }

                    Action {
                        text: "Unpin chat"
                        onTriggered: root.context.setChatVisibility(root.chatId, 0)
                    }

                    Action {
                        text: "Archive chat"
                        onTriggered: root.context.setChatVisibility(root.chatId, 1)
                    }

                    Action {
                        text: "Unarchive chat"
                        onTriggered: root.context.setChatVisibility(root.chatId, 0)
                    }

                    Action {
                        icon.name: "delete"
                        text: "Delete chat"
                        onTriggered: root.context.deleteChat(root.chatId)
                    }

                }

            }

        }

        ColumnLayout {
            Layout.fillWidth: true

            Label {
                text: root.context.getChat(root.chatId).getName()
                font.weight: Font.Bold
                Layout.fillWidth: true
            }

            Label {
                text: root.username
                font: Kirigami.Theme.smallFont
                Layout.fillWidth: true
            }

        }

        Label {
            text: root.isContactRequest ? "NEW" : root.freshMsgCnt
            visible: root.freshMsgCnt > 0 || root.isContactRequest
            // Align label in the center of a badge.
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            // Make sure badge is not too narrow.
            Layout.minimumWidth: height

            background: Rectangle {
                color: Kirigami.Theme.alternateBackgroundColor
                radius: 0.25 * height
            }

        }

        // "Pinned" badge
        Rectangle {
            visible: root.isPinned
            color: Kirigami.Theme.alternateBackgroundColor
            width: Kirigami.Units.gridUnit
            height: Kirigami.Units.gridUnit
            radius: 0.25 * height

            Kirigami.Icon {
                source: "pin"
                height: Kirigami.Units.gridUnit
                width: Kirigami.Units.gridUnit
            }

        }

    }

}
