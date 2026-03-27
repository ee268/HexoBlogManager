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

class GlobalMgr final: public QObject {
    Q_OBJECT
public:
    explicit GlobalMgr(QQmlApplicationEngine& engine, QObject* parent = nullptr);
    ~GlobalMgr();

private:
    void initContextProperty();

    QQmlApplicationEngine& _engine;
    CarouselLoader* _carouselLouader;
    ProcessImport* _processImport;
    BlogMgr* _blogMgr;
    ProcessUpload* _processUpload;
    YmlConfig* _ymlCfg;
    DateListModel* _dateList;
    YmlTreeModel* _ymlConfigModel;
    YmlTreeModel* _ymlThemeModel;
};

#endif // GLOBAL_H
