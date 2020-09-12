#include <lot.h>

DcLot::DcLot(QObject *parent)
    : QObject(parent)
{
}

DcLot::DcLot(dc_lot_t *lot)
    : m_lot{lot}
{
}

DcLot::~DcLot()
{
    dc_lot_unref(m_lot);
}

QString
DcLot::getText1() const
{
    char *text1 = dc_lot_get_text1(m_lot);
    QString result{text1};
    dc_str_unref(text1);
    return result;
}

QString
DcLot::getText2() const
{
    char *text2 = dc_lot_get_text2(m_lot);
    QString result{text2};
    dc_str_unref(text2);
    return result;
}

int
DcLot::getText1Meaning() const
{
    return dc_lot_get_text1_meaning(m_lot);
}

int
DcLot::getState() const
{
    return dc_lot_get_state(m_lot);
}

uint32_t
DcLot::getId() const
{
    return dc_lot_get_id(m_lot);
}

int64_t
DcLot::getTimestamp() const
{
    return dc_lot_get_timestamp(m_lot);
}
