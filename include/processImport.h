#ifndef PROCESSIMPORT_H
#define PROCESSIMPORT_H
#include <QObject>
#include <QString>
#include <QDebug>
#include "include/blogMgr.h"
#include "include/processUpload.h"
#include "include/ymlConfig.h"
#include "include/ymlTreeModel.h"

class ProcessImport: public QObject {
    Q_OBJECT
public:
    explicit ProcessImport(BlogMgr* blogMgr, ProcessUpload* pUpload,
                           YmlConfig* ymlCfg, YmlTreeModel* themeModel,
                           QObject* obj = nullptr);
    ~ProcessImport() = default;

    Q_INVOKABLE bool setFolderPath(QString path);

    Q_INVOKABLE void setThemeConfigYml(QString path);

    bool isYmlFile(const QString& path);

    bool isThemeConfigYml(const QString& name);

    Q_INVOKABLE QString getFolderPath() const;
    Q_INVOKABLE QString getConfigYml() const;
    Q_INVOKABLE QString getThemeConfigYml() const;
    Q_INVOKABLE QString getPostPath() const;

    Q_INVOKABLE QJsonArray readHistory();

private:
    void saveHistory();
    void loadHistory();

    QString _folderPath;
    QString _configYml;
    QString _themeConfigYml;
    QString _postPath;
    YmlTreeModel* _themeModel;
    bool isLoad;

signals:
    void SigImportFinished(QString);
    void SigImportConfigFinished(QString);
};

#endif // PROCESSIMPORT_H
