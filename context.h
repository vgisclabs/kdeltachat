#pragma once

#include <QObject>
#include <QVariant>

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
    Q_INVOKABLE DcChatlist *getChatlist();
    Q_INVOKABLE DcChat *getChat(uint32_t chatId);
    Q_INVOKABLE QVariantList getMsgIdList(uint32_t chatId);
    Q_INVOKABLE DcMessage *getMessage(uint32_t msgId);
    Q_INVOKABLE DcContact *getContact(uint32_t contactId);
    Q_INVOKABLE uint32_t sendTextMessage(uint32_t chatId, QString textToSend);
    QString getBlobdir();
    Q_INVOKABLE QString getConfig(QString key);
    Q_INVOKABLE QString getMessageInfo(uint32_t msgId);

private:
    dc_context_t *m_context{nullptr};
};
