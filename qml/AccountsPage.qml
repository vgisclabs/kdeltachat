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
        onTriggered: {
            let accountId = dcAccounts.addAccount()
            let context = dcAccounts.getAccount(accountId);

            let title;
            if (context.isConfigured()) {
                title = context.getConfig("addr");
            } else {
                title = `Unconfigured ${accountId}`
            }

            accountsModel.insert(accountsModel.count, {
                number: accountId,
                title: title
            })
        }
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
                var accountId = dcAccounts.importAccount(filename)
                if (accountId == 0) {
                    console.log("Import failed")
                } else {
                    console.log("Import succeeded")
                }
            }
        }
    }

    ListModel {
        id: accountsModel
    }

    function updateAccounts() {
        let accountsList = dcAccounts.getAll()

        accountsModel.clear()
        for (let i = 0; i < accountsList.length; i++) {
            let accountId = accountsList[i];
            let title;
            let context = dcAccounts.getAccount(accountId);
            if (context.isConfigured()) {
                title = context.getConfig("addr");
            } else {
                title = `Unconfigured ${accountId}`
            }

            accountsModel.insert(i, {
                number: accountId,
                title: title
            })
        }
    }

    Component.onCompleted: {
        updateAccounts()
    }

    ListView {
        id: accountsListView
        anchors.fill: parent
        model: accountsModel

        delegate: RowLayout {
            width: accountsListView.width

            Label {
                Layout.fillWidth: true
                text: model.title
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            Button {
                text: "Select"
                onClicked: {
                   while (pageStack.depth > 1) {
                       pageStack.pop()
                   }
                   dcAccounts.selectAccount(model.number)
                   let context = dcAccounts.getSelectedAccount()
                   if (context.isConfigured()) {
                       pageStack.push("qrc:/qml/ChatlistPage.qml", {context: context})
                   } else {
                       pageStack.push("qrc:/qml/ConfigurePage.qml", {context: context})
                   }
                }
             }

             Button {
                 text: "Delete"
                 onClicked: {
                     dcAccounts.removeAccount(model.number)
                     accountsModel.remove(model.index)
                 }
             }
        }
    }

    Menu {
        id: contextMenu
        MenuItem { text: "Import account" }
    }
}
