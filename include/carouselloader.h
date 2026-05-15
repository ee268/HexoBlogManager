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
#include <QTimer>

class CarouselLoader: public QObject
{
    Q_OBJECT
public:
    explicit CarouselLoader(QObject* parent = nullptr);
    ~CarouselLoader();

    QString GetMainColor(QPixmap pixmap);
    QString GetMainColor(QString path);

    Q_INVOKABLE QJsonArray GetImgList();
    Q_INVOKABLE bool isLoaded();

private:
    QString getRoute(QString& path, FrontMatterMgr& fm);

    ImgDownloader* _imgDownloader;
    QJsonArray _imgList;
    bool _isLoaded;
    QTimer* _timer;

signals:
    void SigDownloadImg(QJsonObject);
    void sigFinishedAllImg();

public slots:
    void SlotRecvPosts(QStringList& key, QMap<QString, FrontMatterMgr>& fms);
    void SlotDownloadedImg(QJsonObject, QByteArray);
    void SlotDownloadFailedImg(QJsonObject);
};

#endif // CAROUSELLOADER_H
