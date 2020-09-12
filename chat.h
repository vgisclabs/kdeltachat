#pragma once

#include <QObject>
#include <QColor>

#include <deltachat.h>

class DcChat : public QObject {
    Q_OBJECT
    Q_PROPERTY(uint32_t id READ getId CONSTANT)
    Q_PROPERTY(QString name READ getName CONSTANT);
    Q_PROPERTY(bool canSend READ canSend CONSTANT)
    Q_PROPERTY(bool muted READ isMuted CONSTANT)

public:
    explicit DcChat(QObject *parent = nullptr);
    explicit DcChat(dc_chat_t *chat);
    ~DcChat();

    Q_INVOKABLE uint32_t getId();
    Q_INVOKABLE int getType();
    Q_INVOKABLE QString getName();
    // Q_INVOKABLE QString getProfileImage();
    Q_INVOKABLE QColor getColor();
    Q_INVOKABLE bool canSend();
    Q_INVOKABLE bool isMuted();

private:
    dc_chat_t *m_chat{nullptr};
};
