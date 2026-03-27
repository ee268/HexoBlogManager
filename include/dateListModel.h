#ifndef DATELISTMODEL_H
#define DATELISTMODEL_H
#include <QAbstractListModel>
#include <QDate>
#include <QColor>

class DateListModel: public QAbstractListModel {
    Q_OBJECT
private:

    struct DayData {
        int year;
        int month;
        int days;
        QString monthName;
    };

    enum DateRoles {
        YearRole = Qt::UserRole + 1,
        MonthRole,
        DaysRole,
        MonthNameRole,
    };

public:

    explicit DateListModel(QObject* parent = nullptr);
    ~DateListModel() = default;

    void init();

    Q_INVOKABLE QString getColorLevel(int index, int days, QString mode);
    Q_INVOKABLE QString getToolTipText(int index, int days);

    Q_INVOKABLE void append(const int &year, const int &month, const int &days, const QString& monthName);
    Q_INVOKABLE void remove(int index);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QHash<int,QByteArray> roleNames() const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

private:

    QList<DayData> _dataList;
    QHash<QString, int> _levels;

public slots:
    void SlotImportFinished(QStringList posts);
};

#endif // DATELISTMODEL_H
