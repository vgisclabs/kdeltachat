import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.12 as Kirigami

Kirigami.Page {
    id: root

    function updateAccounts() {
        let accountsList = dcAccounts.getAll();
        accountsModel.clear();
        for (let i = 0; i < accountsList.length; i++) {
            let accountId = accountsList[i];
            let title;
            let context = dcAccounts.getAccount(accountId);
            if (context.isConfigured())
                title = context.getConfig("addr");
            else
                title = `Unconfigured ${accountId}`;
            accountsModel.insert(i, {
                "number": accountId,
                "title": title
            });
        }
    }

    title: qsTr("Accounts")
    Component.onCompleted: {
        updateAccounts();
    }

    ListModel {
        id: accountsModel
    }

    ListView {
        id: accountsListView

        anchors.fill: parent
        model: accountsModel
        currentIndex: -1

        delegate: ItemDelegate {
            width: accountsListView.width
            onClicked: {
                while (pageStack.depth > 1)
                    pageStack.pop();

                dcAccounts.selectAccount(model.number);
                let context = dcAccounts.getSelectedAccount();
                if (context.isConfigured())
                    pageStack.replace("qrc:/qml/ChatlistPage.qml", {
                        "context": context,
                        "eventEmitter": eventEmitter
                    });
                else
                    pageStack.replace("qrc:/qml/ConfigurePage.qml", {
                        "context": context,
                        "eventEmitter": eventEmitter
                    });
                pageStack.layers.pop();
            }

            contentItem: RowLayout {
                Label {
                    Layout.fillWidth: true
                    text: model.title
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                Button {
                    icon.name: "delete"
                    text: "Delete"
                    onClicked: {
                        dcAccounts.removeAccount(model.number);
                        accountsModel.remove(model.index);
                    }
                }

            }

        }

    }

    Menu {
        id: contextMenu

        MenuItem {
            text: "Import account"
        }

    }

    mainAction: Kirigami.Action {
        iconName: "list-add-user"
        text: "Add account"
        onTriggered: {
            let accountId = dcAccounts.addAccount();
            let context = dcAccounts.getAccount(accountId);
            let title;
            if (context.isConfigured())
                title = context.getConfig("addr");
            else
                title = `Unconfigured ${accountId}`;
            accountsModel.insert(accountsModel.count, {
                "number": accountId,
                "title": title
            });
        }
    }

}
