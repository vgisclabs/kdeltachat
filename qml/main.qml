import QtQuick 2.12
import QtQuick.Controls 2.12 as Controls
import org.kde.kirigami 2.12 as Kirigami

import DeltaChat 1.0


Kirigami.ApplicationWindow {
    id: root

    property DcAccountsEventEmitter eventEmitter

    title: qsTr("Delta Chat")

    Component {id: accountsPage; AccountsPage {}}

    pageStack.initialPage: Kirigami.Page {}

    globalDrawer: Kirigami.GlobalDrawer {
        header: Controls.Switch {
            text: "Work offline"
            onCheckedChanged: {
                if (checked) {
                    dcAccounts.stopIo()
                } else {
                    dcAccounts.startIo()
                }
            }
        }

        actions: [
            Kirigami.Action {
                text: "Maybe network"
                iconName: "view-refresh"
                onTriggered: dcAccounts.maybeNetwork()
            },
            Kirigami.Action {
                text: "Switch account"
                iconName: "system-switch-user"
                onTriggered: pageStack.layers.push(accountsPage)
            }
        ]
    }

    contextDrawer: Kirigami.ContextDrawer {
        id: contextDrawer
    }

    DcAccounts {
        id: dcAccounts
    }

    Component.onCompleted: {
        console.log('starting')
        eventEmitter = dcAccounts.getEventEmitter()
        eventEmitter.start();

        // Open selected account if there is one.
        let selectedAccount = dcAccounts.getSelectedAccount();
        if (selectedAccount) {
            if (selectedAccount.isConfigured()) {
                pageStack.replace("qrc:/qml/ChatlistPage.qml", {context: selectedAccount, eventEmitter: eventEmitter})
            } else {
                pageStack.replace("qrc:/qml/ConfigurePage.qml", {context: selectedAccount, eventEmitter: eventEmitter})
            }
        }

        dcAccounts.startIo()
    }

    onClosing: {
        // Cancel all tasks that may block the termination of event loop.
        dcAccounts.stopIo()
    }
}
