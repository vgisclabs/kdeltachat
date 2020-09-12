#include "chat.h"

DcChat::DcChat(QObject *parent)
    : QObject{parent}
{
}

DcChat::DcChat(dc_chat_t *chat)
    : QObject{nullptr}
    , m_chat{chat}
{
}

DcChat::~DcChat()
{
    dc_chat_unref(m_chat);
}

uint32_t
DcChat::getId()
{
    return dc_chat_get_id(m_chat);
}

int
DcChat::getType()
{
    return dc_chat_get_type(m_chat);
}

QString
DcChat::getName()
{
    char *name = dc_chat_get_name(m_chat);
    QString result{name};
    dc_str_unref(name);
    return result;
}

/*
QString
DcChat::getProfileImage()
{
  char *profileImage = dc_chat_get_profile_image(m_chat);
}
*/

QColor
DcChat::getColor()
{
    uint32_t color = dc_chat_get_color(m_chat);
    return QColor{int(color >> 16) & 0xff, int(color >> 8) & 0xff, int(color) & 0xff};
}

bool
DcChat::canSend()
{
    return dc_chat_can_send(m_chat);
}

bool
DcChat::isMuted()
{
    return dc_chat_is_muted(m_chat);
}
