#include <QQmlApplicationEngine>
#include <QApplication>
#include <QQuickStyle>
#include <QQmlContext>
#include "include/carouselloader.h"
#include "include/processUpload.h"

void initContextProperty(QQmlApplicationEngine& engine) {
    CarouselLoader* carouselLouader = new CarouselLoader(&engine);
    engine.rootContext()->setContextProperty("carouselLoader", carouselLouader);

    ProcessUpload* processUpload = new ProcessUpload(&engine);
    engine.rootContext()->setContextProperty("processUpload", processUpload);
}

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    //支持自定义控件样式
    QQuickStyle::setStyle("Basic");

    QQmlApplicationEngine engine;

    initContextProperty(engine);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("BlogManager", "Main");

    return app.exec();
}
