#pragma once

#include <QAbstractListModel>
#include <deltachat.h>

#include "eventemitter.h"
#include "context.h"

class DcAccounts : public QObject {
    Q_OBJECT

public:
    explicit DcAccounts(QObject *parent = nullptr);
    ~DcAccounts();

    Q_INVOKABLE uint32_t addAccount();
    Q_INVOKABLE uint32_t migrateAccount(QString dbfile);
    Q_INVOKABLE bool removeAccount(uint32_t accountId);
    Q_INVOKABLE QVariantList getAll();
    Q_INVOKABLE Context *getAccount(uint32_t accountId);
    Q_INVOKABLE Context *getSelectedAccount();
    Q_INVOKABLE bool selectAccount(uint32_t accountId);
    Q_INVOKABLE void startIo();
    Q_INVOKABLE void stopIo();
    Q_INVOKABLE void maybeNetwork();
    Q_INVOKABLE DcAccountsEventEmitter *getEventEmitter();

private:
    dc_accounts_t *m_accounts{nullptr};
};
