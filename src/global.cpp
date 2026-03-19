#include "include/global.h"
#include <QQmlContext>

GlobalMgr::GlobalMgr(QQmlApplicationEngine& engine, QObject* parent/* = nullptr*/)
    : QObject(parent)
    , _engine(engine)
    , _carouselLouader(nullptr)
    , _processImport(nullptr)
    , _blogMgr(nullptr)
    , _processUpload(nullptr)
{
    _carouselLouader = new CarouselLoader(&_engine);
    _blogMgr = new BlogMgr(&_engine);
    _processUpload = new ProcessUpload(&_engine);
    _processImport = new ProcessImport(_blogMgr, _processUpload, &_engine);

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

    _engine.rootContext()->setContextProperty("processUpload", _processUpload);
}
