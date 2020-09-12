#include "chatlist.h"
#include "lot.h"

DcChatlist::DcChatlist(QObject *parent)
    : QObject{parent}
{
}

DcChatlist::DcChatlist(dc_chatlist_t *chatlist, QObject *parent)
    : QObject{parent}
    , m_chatlist{chatlist}
{
}

DcChatlist::~DcChatlist()
{
    dc_chatlist_unref(m_chatlist);
}

size_t
DcChatlist::getChatCount() const
{
    return dc_chatlist_get_cnt(m_chatlist);
}

uint32_t
DcChatlist::getChatId(size_t index) const
{
    return dc_chatlist_get_chat_id(m_chatlist, index);
}

uint32_t
DcChatlist::getMsgId(size_t index) const
{
    return dc_chatlist_get_msg_id(m_chatlist, index);
}

DcLot *
DcChatlist::getSummary(size_t index) const
{
    return new DcLot{dc_chatlist_get_summary(m_chatlist, index, NULL)};
}
