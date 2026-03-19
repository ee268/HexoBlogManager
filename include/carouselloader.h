#ifndef CAROUSELLOADER_H
#define CAROUSELLOADER_H

#include <QObject>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDebug>
#include <QColor>
#include <QPixmap>
#include <QRgb>
#include <QString>

class CarouselLoader: public QObject
{
    Q_OBJECT
public:
    explicit CarouselLoader(QObject* parent = nullptr);
    ~CarouselLoader();

    Q_INVOKABLE QColor GetMainColor(QPixmap pixmap);
    Q_INVOKABLE QColor GetMainColor(QString path);

    Q_INVOKABLE QJsonArray GetImgList();

private:
    void initList();

    QJsonArray _imgList;
};

#endif // CAROUSELLOADER_H
