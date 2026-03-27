#ifndef IMGDOWNLOADER_H
#define IMGDOWNLOADER_H
#include <QObject>
#include <QNetworkAccessManager>
#include <QJsonObject>

class ImgDownloader: public QObject {
    Q_OBJECT
public:
    explicit ImgDownloader(QObject* parent = nullptr);
    ~ImgDownloader() = default;

private:
    QNetworkAccessManager* _netMgr;

signals:
    void SigImgDownloaded(QJsonObject, QByteArray);
    void SigImgDownloadFailed(QJsonObject);

public slots:
    void SlotDowndloadImg(QJsonObject jsonObj);
};

#endif // IMGDOWNLOADER_H
