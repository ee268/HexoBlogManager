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
#include "include/frontMatterMgr.h"
#include "include/imgDownloader.h"

class CarouselLoader: public QObject
{
    Q_OBJECT
public:
    explicit CarouselLoader(QObject* parent = nullptr);
    ~CarouselLoader();

    QString GetMainColor(QPixmap pixmap);
    QString GetMainColor(QString path);

    Q_INVOKABLE QJsonArray GetImgList();

private:
    QString getRoute(QString& path, FrontMatterMgr& fm);

    ImgDownloader* _imgDownloader;
    QJsonArray _imgList;

signals:
    void SigDownloadImg(QJsonObject);

public slots:
    void SlotRecvPosts(QStringList& key, QMap<QString, FrontMatterMgr>& fms);
    void SlotDownloadedImg(QJsonObject, QByteArray);
    void SlotDownloadFailedImg(QJsonObject);
};

#endif // CAROUSELLOADER_H
