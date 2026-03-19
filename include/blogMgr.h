#ifndef BLOGMGR_H
#define BLOGMGR_H
#include <QObject>
#include <QDebug>
#include <QStringList>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QMap>
#include "include/frontMatterMgr.h"

class BlogMgr: public QObject {
    Q_OBJECT
public:
    explicit BlogMgr(QObject* obj = nullptr);
    ~BlogMgr() = default;

    void setPostPath(QString path);

    // FrontMatterMgr& getFromMatter(QString);

    Q_INVOKABLE QJsonArray getBlogInfo();

private:
    void initPosts();

    bool isMdSuffix(QString& name);

    QString _postPath;
    QStringList _postPaths;
    QMap<QString, FrontMatterMgr> _fmMgr;

public slots:
    void SlotImportFinished(QString path);
};

#endif // BLOGMGR_H
