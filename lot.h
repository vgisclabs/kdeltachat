#pragma once

#include <QObject>

#include <deltachat.h>

class DcLot : public QObject {
    Q_OBJECT

    Q_PROPERTY(QString text1 READ getText1 CONSTANT);
    Q_PROPERTY(QString text2 READ getText2 CONSTANT);
    Q_PROPERTY(int text1Meaning READ getText1Meaning CONSTANT);
    Q_PROPERTY(int state READ getState CONSTANT);
    Q_PROPERTY(uint32_t id READ getId CONSTANT);
    Q_PROPERTY(int64_t timestamp READ getTimestamp CONSTANT);

    dc_lot_t *m_lot{nullptr};

public:
    explicit DcLot(QObject *parent = nullptr);
    explicit DcLot(dc_lot_t *lot);
    ~DcLot();

    Q_INVOKABLE QString getText1() const;
    Q_INVOKABLE QString getText2() const;
    Q_INVOKABLE int getText1Meaning() const;
    Q_INVOKABLE int getState() const;
    Q_INVOKABLE uint32_t getId() const;
    Q_INVOKABLE int64_t getTimestamp() const;
};
