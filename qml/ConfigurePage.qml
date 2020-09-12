import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14
import QtQml.Models 2.1
import org.kde.kirigami 2.12 as Kirigami

Kirigami.Page {
    title: qsTr("Configure account")

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
            }
        }
    }
}
