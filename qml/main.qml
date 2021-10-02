import DeltaChat 1.0
import QtQuick 2.12
import QtQuick.Controls 2.12 as Controls
import org.kde.kirigami 2.12 as Kirigami

Kirigami.ApplicationWindow {
    id: root

    property DcAccountsEventEmitter eventEmitter

    title: qsTr("Delta Chat")
    Component.onCompleted: {
        console.log('starting');
        // Create an account if there is none.
        if (dcAccounts.getSelectedAccount() == null) {
            console.log("Adding first account");
            dcAccounts.addAccount();
        }
        eventEmitter = dcAccounts.getEventEmitter();
        eventEmitter.start();
        // Open selected account if there is one.
        let selectedAccount = dcAccounts.getSelectedAccount();
        if (selectedAccount) {
            if (selectedAccount.isConfigured())
                pageStack.replace("qrc:/qml/ChatlistPage.qml", {
                    "context": selectedAccount,
                    "eventEmitter": eventEmitter
                });
            else
                pageStack.replace("qrc:/qml/ConfigurePage.qml", {
                    "context": selectedAccount,
                    "eventEmitter": eventEmitter
                });
        }
        dcAccounts.startIo();
    }
    onClosing: {
        // Cancel all tasks that may block the termination of event loop.
        dcAccounts.stopIo();
    }

    Component {
        id: accountsPage

        AccountsPage {
        }

    }

    DcAccounts {
        id: dcAccounts
    }

    pageStack.initialPage: Kirigami.Page {
    }

    globalDrawer: Kirigami.GlobalDrawer {
        actions: [
            Kirigami.Action {
                text: "Maybe network"
                iconName: "view-refresh"
                onTriggered: dcAccounts.maybeNetwork()
            },
            Kirigami.Action {
                text: "Switch account"
                iconName: "system-switch-user"
                onTriggered: {
                    while (pageStack.layers.depth > 1)
                        pageStack.layers.pop();

                    pageStack.layers.push(accountsPage);
                }
            }
        ]

        header: Controls.Switch {
            text: "Work offline"
            onCheckedChanged: {
                if (checked)
                    dcAccounts.stopIo();
                else
                    dcAccounts.startIo();
            }
        }

    }

    contextDrawer: Kirigami.ContextDrawer {
        id: contextDrawer
    }

}
