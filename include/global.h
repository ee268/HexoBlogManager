#ifndef GLOBAL_H
#define GLOBAL_H
#include <QObject>
#include <QQmlApplicationEngine>
#include "include/carouselloader.h"
#include "include/processImport.h"
#include "include/blogMgr.h"
#include "include/processUpload.h"
#include "include/ymlConfig.h"
#include "include/dateListModel.h"
#include "include/systemThemeHelper.h"
#include <QJsonDocument>

class GlobalMgr final: public QObject
{
    Q_OBJECT
public:
    explicit GlobalMgr(QQmlApplicationEngine& engine, QObject* parent = nullptr);
    ~GlobalMgr();

    Q_INVOKABLE void setValue(QString key, QVariant value);

    Q_INVOKABLE QVariant getValue(QString key);

    Q_INVOKABLE bool contains(const QString key);

    Q_INVOKABLE QString getConfigYmlContent();

    Q_INVOKABLE QString getThemeConfigYmlContent();

    Q_INVOKABLE bool saveConfigYml();
    Q_INVOKABLE bool saveThemeYml();

    Q_INVOKABLE void setConfigYmlContent(QString content);
    Q_INVOKABLE void setThemeYmlContent(QString content);

private:
    void initContextProperty();

    void readSettings();

    void saveSettings();

    QString _configYmlContent;
    QString _themeYmlContent;

    QQmlApplicationEngine& _engine;
    CarouselLoader* _carouselLouader;
    ProcessImport* _processImport;
    BlogMgr* _blogMgr;
    ProcessUpload* _processUpload;
    YmlConfig* _ymlCfg;
    DateListModel* _dateList;
    SystemThemeHelper* _themeHelper;

    QJsonDocument _doc;

signals:
    void sigRefreshMenuColor();
};

#endif // GLOBAL_H
