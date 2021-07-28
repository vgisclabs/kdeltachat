import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.12 as Kirigami

import DeltaChat 1.0

Kirigami.ScrollablePage {
    id: newChatPageRoot

    title: "New chat"

    required property DcContext context

    function updateContacts() {
        let contacts = context.getContacts(0, "");

        for (let i = 0; i < contacts.length; i++) {
            let contactId = contacts[i]

            const item = {
                contactId: contactId
            }
            contactsModel.insert(i, item)
        }
    }

    Component.onCompleted: {
        newChatPageRoot.updateContacts()
    }

    ListModel {
        id: contactsModel
    }

    ListView {
        id: contactsList

        anchors.fill: parent
        model: contactsModel
        currentIndex: -1

        delegate: Kirigami.BasicListItem {
            property DcContact contact: context.getContact(model.contactId)

            label: contact.displayName
            subtitle: contact.addr
        }

        Kirigami.PlaceholderMessage {
            anchors.centerIn: parent
            visible: contactsList.count == 0
            text: "You have no contacts in addressbook yet"
        }

        onCurrentItemChanged: {
            if (currentIndex == -1) {
                return;
            }

            let contactId = contactsModel.get(contactsList.currentIndex).contactId;

            console.log("Creating chat with " + contactId);
            context.createChatByContactId(contactId);
            pageStack.layers.pop();
        }
    }
}
