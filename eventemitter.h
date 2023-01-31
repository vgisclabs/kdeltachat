#pragma once

#include <QObject>

#include <deltachat.h>
#include "dcevent.h"
#include "eventloopthread.h"

class DcAccountsEventEmitter : public QObject {
    Q_OBJECT

    dc_event_emitter_t *m_accounts_event_emitter{nullptr};
    EventLoopThread *m_eventLoopThread{nullptr};
public:
    explicit DcAccountsEventEmitter(QObject *parent = nullptr);
    explicit DcAccountsEventEmitter(dc_event_emitter_t *emitter);
    ~DcAccountsEventEmitter();

    Q_INVOKABLE void start();
    Q_INVOKABLE void processEvent(DcEvent *event);

signals:
    void chatModified(uint32_t accountId, int chatId);
    void configureProgress(uint32_t accountId, int progress, QString comment);
    void imexProgress(uint32_t accountId, int progress);
    void incomingMessage(uint32_t accountId, int chatId, int msgId);
    void messagesChanged(uint32_t accountId, int chatId, int msgId);
    void messagesNoticed(uint32_t accountId, int chatId);
};
