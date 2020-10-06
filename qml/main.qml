import QtQuick 2.12
import QtQuick.Controls 2.12 as Controls
import org.kde.kirigami 2.12 as Kirigami

import DeltaChat 1.0


Kirigami.ApplicationWindow {
    id: root

    property DcAccountsEventEmitter eventEmitter

    title: qsTr("Delta Chat")

    pageStack.initialPage: AccountsPage {}

    globalDrawer: Kirigami.GlobalDrawer {
        header: Controls.Switch {
            text: "Start IO"
            onCheckedChanged: {
                if (checked) {
                    accountsModel.startIo()
                } else {
                    accountsModel.stopIo()
                }
            }
        }

        actions: [
            Kirigami.Action {
                text: "Maybe network"
                iconName: "view-refresh"
                onTriggered: accountsModel.maybeNetwork()
            }
        ]
    }

    contextDrawer: Kirigami.ContextDrawer {
        id: contextDrawer
    }

    AccountsModel {
        id: accountsModel
    }

    Component.onCompleted: {
        console.log('starting')
        eventEmitter = accountsModel.getEventEmitter()
        eventEmitter.start();
    }

    onClosing: {
        console.log('stopping')
        pageStack.pop(null)
        delete root.accountsModel
        eventEmitter.stop()
    }
}
