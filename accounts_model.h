#pragma once

#include <QAbstractListModel>
#include <deltachat.h>

#include "eventemitter.h"
#include "context.h"

class AccountsModel : public QAbstractListModel {
    Q_OBJECT
    Q_PROPERTY(size_t accountCount READ accountCount NOTIFY accountCountChanged)
    Q_PROPERTY(uint32_t selectedAccount READ selectedAccount WRITE setSelectedAccount NOTIFY selectedAccountChanged)

public:
    enum AccountRoles {
        NumberRole = Qt::UserRole + 1
    };
    explicit AccountsModel(QObject *parent = nullptr);
    ~AccountsModel();

    int rowCount(const QModelIndex & parent = QModelIndex()) const;

    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;

    size_t accountCount() const;

    uint32_t selectedAccount();
    void setSelectedAccount(uint32_t selectedAccount);

    Q_INVOKABLE uint32_t addAccount();
    Q_INVOKABLE void removeAccount(uint32_t accountId);
    Q_INVOKABLE uint32_t importAccount(const QString &filename);
    Q_INVOKABLE Context *getSelectedAccount();

    Q_INVOKABLE void startIo();
    Q_INVOKABLE void stopIo();
    Q_INVOKABLE void maybeNetwork();

    Q_INVOKABLE DcAccountsEventEmitter *getEventEmitter();

signals:
    void accountCountChanged();
    void selectedAccountChanged();

protected:
    QHash<int, QByteArray> roleNames() const;

private:
    dc_accounts_t *m_accounts{nullptr};
    uint32_t m_selectedAccount{0};
};
