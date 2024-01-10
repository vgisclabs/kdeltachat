#include <QFile>
#include <QStandardPaths>

#include "accounts.h"

DcAccounts::DcAccounts(QObject *parent)
  : QObject(parent)
{
    QString path = QStandardPaths::writableLocation(QStandardPaths::AppConfigLocation) + "/db";
    const int writeable = true;
    m_accounts = dc_accounts_new(path.toUtf8().constData(), writeable);
}

DcAccounts::~DcAccounts()
{
    dc_accounts_unref(m_accounts);
}

uint32_t
DcAccounts::addAccount()
{
    return dc_accounts_add_account(m_accounts);
}

uint32_t
DcAccounts::migrateAccount(QString dbfile)
{
    QByteArray utf8Text = dbfile.toUtf8();
    return dc_accounts_migrate_account(m_accounts, utf8Text.constData());
}

bool
DcAccounts::removeAccount(uint32_t accountId)
{
    return dc_accounts_remove_account(m_accounts, accountId);
}

QVariantList
DcAccounts::getAll()
{
    QVariantList result;
    dc_array_t *accountIdArray = dc_accounts_get_all(m_accounts);
    for (size_t i = 0; i < dc_array_get_cnt(accountIdArray); i++) {
        result << dc_array_get_id(accountIdArray, i);
    }
    dc_array_unref(accountIdArray);
    return result;
}

Context *
DcAccounts::getAccount(uint32_t accountId)
{
    dc_context_t *context = dc_accounts_get_account(m_accounts, accountId);

    return new Context(this, context);
}

Context *
DcAccounts::getSelectedAccount()
{
    dc_context_t *context = dc_accounts_get_selected_account(m_accounts);
    if (context) {
        return new Context(this, context);
    } else {
        return nullptr;
    }
}

bool
DcAccounts::selectAccount(uint32_t accountId) {
    return dc_accounts_select_account(m_accounts, accountId);
}

void
DcAccounts::startIo()
{
    dc_accounts_start_io(m_accounts);
}

void
DcAccounts::stopIo()
{
    dc_accounts_stop_io(m_accounts);
}

void
DcAccounts::maybeNetwork()
{
    dc_accounts_maybe_network(m_accounts);
}

DcAccountsEventEmitter *
DcAccounts::getEventEmitter()
{
    return new DcAccountsEventEmitter{dc_accounts_get_event_emitter(m_accounts)};
}
