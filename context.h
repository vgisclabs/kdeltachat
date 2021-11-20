#pragma once

#include <QObject>
#include <QVariant>
#include <QVector>

#include <deltachat.h>

#include "chatlist.h"
#include "chat.h"
#include "message.h"
#include "contact.h"

class Context : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString blobdir READ getBlobdir CONSTANT)

public:
    explicit Context(QObject *parent = nullptr);
    explicit Context(QObject *parent, dc_context_t *context);
    ~Context();

    Q_INVOKABLE void configure();
    Q_INVOKABLE bool isConfigured() const;
    Q_INVOKABLE QString getInfo();
    Q_INVOKABLE void startIo();
    Q_INVOKABLE void stopIo();
    Q_INVOKABLE void maybeNetwork();
    Q_INVOKABLE DcChatlist *getChatlist(int flags, QString query);
    Q_INVOKABLE uint32_t createChatByContactId(uint32_t contactId);
    Q_INVOKABLE void setChatVisibility(uint32_t chatId, int visibility);
    Q_INVOKABLE void deleteChat(uint32_t chatId);
    Q_INVOKABLE void blockChat(uint32_t chatId);
    Q_INVOKABLE void acceptChat(uint32_t chatId);
    Q_INVOKABLE QString getChatEncrinfo(uint32_t chatId);
    Q_INVOKABLE uint32_t getChatEphemeralTimer(uint32_t chatId);
    Q_INVOKABLE DcChat *getChat(uint32_t chatId);
    Q_INVOKABLE QVariantList getContacts(uint32_t flags, QString query);
    Q_INVOKABLE QVariantList getMsgIdList(uint32_t chatId);
    Q_INVOKABLE QVariantMap getBlockedContacts();
    Q_INVOKABLE void blockContact(uint32_t contactId, uint32_t blockMode);
    Q_INVOKABLE int getFreshMsgCnt(uint32_t chatId);
    Q_INVOKABLE void marknoticedChat(uint32_t chatId);
    Q_INVOKABLE void markseenMsgs(QVector<uint32_t> msg_ids);
    Q_INVOKABLE DcMessage *getMessage(uint32_t msgId);
    Q_INVOKABLE DcContact *getContact(uint32_t contactId);
    Q_INVOKABLE uint32_t createContact(QString name, QString addr);
    Q_INVOKABLE uint32_t sendTextMessage(uint32_t chatId, QString textToSend);
    Q_INVOKABLE void setDraft(uint32_t chatId, DcMessage *message);
    Q_INVOKABLE DcMessage *getDraft(uint32_t chatId);
    QString getBlobdir();
    Q_INVOKABLE bool setConfig(QString key, QString value);
    Q_INVOKABLE QString getConfig(QString key);
    Q_INVOKABLE bool setChatMuteDuration(uint32_t chatId, int64_t duration);
    Q_INVOKABLE QString getMessageInfo(uint32_t msgId);
    Q_INVOKABLE QString getMessageHtml(uint32_t msgId);
    Q_INVOKABLE DcMessage *newMessage(int viewtype);
    Q_INVOKABLE uint32_t sendMessage(uint32_t chatId, DcMessage *message);
    Q_INVOKABLE uint32_t sendVChatInv(uint32_t chatId);
    Q_INVOKABLE void importBackup(QString tarfile);

private:
    dc_context_t *m_context{nullptr};
};
