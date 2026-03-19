#include <QQmlApplicationEngine>
#include <QApplication>
#include <QQuickStyle>
#include "include/global.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    //支持自定义控件样式
    QQuickStyle::setStyle("Basic");

    QQmlApplicationEngine engine;

    //初始化
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
