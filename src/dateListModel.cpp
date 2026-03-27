#include "include/dateListModel.h"
#include "include/frontMatterMgr.h"
#include <QDateTime>

DateListModel::DateListModel(QObject *parent)
    : QAbstractListModel(parent)
{

}

void DateListModel::init()
{
    emit beginResetModel();

    const QStringList monthNames = {
        "January",   // 1月
        "February",  // 2月
        "March",     // 3月
        "April",     // 4月
        "May",       // 5月
        "June",      // 6月
        "July",      // 7月
        "August",    // 8月
        "September", // 9月
        "October",   // 10月
        "November",  // 11月
        "December"   // 12月
    };

    QDate curDate = QDate::currentDate();
    int year = curDate.year();
    int month = curDate.month();

    for (int i = 0; i < 12; i++) {
        DayData data;
        QDate getDays(year, month, 1);
        data.days = getDays.daysInMonth();
        data.year = year;
        data.month = month;
        data.monthName = monthNames[month - 1];
        _dataList.append(data);

        if (month == 1) {
            year--;
            month = 12;
            continue;
        }
        month--;
    }

    emit endResetModel();
    qDebug() << "Model init finished, row count:" << rowCount();
}

QString DateListModel::getColorLevel(int index, int days, QString mode)
{
    QString key = QString::number(_dataList[index].year) + QString::number(_dataList[index].month) + QString::number(days);

    switch(_levels[key]) {
        case 1: return "#9be9a8";
        case 2: return "#40c463";
        case 3: return "#30a14e";
        case 4: return "#216e39";
        default: return mode == "light" ? "#ebedf0" : "#2D3743";
    }

    return "purple";
}

QString DateListModel::getToolTipText(int index, int days)
{
    QString year = QString::number(_dataList[index].year);
    QString month = QString::number(_dataList[index].month);
    QString day = QString::number(days);
    QString key = year + month + day;
    if (_levels.contains(key)) {
        QString value = QString::number(_levels[key]) + "篇 ";
        return value + month + "月" +  day + "日";
    }

    return month + "月" +  day + "日";
}

void DateListModel::append(const int &year, const int &month, const int &days, const QString &monthName)
{
    DayData data;
    data.year = year;
    data.month = month;
    data.days = days;
    data.monthName = monthName;

    emit beginInsertRows(QModelIndex(), _dataList.size(), _dataList.size());
    _dataList.append(data);
    emit endInsertRows();
}

void DateListModel::remove(int index)
{
    if(index < 0 || index >= _dataList.count()) {
        return;
    }

    emit beginRemoveRows(QModelIndex(), index, index);
    _dataList.removeAt(index);
    emit endRemoveRows();
}

int DateListModel::rowCount(const QModelIndex &parent) const
{
    return _dataList.size();
}

QHash<int, QByteArray> DateListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[YearRole] = "year";
    roles[MonthRole] = "month";
    roles[MonthNameRole] = "monthName";
    roles[DaysRole] = "days";

    return roles;
}

QVariant DateListModel::data(const QModelIndex &index, int role) const
{
    int row = index.row();
    if(row < 0 || row >= _dataList.count()) {
        return QVariant();
    }

    const DayData &data = _dataList[row];
    switch (role) {
        case YearRole:
            return data.year;
        case MonthRole:
            return data.month;
        case DaysRole:
            return data.days;
        case MonthNameRole:
            return data.monthName;
        default:
            return QVariant();
    }
}

void DateListModel::SlotImportFinished(QStringList posts)
{
    for (int i = 0; i < posts.size(); i++) {
        FrontMatterMgr fm(posts[i]);
        if (!fm.isEmpty()) {
            // _postsFM.append(fm);
            QDateTime dateTime = QDateTime::fromString(fm["date"], "yyyy/MM/dd HH:mm:ss");
            QString key = QString::number(dateTime.date().year()) + QString::number(dateTime.date().month()) + QString::number(dateTime.date().day());
            if (_levels.contains(key)) {
                _levels[key]++;
                continue;
            }
            _levels[key] = 1;
            continue;
        }
        qDebug() << "frontMatter is empty";
    }
    init();
}
