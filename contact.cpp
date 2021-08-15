#include "contact.h"

DcContact::DcContact(QObject *parent)
    : QObject{parent}
{
}

DcContact::DcContact(dc_contact_t *contact)
    : QObject{nullptr}
    , m_contact{contact}
{
}

DcContact::~DcContact()
{
    dc_contact_unref(m_contact);
}

uint32_t
DcContact::getId()
{
    return dc_contact_get_id(m_contact);
}

QString
DcContact::getAddr()
{
    char *addr = dc_contact_get_addr(m_contact);
    QString result{addr};
    dc_str_unref(addr);
    return result;
}

QString
DcContact::getName()
{
    char *name = dc_contact_get_name(m_contact);
    QString result{name};
    dc_str_unref(name);
    return result;
}

QString
DcContact::getDisplayName()
{
    char *display_name = dc_contact_get_display_name(m_contact);
    QString result{display_name};
    dc_str_unref(display_name);
    return result;
}

QString
DcContact::getProfileImage()
{
    char *profileImage = dc_contact_get_profile_image(m_contact);
    QString result{profileImage};
    dc_str_unref(profileImage);
    return result;
}

QColor
DcContact::getColor()
{
    uint32_t color = dc_contact_get_color(m_contact);
    return QColor{int(color >> 16) & 0xff, int(color >> 8) & 0xff, int(color) & 0xff};
}
