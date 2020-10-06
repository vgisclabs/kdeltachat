import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.0
import org.kde.kirigami 2.12 as Kirigami

Kirigami.Page {
    id: accountsPage

    title: qsTr("Accounts")

    mainAction: Kirigami.Action {
        iconName: "list-add-user"
        text: "Add account"
        onTriggered: accountsModel.addAccount()
    }

    contextualActions: [
        Kirigami.Action {
            text: "Import account"
            iconName: "document-import"
            onTriggered: importAccountDialog.open()
        }
    ]

    FileDialog {
        id: importAccountDialog
        title: "Import account"
        onAccepted: {
            var url = importAccountDialog.fileUrl.toString()
            if (url.startsWith("file://")) {
                var filename = url.substring(7)
                console.log("Importing " + filename)
                var accountId = accountsModel.importAccount (filename)
                if (accountId == 0) {
                    console.log("Import failed")
                } else {
                    console.log("Import succeeded")
                }
            }
        }
    }

    ListView {
        id: accountsListView
        anchors.fill: parent
        model: accountsModel

        delegate: RowLayout {
            width: accountsListView.width

            Label {
                Layout.fillWidth: true
                text: model.number
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            Button {
                width: 100
                text: "Select"
                onClicked: {
                   while (pageStack.depth > 1) {
                       pageStack.pop()
                   }
                   accountsModel.selectedAccount = model.number
                   let context = accountsModel.getSelectedAccount()
                   if (context.isConfigured()) {
                       pageStack.push("qrc:/qml/ChatlistPage.qml", {context: context})
                   } else {
                       pageStack.push("qrc:/qml/ConfigurePage.qml", {})
                   }
                }
             }

             Button {
                 width: 100
                 text: "Delete"
                 onClicked: accountsModel.removeAccount(model.number)
             }
        }
    }

    Menu {
        id: contextMenu
        MenuItem { text: "Import account" }
    }
}
