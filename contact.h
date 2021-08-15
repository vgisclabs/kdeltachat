#pragma once

#include <QObject>
#include <QColor>

#include <deltachat.h>

class DcContact : public QObject {
    Q_OBJECT
    Q_PROPERTY(uint32_t id READ getId CONSTANT)
    Q_PROPERTY(QString addr READ getAddr CONSTANT)
    Q_PROPERTY(QString name READ getName CONSTANT)
    Q_PROPERTY(QString displayName READ getDisplayName CONSTANT)
    Q_PROPERTY(QColor color READ getColor CONSTANT)

public:
    explicit DcContact(QObject *parent = nullptr);
    explicit DcContact(dc_contact_t *contact);
    ~DcContact();

    uint32_t getId();
    QString getAddr();
    QString getName();
    QString getDisplayName();
    Q_INVOKABLE QString getProfileImage();
    QColor getColor();

private:
    dc_contact_t *m_contact{nullptr};
};
