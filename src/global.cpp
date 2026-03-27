#include "include/global.h"
#include <QQmlContext>

GlobalMgr::GlobalMgr(QQmlApplicationEngine& engine, QObject* parent/* = nullptr*/)
    : QObject(parent)
    , _engine(engine)
{
    _processUpload = new ProcessUpload(&_engine);
    _ymlCfg = new YmlConfig(&engine);
    _dateList = new DateListModel(&engine);
    _carouselLouader = new CarouselLoader(&_engine);
    _blogMgr = new BlogMgr(_dateList, _carouselLouader, &_engine);
    _ymlThemeModel = new YmlTreeModel(&_engine);
    _processImport = new ProcessImport(_blogMgr, _processUpload, _ymlCfg, _ymlThemeModel, &_engine);
    _ymlConfigModel = new YmlTreeModel(&_engine);
    _ymlConfigModel->init(_processImport->getConfigYml());

    initContextProperty();
}

GlobalMgr::~GlobalMgr()
{

}

void GlobalMgr::initContextProperty()
{
    _engine.rootContext()->setContextProperty("carouselLoader", _carouselLouader);

    _engine.rootContext()->setContextProperty("processImport", _processImport);

    _engine.rootContext()->setContextProperty("blogMgr", _blogMgr);

    _engine.rootContext()->setContextProperty("ymlConfig", _ymlCfg);

    _engine.rootContext()->setContextProperty("processUpload", _processUpload);

    _engine.rootContext()->setContextProperty("dateModel", _dateList);

    _engine.rootContext()->setContextProperty("ymlModel", _ymlConfigModel);

    _engine.rootContext()->setContextProperty("ymlThemeModel", _ymlThemeModel);
}
