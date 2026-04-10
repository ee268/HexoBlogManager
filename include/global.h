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
#include "include/ymlTreeModel.h"
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

private:
    void initContextProperty();

    void readSettings();

    void saveSettings();

    QQmlApplicationEngine& _engine;
    CarouselLoader* _carouselLouader;
    ProcessImport* _processImport;
    BlogMgr* _blogMgr;
    ProcessUpload* _processUpload;
    YmlConfig* _ymlCfg;
    DateListModel* _dateList;
    YmlTreeModel* _ymlConfigModel;
    YmlTreeModel* _ymlThemeModel;
    SystemThemeHelper* _themeHelper;

    QJsonDocument _doc;

signals:
    void sigRefreshMenuColor();
};

#endif // GLOBAL_H
