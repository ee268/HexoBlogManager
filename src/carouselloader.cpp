#include "include/carouselloader.h"
#include <QFileInfo>

CarouselLoader::CarouselLoader(QObject *parent/* = nullptr*/)
    : QObject(parent)
    , _imgDownloader(new ImgDownloader(this))
{
    connect(this, &CarouselLoader::SigDownloadImg, _imgDownloader, &ImgDownloader::SlotDowndloadImg);
    connect(_imgDownloader, &ImgDownloader::SigImgDownloaded, this, &CarouselLoader::SlotDownloadedImg);
    connect(_imgDownloader, &ImgDownloader::SigImgDownloadFailed, this, &CarouselLoader::SlotDownloadFailedImg);
}

CarouselLoader::~CarouselLoader()
{

}

QString CarouselLoader::GetMainColor(QPixmap p)
{
    if (p.isNull()) {
        qDebug() << "pixmap is null";
        return "";
    }
    int bright = 1;
    int step=20; //步长：在图片中取点时两点之间的间隔，若为1,则取所有点，适当将此值调大有利于提高运行速度
    int t=0; //点数：记录一共取了多少个点，用于做计算平均数的分母
    QImage image=p.toImage(); //将Pixmap类型转为QImage类型

    if (image.isNull()) {
        qDebug() << "image is null";
        return "";
    }

    int r=0,g=0,b=0; //三元色的值，分别用于记录各个点的rgb值的和
    for (int i=0;i<p.width();i+=step) {
        for (int j=0;j<p.height();j+=step) {
            if(image.valid(i,j)){ //判断该点是否有效
                t++; //点数加一
                QColor c=image.pixel(i,j); //获取该点的颜色
                r+=c.red(); //将获取到的各个颜色值分别累加到rgb三个变量中
                b+=c.blue();
                g+=c.green();
            }
        }
    }

    if (!t || !r || !g || !b) {
        qDebug() << "'t r g b' exist zero";
        return "";
    }

    QColor res = QColor(int(bright*r/t)>255?255:int(bright*r/t),
                  int(bright*g/t)>255?255:int(bright*g/t),
                  int(bright*b/t)>255?255:int(bright*b/t),
                        221);
    // QColor res = QColor(r, g, b, 221);

    qDebug() << "GetMainColor: " << res.name();
    return res.name();
}

QString CarouselLoader::GetMainColor(QString path)
{
    if (path[0] == 'q') {
        path = path.mid(3);
    }
    return GetMainColor(QPixmap(path));
}

QJsonArray CarouselLoader::GetImgList()
{
    return _imgList;
}

QString CarouselLoader::getRoute(QString &path, FrontMatterMgr &fm)
{
    QDateTime dateTime = QDateTime::fromString(fm["date"], "yyyy/MM/dd HH:mm:ss");
    QString year = dateTime.toString("yyyy");
    QString month = dateTime.toString("MM");
    QString day = dateTime.toString("dd");
    QFileInfo fInfo(path);

    return "/" + year + "/" + month + "/" + day + "/" + fInfo.fileName().chopped(3);
}

void CarouselLoader::SlotRecvPosts(QStringList &key, QMap<QString, FrontMatterMgr>& fms)
{
    for (int i = 0; i < key.length(); i++) {
        QJsonObject jsonObj;
        jsonObj["title"] = fms[key[i]]["title"];
        jsonObj["subtitle"] = fms[key[i]]["previewStr"];
        jsonObj["externalUrl"] = getRoute(key[i], fms[key[i]]);
        if (fms[key[i]].contains("cover")) {
            jsonObj["imgUrl"] = fms[key[i]]["cover"];
        }
        else {
            jsonObj["imgUrl"] = "qrc:/res/cover/default.jpg";
            jsonObj["mainColor"] = GetMainColor(":/res/cover/default.jpg");
            _imgList.append(jsonObj);
            continue;
        }

        emit SigDownloadImg(jsonObj);
    }
}

void CarouselLoader::SlotDownloadedImg(QJsonObject jsonObj, QByteArray bytes)
{
    QPixmap pixmap;
    pixmap.loadFromData(bytes);
    jsonObj["mainColor"] = GetMainColor(pixmap);
    _imgList.append(jsonObj);
}

void CarouselLoader::SlotDownloadFailedImg(QJsonObject jsonObj)
{
    jsonObj["mainColor"] = GetMainColor(":/res/cover/default.jpg");
    _imgList.append(jsonObj);
}
