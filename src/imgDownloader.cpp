#include "include/imgDownloader.h"
#include <QDebug>
#include <QNetworkReply>

ImgDownloader::ImgDownloader(QObject *parent)
    : QObject(parent)
{
    _netMgr = new QNetworkAccessManager(this);
}

void ImgDownloader::SlotDowndloadImg(QJsonObject jsonObj)
{
    QString link = jsonObj["imgUrl"].toString();
    QUrl url(link);
    QNetworkRequest request(url);
    QNetworkReply* reply = _netMgr->get(request);
    connect(reply, &QNetworkReply::finished, [this, jsonObj, reply](){
        if (reply->error() != QNetworkReply::NoError) {
            emit SigImgDownloadFailed(jsonObj);
            return;
        }
        QByteArray imgData = reply->readAll();
        emit SigImgDownloaded(jsonObj, imgData);
    });
}
