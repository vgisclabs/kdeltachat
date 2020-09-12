#pragma once

#include <QObject>
#include <deltachat.h>
#include "lot.h"

class DcChatlist : public QObject {
    Q_OBJECT

public:
    explicit DcChatlist(QObject *parent = nullptr);
    explicit DcChatlist(dc_chatlist_t *context, QObject *parent = nullptr);
    ~DcChatlist();

    Q_INVOKABLE size_t getChatCount() const;
    Q_INVOKABLE uint32_t getChatId(size_t index) const;
    Q_INVOKABLE uint32_t getMsgId(size_t index) const;
    Q_INVOKABLE DcLot *getSummary(size_t index) const;

private:
    dc_chatlist_t *m_chatlist{nullptr};
};
