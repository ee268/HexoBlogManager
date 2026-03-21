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

    Q_INVOKABLE QString getPostContent(int idx);

    Q_INVOKABLE bool savePost(int idx, QByteArray content);

    Q_INVOKABLE void reload();

private:
    void initPosts();

    bool isMdSuffix(QString& name);

    void clear();


    QString _postPath;
    QStringList _postPaths;
    QMap<QString, FrontMatterMgr> _fmMgr;

public slots:
    void SlotImportFinished(QString path);
};

#endif // BLOGMGR_H
