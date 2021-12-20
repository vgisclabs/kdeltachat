import DeltaChat 1.0
import QtQuick 2.12
import QtQuick.Controls 2.12 as Controls
import org.kde.kirigami 2.12 as Kirigami

Kirigami.ApplicationWindow {
    id: root

    property DcAccountsEventEmitter eventEmitter

    title: qsTr("Delta Chat")
    onClosing: {
        // Cancel all tasks that may block the termination of event loop.
        dcAccounts.stopIo();
    }
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
    }

    Component {
        id: accountsPage

        AccountsPage {
        }

    }

    DcAccounts {
        id: dcAccounts
    }

    Shortcut {
        sequence: 'Esc'
        onActivated: {
            while (pageStack.layers.depth > 1)
                pageStack.layers.pop();

        }
    }

    // Make Ctrl+Q works even when popup
    // windows are opened
    // Quit application
    Shortcut {
        sequence: 'Ctrl+Q'
        onActivated: root.close()
        context: Qt.ApplicationShortcut
    }

    // Show sidebar with 'Work offline', 'Switch
    // accounts' options
    Shortcut {
        sequence: 'Ctrl+Tab'
        onActivated: sideBar.drawerOpen = true
    }

    // Refresh network connectivity. Can be used
    // to retry fetching messages
    Shortcut {
        sequence: 'F5'
        onActivated: dcAccounts.maybeNetwork()
    }

    // Show a popup listing keyboards shortcuts
    // for KDeltaChat
    Shortcut {
        //context: Qt.ApplicationShortcut

        sequence: "F1"
        onActivated: helpPopup.open()
    }

    Controls.Popup {
        id: workNetwNotif

        modal: false
        focus: activeFocus ? false : false
        dim: false
        width: 150
        height: 50
        x: Math.round((parent.width - width) / 2)
        padding: 10
        contentChildren: [
            Text {
                text: "Network status :"
                bottomPadding: 10
                font.bold: true
                font.pixelSize: 14
            },
            Text {
                text: offlineSwitch.checked ? "We can work offline now." : "We can work online now."
                font.pixelSize: 9
                topPadding: 20
                leftPadding: 10
                bottomPadding: 20
            }
        ]
    }

    Controls.Popup {
        id: helpPopup

        modal: true
        focus: true
        anchors.centerIn: parent
        width: 200
        height: 230
        padding: 10
        contentChildren: [
            Text {
                text: "Shortcuts :"
                bottomPadding: 10
                font.bold: true
                font.pixelSize: 14
            },
            Text {
                text: "<b>F1</b>: Displays this" + "<br><b>F2</b>: Work on/offline" + "<br><b>F5</b>: Network check" + "<br><b>Shift+Tab</b>: Account settings" + "<br><b>Alt+C</b>: Clear search" + "<br><b>Alt+Tab</b>: Switch accounts" + "<br><b>Ctrl+F</b>: Search contacts" + "<br><b>Ctrl+N</b>: New chat" + "<br><b>Enter</b>: Send message" + "<br><b>Shift/Ctrl+Enter</b>: Add <br>newline" + "<br><b>Ctrl+Tab</b>: Show sidebar" + "<br><b>Ctrl+Q</b>: Quit"
                topPadding: 20
                leftPadding: 10
                bottomPadding: 20
            }
        ]
    }

    pageStack.initialPage: Kirigami.Page {
    }

    globalDrawer: Kirigami.GlobalDrawer {
        id: sideBar

        actions: [
            Kirigami.Action {
                text: "Maybe network"
                tooltip: "F5"
                iconName: "view-refresh"
                onTriggered: dcAccounts.maybeNetwork()
            },
            Kirigami.Action {
                shortcut: "Alt+Tab"
                text: "Switch account"
                tooltip: "Alt+Tab"
                iconName: "system-users"
                onTriggered: {
                    while (pageStack.layers.depth > 1)
                        pageStack.layers.pop();
                    pageStack.layers.push(accountsPage);
                }
            },
            Kirigami.Action {
                text: "Shortcuts"
                tooltip: "F1"
                iconName: "preferences-desktop-keyboard"
                onTriggered: helpPopup.open()
            },
            Kirigami.Action {
                text: "Quit"
                tooltip: "Ctrl+Q"
                onTriggered: root.close()
            }
        ]

        header: Controls.Switch {
            id: offlineSwitch

            text: "Work offline"
            onCheckedChanged: {
                if (checked)
                    dcAccounts.stopIo();
                else
                    dcAccounts.startIo();
            }

            action: Kirigami.Action {
                id: workOff

                shortcut: "F2"
                tooltip: "F2"
                onTriggered: {
                    if (offlineSwitch.state == "on") {
                        offlineSwitch.checked = false;
                        offlineSwitch.state = "off";
                        workNetwNotif.close();
                        workNetwNotif.open();
                        console.log("Work online");
                    } else {
                        offlineSwitch.checked = true;
                        offlineSwitch.state = "on";
                        workNetwNotif.close();
                        workNetwNotif.open();
                        console.log("Work offline");
                    }
                }
            }

        }

    }

    contextDrawer: Kirigami.ContextDrawer {
        id: contextDrawer
    }

}
