import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQml.Models 2.1
import org.kde.kirigami 2.12 as Kirigami

import DeltaChat 1.0

Kirigami.Page {
    title: qsTr("Configure account")
    id: configurePage

    required property DcContext context

    ColumnLayout {
        anchors.fill: parent

        TextField {
            id: addressField

            placeholderText: "Address"
        }
        TextField {
            id: passwordField

            placeholderText: "Password"
            echoMode: TextInput.PasswordEchoOnEdit
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
}
