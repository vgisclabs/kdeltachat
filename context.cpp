#include "context.h"

Context::Context(QObject *parent)
    : QObject(parent)
{
}

Context::Context(QObject *parent, dc_context_t *context)
    : QObject(parent)
    , m_context(context)
{
}

Context::~Context()
{
    dc_context_unref(m_context);
}

void
Context::configure()
{
    dc_configure(m_context);
}

bool
Context::isConfigured() const
{
    return dc_is_configured(m_context);
}

void
Context::startIo()
{
    dc_start_io(m_context);
}

void
Context::stopIo()
{
    dc_stop_io(m_context);
}

void
Context::maybeNetwork()
{
    dc_maybe_network(m_context);
}

QString
Context::getInfo()
{
    char *info = dc_get_info(m_context);
    QString result{info};
    dc_str_unref(info);
    return result;
}

DcChatlist *
Context::getChatlist(int flags)
{
    dc_chatlist_t *chatlist = dc_get_chatlist(m_context, flags, NULL, 0);
    return new DcChatlist{chatlist};
}

void
Context::setChatVisibility(uint32_t chatId, int visibility)
{
    dc_set_chat_visibility(m_context, chatId, visibility);
}

void
Context::deleteChat(uint32_t chatId)
{
    dc_delete_chat(m_context, chatId);
}

QString
Context::getChatEncrinfo(uint32_t chatId)
{
    char *encrinfo = dc_get_chat_encrinfo(m_context, chatId);
    QString result{encrinfo};
    dc_str_unref(encrinfo);
    return result;
}

uint32_t
Context::getChatEphemeralTimer(uint32_t chatId)
{
    return dc_get_chat_ephemeral_timer(m_context, chatId);
}

DcChat *
Context::getChat(uint32_t chatId)
{
    dc_chat_t *chat = dc_get_chat(m_context, chatId);
    return new DcChat{chat};
}

QVariantList
Context::getMsgIdList(uint32_t chatId) {
    QVariantList result;
    dc_array_t *msgIdArray = dc_get_chat_msgs(m_context, chatId, 0, 0);
    for (size_t i = 0; i < dc_array_get_cnt(msgIdArray); i++) {
        result << dc_array_get_id(msgIdArray, i);
    }
    dc_array_unref(msgIdArray);
    return result;
}

int
Context::getFreshMsgCnt(uint32_t chatId) {
    return dc_get_fresh_msg_cnt(m_context, chatId);
}

void
Context::marknoticedChat(uint32_t chatId) {
    return dc_marknoticed_chat(m_context, chatId);
}

void
Context::markseenMsgs(QVector<uint32_t> msg_ids)
{
    dc_markseen_msgs(m_context, msg_ids.constData(), msg_ids.count());
}

DcMessage *
Context::getMessage(uint32_t msgId)
{
    dc_msg_t *message = dc_get_msg(m_context, msgId);
    return new DcMessage{message};
}

DcContact *
Context::getContact(uint32_t contactId)
{
    dc_contact_t *contact = dc_get_contact(m_context, contactId);
    return new DcContact{contact};
}

QString
Context::getBlobdir()
{
    char *blobdir = dc_get_blobdir(m_context);
    QString result{blobdir};
    dc_str_unref(blobdir);
    return result;
}

bool
Context::setConfig(QString key, QString value)
{
    QByteArray utf8Key = key.toUtf8();
    QByteArray utf8Value = value.toUtf8();
    return dc_set_config(m_context, utf8Key.constData(), utf8Value.constData());
}

QString
Context::getConfig(QString key)
{
    QByteArray utf8Key = key.toUtf8();
    char *value = dc_get_config(m_context, utf8Key.constData());
    QString result{value};
    dc_str_unref(value);
    return result;
}

QString
Context::getMessageInfo(uint32_t msgId)
{
    char *info = dc_get_msg_info(m_context, msgId);
    QString result{info};
    dc_str_unref(info);
    return result;
}

QString
Context::getMessageHtml(uint32_t msgId)
{
    char *html = dc_get_msg_html(m_context, msgId);
    QString result{html};
    dc_str_unref(html);
    return result;
}

uint32_t
Context::sendTextMessage(uint32_t chatId, QString textToSend)
{
    QByteArray utf8Text = textToSend.toUtf8();
    return dc_send_text_msg(m_context, chatId, utf8Text.constData());
}

void
Context::setDraft(uint32_t chatId, DcMessage *message)
{
    dc_set_draft(m_context, chatId, message ? message->m_message : nullptr);
}

DcMessage *
Context::getDraft(uint32_t chatId)
{
    dc_msg_t *draft = dc_get_draft(m_context, chatId);
    if (draft) {
        return new DcMessage{draft};
    } else {
        return NULL;
    }
}

bool
Context::setChatMuteDuration(uint32_t chatId, int64_t duration)
{
    return dc_set_chat_mute_duration(m_context, chatId, duration);
}

uint32_t
Context::decideOnContactRequest(uint32_t msgId, int decision)
{
    return dc_decide_on_contact_request(m_context, msgId, decision);
}

DcMessage *
Context::newMessage(int viewtype)
{
    dc_msg_t *message = dc_msg_new(m_context, viewtype);
    return new DcMessage{message};
}

void
Context::importBackup(QString tarfile)
{
    QByteArray utf8Text = tarfile.toUtf8();
    return dc_imex(m_context, DC_IMEX_IMPORT_BACKUP, utf8Text.constData(), NULL);
}
