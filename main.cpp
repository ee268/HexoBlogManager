#include <QQmlApplicationEngine>
#include <QApplication>
#include <QQuickStyle>
#include "include/global.h"
#include <QQuickWindow>
#include <QtWebEngineQuick>

int main(int argc, char *argv[])
{
    //取消各种乱七八糟的警告和报错
    QCoreApplication::setAttribute(Qt::AA_ShareOpenGLContexts);
    QQuickWindow::setGraphicsApi(QSGRendererInterface::OpenGLRhi);\
    qputenv("QTWEBENGINE_CHROMIUM_FLAGS", "--log-level=3");

    //初始化webengine
    QtWebEngineQuick::initialize();

    QApplication app(argc, argv);

    //支持自定义控件样式
    QQuickStyle::setStyle("Basic");

    QQmlApplicationEngine engine;

    GlobalMgr gMgr(engine, &app);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("BlogManager", "Main");

    return app.exec();
}
