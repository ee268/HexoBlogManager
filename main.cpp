#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQmlContext>
#include "include/carouselloader.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    //支持自定义控件样式
    QQuickStyle::setStyle("Basic");

    QQmlApplicationEngine engine;

    CarouselLoader* carouselLouader = new CarouselLoader(&engine);
    engine.rootContext()->setContextProperty("carouselLoader", carouselLouader);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("BlogManager", "Main");

    return app.exec();
}
