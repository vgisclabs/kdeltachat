import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.13 as Kirigami

import DeltaChat 1.0

Kirigami.ScrollablePage {
    id: root

    title: "New chat"

    required property DcContext context

    function updateContacts() {
        let contacts = context.getContacts(0, searchField.text);

        contactsModel.clear()
        for (let i = 0; i < contacts.length; i++) {
            let contactId = contacts[i]

            const item = {
                contactId: contactId
            }
            contactsModel.insert(i, item)
        }
    }

    Component.onCompleted: {
        root.updateContacts()
    }

    header: Kirigami.SearchField {
        id: searchField

        onTextChanged: root.updateContacts()
    }

    ListModel {
        id: contactsModel
    }

    ListView {
        id: contactsList

        anchors.fill: parent
        model: contactsModel
        currentIndex: -1

        delegate: Kirigami.AbstractListItem {
            property DcContact contact: context.getContact(model.contactId)
            property string profileImage: contact.getProfileImage()

            RowLayout {
                Kirigami.Avatar {
                    name: contact.displayName
                    color: contact.color
                    source: profileImage ? "file:" + profileImage : ""
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Label {
                        text: contact.displayName
                        font.weight: Font.Bold
                        Layout.fillWidth: true
                    }
                    Label {
                        text: contact.addr
                        font: Kirigami.Theme.smallFont
                        Layout.fillWidth: true
                    }
                }
            }
        }

        Kirigami.PlaceholderMessage {
            anchors.centerIn: parent
            visible: contactsList.count == 0 && searchField.text == ""
            text: "You have no contacts in addressbook yet"
        }

        Kirigami.PlaceholderMessage {
            anchors.centerIn: parent
            visible: contactsList.count == 0 && searchField.text != ""
            helpfulAction: Kirigami.Action {
                icon.name: "list-add"
                text: "Add contact"
                onTriggered: {
                    let contactId = root.context.createContact("", searchField.text)
                    context.createChatByContactId(contactId);
                    pageStack.layers.pop();
                }
            }
            text: "Contact " + searchField.text + " is not in your address book."
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
