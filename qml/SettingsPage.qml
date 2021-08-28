import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.12 as Kirigami

import DeltaChat 1.0

Kirigami.Page {
    id: settingsPageRoot

    title: "Settings"

    required property DcContext context

    Kirigami.FormLayout {
        anchors.fill: parent

        Image {
            Kirigami.FormData.label: "Avatar: "

            source: "file:" + settingsPageRoot.context.getConfig("selfavatar")
        }

        TextField {
            id: displayNameField

            Kirigami.FormData.label: "Name: "
            text: settingsPageRoot.context.getConfig("displayname")
            onEditingFinished: settingsPageRoot.context.setConfig("displayname", text)
        }

        TextArea {
            Kirigami.FormData.label: "Signature: "

            text: settingsPageRoot.context.getConfig("selfstatus")
            onEditingFinished: settingsPageRoot.context.setConfig("selfstatus", text)
            selectByMouse: true
        }

        Switch {
            text: "Prefer end-to-end encryption"
            checked: settingsPageRoot.context.getConfig("e2ee_enabled") == "1"
            onToggled: settingsPageRoot.context.setConfig("e2ee_enabled", checked ? "1" : "0")
        }

        Switch {
            text: "Read receipts"
            checked: settingsPageRoot.context.getConfig("mdns_enabled") == "1"
            onToggled: settingsPageRoot.context.setConfig("mdns_enabled", checked ? "1" : "0")
        }

        Switch {
            text: "Watch Inbox"
            checked: settingsPageRoot.context.getConfig("inbox_watch") == "1"
            onToggled: settingsPageRoot.context.setConfig("inbox_watch", checked ? "1" : "0")
        }

        Switch {
            text: "Watch Sent"
            checked: settingsPageRoot.context.getConfig("sentbox_watch") == "1"
            onToggled: settingsPageRoot.context.setConfig("sentbox_watch", checked ? "1" : "0")
        }

        Switch {
            text: "Watch DeltaChat"
            checked: settingsPageRoot.context.getConfig("mvbox_watch") == "1"
            onToggled: settingsPageRoot.context.setConfig("mvbox_watch", checked ? "1" : "0")
        }

        Switch {
            text: "Send copy to self"
            checked: settingsPageRoot.context.getConfig("bcc_self") == "1"
            onToggled: settingsPageRoot.context.setConfig("bcc_self", checked ? "1" : "0")
        }

        Switch {
            text: "Move to DeltaChat"
            checked: settingsPageRoot.context.getConfig("mvbox_move") == "1"
            onToggled: settingsPageRoot.context.setConfig("mvbox_move", checked ? "1" : "0")
        }

        ComboBox {
            Kirigami.FormData.label: "Show classic emails: "

            model: ListModel {
                id: certificateChecksModel
                ListElement { text: "No, chats only" }
                ListElement { text: "For accepted contacts" }
                ListElement { text: "All" }
            }
            textRole: "text"
            currentIndex: settingsPageRoot.context.getConfig("show_emails")
            onActivated: settingsPageRoot.context.setConfig("show_emails", currentIndex)
        }
    }
}
