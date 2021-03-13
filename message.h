#pragma once

#include <QObject>

#include <deltachat.h>

class DcMessage : public QObject {
    Q_OBJECT
    Q_PROPERTY(uint32_t id READ getId CONSTANT)
    Q_PROPERTY(uint32_t fromId READ getFromId CONSTANT)
    Q_PROPERTY(uint32_t chatId READ getChatId CONSTANT)
    Q_PROPERTY(int viewtype READ getViewtype CONSTANT)
    Q_PROPERTY(int state READ getState CONSTANT)
    Q_PROPERTY(QString text READ getText CONSTANT)
    Q_PROPERTY(QString file READ getFile CONSTANT)
    Q_PROPERTY(QString filename READ getFilename CONSTANT)
    Q_PROPERTY(int width READ getWidth CONSTANT)
    Q_PROPERTY(int height READ getHeight CONSTANT)
    Q_PROPERTY(bool isInfo READ isInfo CONSTANT)
    Q_PROPERTY(QString quotedText READ getQuotedText CONSTANT)
    Q_PROPERTY(DcMessage *quotedMessage READ getQuotedMessage CONSTANT)

    dc_msg_t *m_message{nullptr};
public:
    explicit DcMessage(QObject *parent = nullptr);
    explicit DcMessage(dc_msg_t *msg);
    ~DcMessage();

    Q_INVOKABLE uint32_t getId();
    Q_INVOKABLE uint32_t getFromId();
    Q_INVOKABLE uint32_t getChatId();
    Q_INVOKABLE int getViewtype();
    Q_INVOKABLE int getState();
    //Q_INVOKABLE int64_t getTimestamp();
    //Q_INVOKABLE int64_t getReceivedTimestamp();
    //Q_INVOKABLE int64_t getSortTimestamp();
    Q_INVOKABLE QString getText();
    QString getFile();
    QString getFilename();
    //QString getFilemime();
    //uint64_t getFilebytes();
    int getWidth();
    int getHeight();
    //int getDuration();
    //bool showPadlock();
    //uint32_t getEphemeralTimer();
    //int64_t getEphemeralTimestamp();
    //... getsummary ...
    Q_INVOKABLE QString getOverrideSenderName();
    //hasDeviatingTimestamp
    //hasLocation
    //isSent
    //isStarred
    //isForwarded
    bool isInfo();
    //isIncreation
    //isSetupmessage
    Q_INVOKABLE QString getQuotedText();
    Q_INVOKABLE DcMessage *getQuotedMessage();
};
