#include "dcevent.h"

DcEvent::DcEvent(QObject *parent)
    : QObject{parent}
{
}

DcEvent::DcEvent(dc_event_t *event)
    : m_event{event}
{
}

DcEvent::~DcEvent()
{
    dc_event_unref(m_event);
}

int
DcEvent::getId()
{
    return dc_event_get_id(m_event);
}

int
DcEvent::getData1Int()
{
    return dc_event_get_data1_int(m_event);
}

int
DcEvent::getData2Int()
{
    return dc_event_get_data2_int(m_event);
}

QString
DcEvent::getData2Str()
{
    char *data2 = dc_event_get_data2_str(m_event);
    QString result{data2};
    dc_str_unref(data2);
    return result;
}

uint32_t
DcEvent::getAccountId()
{
    return dc_event_get_account_id(m_event);
}
