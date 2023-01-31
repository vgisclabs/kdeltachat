#include <iostream>

#include "eventloopthread.h"

void
EventLoopThread::run () {
    dc_event_t *event;
    while((event = dc_get_next_event(m_eventEmitter))) {
        emit emitEvent(new DcEvent{event});
    }
    dc_event_emitter_unref(m_eventEmitter);

    std::cout << "NO MORE EVENTS!" << std::endl;
}

EventLoopThread::EventLoopThread(QObject *parent)
    : QThread{parent}
{
}

void
EventLoopThread::setEventEmitter(dc_event_emitter_t *eventEmitter)
{
    m_eventEmitter = eventEmitter;
}
