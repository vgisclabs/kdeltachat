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

QDateTime
DcMessage::getTimestamp()
{
    return QDateTime::fromSecsSinceEpoch (dc_msg_get_timestamp(m_message), Qt::UTC);
}

void
DcMessage::setText(QString text)
{
    QByteArray utf8Text = text.toUtf8();
    return dc_msg_set_text(m_message, utf8Text.constData());
}

QString
DcMessage::getText()
{
    char *text = dc_msg_get_text(m_message);
    QString result{text};
    dc_str_unref(text);
    return result;
}

void
DcMessage::setFile(QString file)
{
    QByteArray utf8File = file.toUtf8();
    return dc_msg_set_file(m_message, utf8File.constData(), NULL);
}

QString
DcMessage::getSubject()
{
    char *subject = dc_msg_get_subject(m_message);
    QString result{subject};
    dc_str_unref(subject);
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

QString
DcMessage::getFilemime()
{
    char *filemime = dc_msg_get_filemime(m_message);
    QString result{filemime};
    dc_str_unref(filemime);
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

bool
DcMessage::getShowPadlock()
{
    return dc_msg_get_showpadlock(m_message);
}

bool
DcMessage::getIsBot()
{
    return dc_msg_is_bot(m_message);
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
DcMessage::getError()
{
    char *error = dc_msg_get_error(m_message);
    QString result{error};
    dc_str_unref(error);
    return result;
}

bool
DcMessage::hasHtml()
{
    return dc_msg_has_html(m_message);
}

QString
DcMessage::getQuotedText()
{
    char *text = dc_msg_get_quoted_text(m_message);
    QString result{text};
    dc_str_unref(text);
    return result;
}

DcMessage *
DcMessage::getQuotedMessage()
{
    dc_msg_t *quote = dc_msg_get_quoted_msg(m_message);
    if (quote) {
        return new DcMessage{quote};
    } else {
        return NULL;
    }
}
