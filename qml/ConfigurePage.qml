import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQml.Models 2.1
import QtQuick.Dialogs 1.3
import org.kde.kirigami 2.12 as Kirigami

import DeltaChat 1.0

Kirigami.Page {
    title: qsTr("Configure account")
    id: configurePage

    required property DcContext context
    required property DcAccountsEventEmitter eventEmitter

    contextualActions: [
        Kirigami.Action {
            text: "Import backup"
            iconName: "document-import"
            onTriggered: importBackupDialog.open()
        }
    ]

    FileDialog {
        id: importBackupDialog
        title: "Import backup"
        folder: shortcuts.home
        onAccepted: {
            var url = importBackupDialog.fileUrl.toString()
            if (url.startsWith("file://")) {
                var filename = url.substring(7)
                console.log("Importing " + filename)
                configurePage.context.importBackup(filename)
            }
        }
    }

    Kirigami.FormLayout {
        anchors.fill: parent

        TextField {
            id: addressField

            Kirigami.FormData.label: "Address: "
        }
        TextField {
            id: passwordField

            Kirigami.FormData.label: "Password: "

            echoMode: TextInput.PasswordEchoOnEdit
        }
        ProgressBar {
            id: progressBar
            value: 0.0
        }
        Button {
            text: "Login"
            onClicked: {
                console.log("Login")
                configurePage.context.stopIo()
                configurePage.context.setConfig("addr", addressField.text)
                configurePage.context.setConfig("mail_pw", passwordField.text)
                configurePage.context.configure()
            }
        }
    }

    Connections {
        target: configurePage.eventEmitter
        function onConfigureProgress(accountId, progress, comment) {
            progressBar.value = progress / 1000.0
        }
    }
}
