#include "message.h"

DcMessage::DcMessage(QObject *parent)
    : QObject{parent}
{
}

DcMessage::DcMessage(dc_msg_t *message)
    : QObject{nullptr}
    , m_message{message}
{
}

DcMessage::~DcMessage()
{
    dc_msg_unref(m_message);
}

uint32_t
DcMessage::getId()
{
    return dc_msg_get_id(m_message);
}

uint32_t
DcMessage::getFromId()
{
    return dc_msg_get_from_id(m_message);
}

uint32_t
DcMessage::getChatId()
{
    return dc_msg_get_chat_id(m_message);
}

int
DcMessage::getViewtype()
{
    return dc_msg_get_viewtype(m_message);
}

int
DcMessage::getState()
{
    return dc_msg_get_state(m_message);
}

QString
DcMessage::getText()
{
    char *text = dc_msg_get_text(m_message);
    QString result{text};
    dc_str_unref(text);
    return result;
}

QString
DcMessage::getFile()
{
    char *file = dc_msg_get_file(m_message);
    QString result{file};
    dc_str_unref(file);
    return result;
}

QString
DcMessage::getFilename()
{
    char *filename = dc_msg_get_filename(m_message);
    QString result{filename};
    dc_str_unref(filename);
    return result;
}

int
DcMessage::getWidth()
{
    return dc_msg_get_width(m_message);
}

int
DcMessage::getHeight()
{
    return dc_msg_get_height(m_message);
}

QString
DcMessage::getOverrideSenderName()
{
    char *name = dc_msg_get_override_sender_name(m_message);
    QString result{name};
    dc_str_unref(name);
    return result;
}

bool
DcMessage::isInfo()
{
    return dc_msg_is_info(m_message);
}

QString
DcMessage::getQuotedText()
{
    char *text = dc_msg_get_quoted_text(m_message);
    QString result{text};
    dc_str_unref(text);
    return result;
}
