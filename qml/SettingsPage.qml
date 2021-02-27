import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.12 as Kirigami

import DeltaChat 1.0

Kirigami.Page {
    id: settingsPageRoot

    title: "Settings"

    required property DcContext context

    ColumnLayout {
        anchors.fill: parent

        Switch {
            text: "Prefer end-to-end encryption"
            checked: settingsPageRoot.context.getConfig("e2ee_enabled") == "1"
            onToggled: settingsPageRoot.context.setConfig("e2ee_enabled", checked ? "1" : "0")
        }

        Switch {
            text: "Read receipts"
            checked: settingsPageRoot.context.getConfig("mdns_enabled") == "1"
            onToggled: settingsPageRoot.context.setConfig("mdns_enabled", checked ? "1" : "0")
        }
    }
}
