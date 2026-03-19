#include "include/carouselloader.h"

CarouselLoader::CarouselLoader(QObject *parent/* = nullptr*/)
    : QObject(parent)
{
    // initThread = std::move(std::thread([this](){ this->initList(); }));
    this->initList();
}

CarouselLoader::~CarouselLoader()
{
    // initThread.join();
}


QColor CarouselLoader::GetMainColor(QPixmap p)
{
    if (p.isNull()) {
        qDebug() << "pixmap is null";
        return QColor();
    }
    int bright = 1;
    int step=20; //步长：在图片中取点时两点之间的间隔，若为1,则取所有点，适当将此值调大有利于提高运行速度
    int t=0; //点数：记录一共取了多少个点，用于做计算平均数的分母
    QImage image=p.toImage(); //将Pixmap类型转为QImage类型

    if (image.isNull()) {
        qDebug() << "image is null";
        return QColor();
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
        return QColor();
    }

    QColor res = QColor(int(bright*r/t)>255?255:int(bright*r/t),
                  int(bright*g/t)>255?255:int(bright*g/t),
                  int(bright*b/t)>255?255:int(bright*b/t),
                        221);
    // QColor res = QColor(r, g, b, 221);

    return res;
}

QColor CarouselLoader::GetMainColor(QString path)
{
    if (path[0] == 'q') {
        path = path.mid(3);
    }
    qDebug() << "GetMainColor path: " << path;
    return GetMainColor(QPixmap(path));
}

QJsonArray CarouselLoader::GetImgList()
{
    return _imgList;
}

void CarouselLoader::initList()
{
    QJsonArray array;
    QJsonObject jsonObj;

    jsonObj["imgUrl"] = "qrc:/res/cover/default.jpg";
    jsonObj["title"] = "card1";
    jsonObj["subtitle"] = "这是“闪光”与“黑衣剑士”在被如此称呼之前的故事";
    jsonObj["mainColor"] = this->GetMainColor(jsonObj["imgUrl"].toString()).name(QColor::HexArgb);
    jsonObj["externalUrl"] = "https://ee268.github.io/";
    array.append(jsonObj);

    jsonObj["imgUrl"] = "qrc:/res/cover/default.jpg";
    jsonObj["title"] = "card2";
    jsonObj["subtitle"] = "这是“闪光”与“黑衣剑士”在被如此称呼之前的故事";
    jsonObj["mainColor"] = this->GetMainColor(jsonObj["imgUrl"].toString()).name(QColor::HexArgb);
    jsonObj["externalUrl"] = "https://ee268.github.io/";
    array.append(jsonObj);

    jsonObj["imgUrl"] = "qrc:/res/cover/default.jpg";
    jsonObj["title"] = "card3";
    jsonObj["subtitle"] = "这是“闪光”与“黑衣剑士”在被如此称呼之前的故事";
    jsonObj["mainColor"] = this->GetMainColor(jsonObj["imgUrl"].toString()).name(QColor::HexArgb);
    jsonObj["externalUrl"] = "https://ee268.github.io/";
    array.append(jsonObj);

    jsonObj["imgUrl"] = "qrc:/res/cover/default.jpg";
    jsonObj["title"] = "card4";
    jsonObj["subtitle"] = "这是“闪光”与“黑衣剑士”在被如此称呼之前的故事";
    jsonObj["mainColor"] = this->GetMainColor(jsonObj["imgUrl"].toString()).name(QColor::HexArgb);
    jsonObj["externalUrl"] = "https://ee268.github.io/";
    array.append(jsonObj);

    jsonObj["imgUrl"] = "qrc:/res/cover/default.jpg";
    jsonObj["title"] = "card5";
    jsonObj["subtitle"] = "这是“闪光”与“黑衣剑士”在被如此称呼之前的故事";
    jsonObj["mainColor"] = this->GetMainColor(jsonObj["imgUrl"].toString()).name(QColor::HexArgb);
    jsonObj["externalUrl"] = "https://ee268.github.io/";
    array.append(jsonObj);

    this->_imgList = array;
}
