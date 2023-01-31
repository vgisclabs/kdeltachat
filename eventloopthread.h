#pragma once

#include <QThread>
#include <QObject>

#include <deltachat.h>
#include "dcevent.h"

class EventLoopThread : public QThread
{
    Q_OBJECT

    dc_event_emitter_t *m_eventEmitter;
    void run() override;
public:
    explicit EventLoopThread(QObject *parent = nullptr);
    void setEventEmitter(dc_event_emitter_t *eventEmitter);

signals:
    void emitEvent(DcEvent *event);
};

