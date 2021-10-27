import DeltaChat 1.0
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.12 as Kirigami

Kirigami.ScrollablePage {
    id: root

    required property DcContext context

    title: "Settings"

    Kirigami.FormLayout {
        Image {
            id: pfp

            Kirigami.FormData.label: "Avatar: "
            source: "file:" + root.context.getConfig("selfavatar")
        }

        FileDialog {
            id: changePfpDialog

            folder: shortcuts.pictures
            nameFilters: ["Image files (*.jpg *.png *.gif)"]
            onAccepted: {
                var url = changePfpDialog.fileUrl.toString();
                if (url.startsWith("file://") && url.length > 0) {
                    var filename = url.substring(7);
                    console.log("Set avatar to : " + filename);
                    root.context.setConfig("selfavatar", filename);
                    pfp.source = "file:" + root.context.getConfig("selfavatar");
                }
            }
        }

        Button {
            id: changePfpBtn

            text: "Change avatar"
            icon.name: "avatar-default"
            hoverEnabled: true
            onClicked: changePfpDialog.open()
        }

        TextField {
            id: displayNameField

            Kirigami.FormData.label: "Name: "
            text: root.context.getConfig("displayname")
            onEditingFinished: root.context.setConfig("displayname", text)
        }

        TextArea {
            Kirigami.FormData.label: "Signature: "
            text: root.context.getConfig("selfstatus")
            onEditingFinished: root.context.setConfig("selfstatus", text)
            selectByMouse: true
        }

        Switch {
            text: "Prefer end-to-end encryption"
            checked: root.context.getConfig("e2ee_enabled") == "1"
            onToggled: root.context.setConfig("e2ee_enabled", checked ? "1" : "0")
        }

        Switch {
            text: "Read receipts"
            checked: root.context.getConfig("mdns_enabled") == "1"
            onToggled: root.context.setConfig("mdns_enabled", checked ? "1" : "0")
        }

        Switch {
            text: "Watch Inbox"
            checked: root.context.getConfig("inbox_watch") == "1"
            onToggled: root.context.setConfig("inbox_watch", checked ? "1" : "0")
        }

        Switch {
            text: "Watch Sent"
            checked: root.context.getConfig("sentbox_watch") == "1"
            onToggled: root.context.setConfig("sentbox_watch", checked ? "1" : "0")
        }

        Switch {
            text: "Watch DeltaChat"
            checked: root.context.getConfig("mvbox_watch") == "1"
            onToggled: root.context.setConfig("mvbox_watch", checked ? "1" : "0")
        }

        Switch {
            text: "Send copy to self"
            checked: root.context.getConfig("bcc_self") == "1"
            onToggled: root.context.setConfig("bcc_self", checked ? "1" : "0")
        }

        Switch {
            text: "Move to DeltaChat"
            checked: root.context.getConfig("mvbox_move") == "1"
            onToggled: root.context.setConfig("mvbox_move", checked ? "1" : "0")
        }

        ComboBox {
            Kirigami.FormData.label: "Show classic emails: "
            textRole: "text"
            currentIndex: root.context.getConfig("show_emails")
            onActivated: root.context.setConfig("show_emails", currentIndex)

            model: ListModel {
                id: certificateChecksModel

                ListElement {
                    text: "No, chats only"
                }

                ListElement {
                    text: "For accepted contacts"
                }

                ListElement {
                    text: "All"
                }

            }

        }

        Switch {
            text: "SOCKS5 enabled"
            checked: settingsPageRoot.context.getConfig("socks5_enabled") == "1"
            onToggled: settingsPageRoot.context.setConfig("socks5_enabled", checked ? "1" : "0")
        }

        TextField {
            Kirigami.FormData.label: "SOCKS5 host: "
            text: settingsPageRoot.context.getConfig("socks5_host")
            onEditingFinished: settingsPageRoot.context.setConfig("socks5_host", text)
        }

        TextField {
            Kirigami.FormData.label: "SOCKS5 port: "
            text: settingsPageRoot.context.getConfig("socks5_port")
            onEditingFinished: settingsPageRoot.context.setConfig("socks5_port", text)
        }

        TextField {
            Kirigami.FormData.label: "SOCKS5 username: "
            text: settingsPageRoot.context.getConfig("socks5_user")
            onEditingFinished: settingsPageRoot.context.setConfig("socks5_user", text)
        }

        TextField {
            Kirigami.FormData.label: "SOCKS5 password: "
            echoMode: TextInput.PasswordEchoOnEdit
            text: settingsPageRoot.context.getConfig("socks5_password")
            onEditingFinished: settingsPageRoot.context.setConfig("socks5_password", text)
        }

    }

}
