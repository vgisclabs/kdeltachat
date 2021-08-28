#pragma once

#include <QDateTime>
#include <QObject>

#include <deltachat.h>

class Context;

class DcMessage : public QObject {
    Q_OBJECT
    Q_PROPERTY(uint32_t id READ getId CONSTANT)
    Q_PROPERTY(uint32_t fromId READ getFromId CONSTANT)
    Q_PROPERTY(uint32_t chatId READ getChatId CONSTANT)
    Q_PROPERTY(int viewtype READ getViewtype CONSTANT)
    Q_PROPERTY(int state READ getState CONSTANT)
    Q_PROPERTY(QDateTime timestamp READ getTimestamp CONSTANT)
    Q_PROPERTY(QString text READ getText WRITE setText)
    Q_PROPERTY(QString subject READ getSubject CONSTANT)
    Q_PROPERTY(QString file READ getFile CONSTANT)
    Q_PROPERTY(QString filename READ getFilename CONSTANT)
    Q_PROPERTY(int width READ getWidth CONSTANT)
    Q_PROPERTY(int height READ getHeight CONSTANT)
    Q_PROPERTY(bool showPadlock READ getShowPadlock CONSTANT)
    Q_PROPERTY(bool isBot READ getIsBot CONSTANT)
    Q_PROPERTY(bool isInfo READ isInfo CONSTANT)
    Q_PROPERTY(QString quotedText READ getQuotedText CONSTANT)
    Q_PROPERTY(DcMessage *quotedMessage READ getQuotedMessage CONSTANT)
    Q_PROPERTY(bool hasHtml READ hasHtml CONSTANT)

    dc_msg_t *m_message{nullptr};

    friend class Context;
public:
    explicit DcMessage(QObject *parent = nullptr);
    explicit DcMessage(dc_msg_t *msg);
    ~DcMessage();

    Q_INVOKABLE uint32_t getId();
    Q_INVOKABLE uint32_t getFromId();
    Q_INVOKABLE uint32_t getChatId();
    Q_INVOKABLE int getViewtype();
    Q_INVOKABLE int getState();
    Q_INVOKABLE QDateTime getTimestamp();
    //Q_INVOKABLE int64_t getReceivedTimestamp();
    //Q_INVOKABLE int64_t getSortTimestamp();
    Q_INVOKABLE void setText(QString);
    Q_INVOKABLE QString getText();
    Q_INVOKABLE QString getSubject();
    QString getFile();
    QString getFilename();
    QString getFilemime();
    //uint64_t getFilebytes();
    int getWidth();
    int getHeight();
    //int getDuration();
    bool getShowPadlock();
    bool getIsBot();
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
    Q_INVOKABLE QString getError();
    bool hasHtml();
    //isIncreation
    //isSetupmessage
    Q_INVOKABLE QString getQuotedText();
    Q_INVOKABLE DcMessage *getQuotedMessage();
};
