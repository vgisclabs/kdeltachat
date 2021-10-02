import DeltaChat 1.0
import QtQml.Models 2.1
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.12 as Kirigami

Kirigami.ScrollablePage {
    id: root

    required property DcContext context
    required property DcAccountsEventEmitter eventEmitter

    title: qsTr("Configure account")
    contextualActions: [
        Kirigami.Action {
            text: "Import backup"
            iconName: "document-import"
            onTriggered: importBackupDialog.open()
        }
    ]

    Kirigami.FormLayout {
        TextField {
            id: addressField

            Kirigami.FormData.label: "Address: "
        }

        TextField {
            id: passwordField

            Kirigami.FormData.label: "Password: "
            echoMode: TextInput.PasswordEchoOnEdit
        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: "Advanced settings"
        }

        TextField {
            id: imapLoginField

            Kirigami.FormData.label: "IMAP login: "
        }

        TextField {
            id: imapHostnameField

            Kirigami.FormData.label: "IMAP server: "
        }

        TextField {
            id: imapPortField

            Kirigami.FormData.label: "IMAP port: "
        }

        ListModel {
            id: securityModel

            ListElement {
                text: "Automatic"
                value: 0
            }

            ListElement {
                text: "SSL/TLS"
                value: 1
            }

            ListElement {
                text: "StartTLS"
                value: 2
            }

            ListElement {
                text: "Off"
                value: 3
            }

        }

        ComboBox {
            id: imapSecurity

            Kirigami.FormData.label: "IMAP security: "
            model: securityModel
            textRole: "text"
        }

        TextField {
            id: smtpLoginField

            Kirigami.FormData.label: "SMTP login: "
        }

        TextField {
            id: smtpPasswordField

            Kirigami.FormData.label: "SMTP password: "
            echoMode: TextInput.PasswordEchoOnEdit
        }

        TextField {
            id: smtpHostnameField

            Kirigami.FormData.label: "SMTP server: "
        }

        TextField {
            id: smtpPortField

            Kirigami.FormData.label: "SMTP port: "
        }

        ComboBox {
            id: smtpSecurity

            Kirigami.FormData.label: "SMTP security: "
            model: securityModel
            textRole: "text"
        }

        ComboBox {
            id: certificateChecks

            Kirigami.FormData.label: "Certificate checks: "
            textRole: "text"

            model: ListModel {
                id: certificateChecksModel

                ListElement {
                    text: "Automatic"
                    value: 0
                }

                ListElement {
                    text: "Strict"
                    value: 1
                }

                ListElement {
                    text: "Accept invalid certificates"
                    value: 2
                }

            }

        }

        Switch {
            id: socks5Enabled

            text: "SOCKS5 enabled"
        }

        TextField {
            id: socks5Host

            Kirigami.FormData.label: "SOCKS5 host: "
        }

        TextField {
            id: socks5Port

            Kirigami.FormData.label: "SOCKS5 port: "
        }

        TextField {
            id: socks5Username

            Kirigami.FormData.label: "SOCKS5 username: "
        }

        TextField {
            id: socks5Password

            Kirigami.FormData.label: "Password: "
            echoMode: TextInput.PasswordEchoOnEdit
        }

        ProgressBar {
            id: progressBar

            value: 0
        }

        Button {
            text: "Login"
            onClicked: {
                console.log("Login");
                root.context.stopIo();
                root.context.setConfig("addr", addressField.text);
                root.context.setConfig("mail_pw", passwordField.text);
                root.context.setConfig("mail_user", imapLoginField.text);
                root.context.setConfig("mail_server", imapHostnameField.text);
                root.context.setConfig("mail_port", imapPortField.text);
                root.context.setConfig("mail_security", securityModel.get(imapSecurity.currentIndex).value);
                root.context.setConfig("send_user", smtpLoginField.text);
                root.context.setConfig("send_pw", smtpPasswordField.text);
                root.context.setConfig("send_server", smtpHostnameField.text);
                root.context.setConfig("send_port", smtpPortField.text);
                root.context.setConfig("send_security", securityModel.get(smtpSecurity.currentIndex).value);
                let certificate_checks = certificateChecks.model.get(certificateChecks.currentIndex).value;
                root.context.setConfig("imap_certificate_checks", certificate_checks);
                root.context.setConfig("smtp_certificate_checks", certificate_checks);
                root.context.setConfig("socks5_enabled", socks5Enabled.checked ? "1" : "0");
                root.context.setConfig("socks5_host", socks5Host.text);
                root.context.setConfig("socks5_port", socks5Port.text);
                root.context.setConfig("socks5_user", socks5Username.text);
                root.context.setConfig("socks5_password", socks5Password.text);
                root.context.configure();
            }
        }

        FileDialog {
            id: importBackupDialog

            title: "Import backup"
            folder: shortcuts.home
            onAccepted: {
                var url = importBackupDialog.fileUrl.toString();
                if (url.startsWith("file://")) {
                    var filename = url.substring(7);
                    console.log("Importing " + filename);
                    root.context.importBackup(filename);
                }
            }
        }

        Connections {
            function onConfigureProgress(accountId, progress, comment) {
                progressBar.value = progress / 1000;
                if (progress == 1000)
                    root.context.startIo();

            }

            function onImexProgress(accountId, progress) {
                progressBar.value = progress / 1000;
                if (progress == 1000)
                    root.context.startIo();

            }

            target: root.eventEmitter
        }

    }

}
