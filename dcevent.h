#pragma once

#include <QObject>

#include <deltachat.h>

class DcEvent : public QObject {
    Q_OBJECT
    Q_PROPERTY(int id READ getId CONSTANT)
    Q_PROPERTY(int data1 READ getData1Int CONSTANT)
    Q_PROPERTY(uint32_t accountId READ getAccountId CONSTANT)
    dc_event_t *m_event;
public:
    explicit DcEvent(QObject *parent = nullptr);
    explicit DcEvent(dc_event_t *event);
    ~DcEvent();

    int getId();
    int getData1Int();
    int getData2Int();
    QString getData2Str();
    uint32_t getAccountId();
};
