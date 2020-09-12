#include "eventemitter.h"

DcAccountsEventEmitter::DcAccountsEventEmitter(QObject *parent)
    : QObject{parent}
{
}

DcAccountsEventEmitter::DcAccountsEventEmitter(dc_accounts_event_emitter_t *emitter)
    : QObject{nullptr}
    , m_accounts_event_emitter{emitter}
{
}

DcAccountsEventEmitter::~DcAccountsEventEmitter()
{
    if (m_eventLoopThread) {
        qInfo("Waiting");
        m_eventLoopThread->wait();
        qInfo("Waiting finished");
    }
}

void
DcAccountsEventEmitter::start()
{
    std::cerr << "Starting loop thread" << std::endl;
    m_eventLoopThread = new EventLoopThread(this);
    std::cerr << "Started loop thread" << std::endl;
    QObject::connect(m_eventLoopThread, &EventLoopThread::emitEvent,
                     this, &DcAccountsEventEmitter::processEvent);
    m_eventLoopThread->setEventEmitter(m_accounts_event_emitter);
    m_eventLoopThread->start();
}

void
DcAccountsEventEmitter::stop()
{
    qInfo("Stopping event emitter");
    dc_accounts_event_emitter_unref(m_accounts_event_emitter);
}

void
DcAccountsEventEmitter::processEvent(DcEvent *event)
{
    emit incomingEvent();
    switch (event->getId()) {
        case DC_EVENT_INFO:
            qInfo("%s", qUtf8Printable(event->getData2Str()));
            break;
        case DC_EVENT_SMTP_CONNECTED:
            qInfo("SMTP connected: %s", qUtf8Printable(event->getData2Str()));
            break;
        case DC_EVENT_IMAP_CONNECTED:
            qInfo("IMAP connected: %s", qUtf8Printable(event->getData2Str()));
            break;
        case DC_EVENT_SMTP_MESSAGE_SENT:
            qInfo("SMTP message sent: %s", qUtf8Printable(event->getData2Str()));
            break;
        case DC_EVENT_IMAP_MESSAGE_DELETED:
            qInfo("IMAP message deleted: %s", qUtf8Printable(event->getData2Str()));
            break;
        case DC_EVENT_IMAP_MESSAGE_MOVED:
            qInfo("IMAP message moved: %s", qUtf8Printable(event->getData2Str()));
            break;
        case DC_EVENT_NEW_BLOB_FILE:
            qInfo("New blob file: %s", qUtf8Printable(event->getData2Str()));
            break;
        case DC_EVENT_DELETED_BLOB_FILE:
            qInfo("Deleted blob file: %s", qUtf8Printable(event->getData2Str()));
            break;
        case DC_EVENT_WARNING:
            qWarning("%s", qUtf8Printable(event->getData2Str()));
            break;
        case DC_EVENT_ERROR:
            qCritical("%s", qUtf8Printable(event->getData2Str()));
            break;
        case DC_EVENT_ERROR_NETWORK:
            qCritical("Network error: %s", qUtf8Printable(event->getData2Str()));
            break;
        case DC_EVENT_ERROR_SELF_NOT_IN_GROUP:
            qCritical("Self not in group error: %s", qUtf8Printable(event->getData2Str()));
            break;
        case DC_EVENT_CHAT_MODIFIED:
            emit chatModified(event->getAccountId(), event->getData1Int());
            break;
        case DC_EVENT_MSGS_CHANGED:
            emit messagesChanged(event->getAccountId(), event->getData1Int(), event->getData2Int());
            break;
        case DC_EVENT_INCOMING_MSG:
            std::cout << "Emitting incoming message!" << std::endl;
            emit incomingMessage(event->getAccountId(),
                                 event->getData1Int(),
                                 event->getData2Int());
            std::cout << "Emitted incoming message!" << std::endl;
            break;
        default:
            std::cout << "Not processing " << event->getId() << std::endl;
    }
    delete event;
}
