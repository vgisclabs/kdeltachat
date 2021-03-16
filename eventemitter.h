#pragma once

#include <QThread>
#include <QObject>

#include <iostream>
#include <deltachat.h>
#include "dcevent.h"

class EventLoopThread : public QThread
{
    Q_OBJECT

    dc_accounts_event_emitter_t *m_eventEmitter;
    void run() override {
        dc_event_t *event;
        while((event = dc_accounts_get_next_event(m_eventEmitter))) {
            emit emitEvent(new DcEvent{event});
        }
        dc_accounts_event_emitter_unref(m_eventEmitter);

        std::cout << "NO MORE EVENTS!" << std::endl;
    }
public:
    explicit EventLoopThread(QObject *parent = nullptr)
        : QThread{parent}
    {
    }
    void setEventEmitter(dc_accounts_event_emitter_t *eventEmitter)
    {
        m_eventEmitter = eventEmitter;
    }

signals:
    void emitEvent(DcEvent *event);
};

class DcAccountsEventEmitter : public QObject {
    Q_OBJECT

    dc_accounts_event_emitter_t *m_accounts_event_emitter{nullptr};
    EventLoopThread *m_eventLoopThread{nullptr};
public:
    explicit DcAccountsEventEmitter(QObject *parent = nullptr);
    explicit DcAccountsEventEmitter(dc_accounts_event_emitter_t *emitter);
    ~DcAccountsEventEmitter();

    Q_INVOKABLE void start();
    Q_INVOKABLE void processEvent(DcEvent *event);

signals:
    void chatModified(uint32_t accountId, int chatId);
    void configureProgress(uint32_t accountId, int progress, QString comment);
    void incomingMessage(uint32_t accountId, int chatId, int msgId);
    void messagesChanged(uint32_t accountId, int chatId, int msgId);
    void messagesNoticed(uint32_t accountId, int chatId);
};
