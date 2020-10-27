#include <QFile>

#include "accounts_model.h"

AccountsModel::AccountsModel(QObject *parent)
  : QAbstractListModel(parent)
{
    m_accounts = dc_accounts_new("Qt", "./deltachat-data");
}

AccountsModel::~AccountsModel()
{
    dc_accounts_unref(m_accounts);
}

int
AccountsModel::rowCount(const QModelIndex & parent) const
{
    Q_UNUSED(parent);
    return accountCount();
}

QVariant AccountsModel::data(const QModelIndex & index, int role) const {
    QVariant result{};

    dc_array_t *accounts_arr = dc_accounts_get_all(m_accounts);
    if (index.row() >= 0 && index.row() < dc_array_get_cnt(accounts_arr)) {
        result = dc_array_get_id(accounts_arr, index.row());
    }
    dc_array_unref(accounts_arr);

    return result;
}

QHash<int, QByteArray>
AccountsModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[NumberRole] = "number";
    return roles;
}

size_t
AccountsModel::accountCount() const {
    dc_array_t *accounts_arr = dc_accounts_get_all(m_accounts);
    size_t result = dc_array_get_cnt(accounts_arr);
    dc_array_unref(accounts_arr);
    return result;
}

uint32_t
AccountsModel::selectedAccount() {
    return m_selectedAccount;
}

void
AccountsModel::setSelectedAccount(uint32_t selectedAccount) {
    if (m_selectedAccount != selectedAccount) {
        if (dc_accounts_select_account (m_accounts, selectedAccount)) {
            m_selectedAccount = selectedAccount;
            emit selectedAccountChanged();
        }
    }
}

uint32_t
AccountsModel::addAccount()
{
    int row = accountCount();
    emit beginInsertRows(QModelIndex(), row, row);
    uint32_t res = dc_accounts_add_account(m_accounts);
    if (res != 0) {
        emit accountCountChanged();
    }
    emit endInsertRows();
    return res;
}

void
AccountsModel::removeAccount(uint32_t accountId)
{
    size_t index = -1;

    dc_array_t *accounts_arr = dc_accounts_get_all(m_accounts);
    int res = dc_array_search_id(accounts_arr, accountId, &index);
    dc_array_unref(accounts_arr);

    if (res) {
        emit beginRemoveRows(QModelIndex(), index, index);
        dc_accounts_remove_account(m_accounts, accountId);
        emit endRemoveRows();
        emit accountCountChanged();
    }
}

uint32_t
AccountsModel::importAccount(const QString &filename) {
    int row = accountCount();
    QByteArray ba = QFile::encodeName(filename);
    uint32_t res = dc_accounts_import_account(m_accounts, ba.data());
    if (res) {
        // XXX: Looks like there is no way
        // to abort inserting rows,
        // so we begin and end at the same time to notify the UI about the added
        // row. https://forum.qt.io/topic/19194/how-to-abort-begininsertrows
        emit beginInsertRows(QModelIndex(), row, row);
        emit endInsertRows();
    }
    return res;
}

Context *
AccountsModel::getSelectedAccount()
{
    dc_context_t *context = dc_accounts_get_selected_account(m_accounts);

    return new Context(this, context);
}

void
AccountsModel::startIo()
{
    dc_accounts_start_io(m_accounts);
}

void
AccountsModel::stopIo()
{
    dc_accounts_stop_io(m_accounts);
}

void
AccountsModel::maybeNetwork()
{
    dc_accounts_maybe_network(m_accounts);
}

DcAccountsEventEmitter *
AccountsModel::getEventEmitter()
{
    std::cerr << "GETTING EVENT EMITTER" << std::endl;
    return new DcAccountsEventEmitter{dc_accounts_get_event_emitter(m_accounts)};
}
