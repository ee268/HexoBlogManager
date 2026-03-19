#ifndef FRONTMATTERMGR_H
#define FRONTMATTERMGR_H
#include <QString>
#include <QMap>

class FrontMatterMgr {
public:
    FrontMatterMgr() = default;
    FrontMatterMgr(QString postPath);
    FrontMatterMgr(const FrontMatterMgr& fm);
    ~FrontMatterMgr() = default;
    FrontMatterMgr& operator=(const FrontMatterMgr& fm);

    QString& operator[] (QString key);

    bool contains(const QString& key);

    QMap<QString, QString> getMap() const;

private:
    void initFM(QString path);
    QStringList splitKV(QString& str);

    QMap<QString, QString> _fms;
};

#endif // FRONTMATTERMGR_H
