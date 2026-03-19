#include "include/frontMatterMgr.h"
#include <QFileInfo>
#include <QTextStream>

const QString mark = "---";

FrontMatterMgr::FrontMatterMgr(QString postPath)
{
    initFM(postPath);
}

FrontMatterMgr::FrontMatterMgr(const FrontMatterMgr &fm)
    : _fms(fm.getMap())
{

}

FrontMatterMgr& FrontMatterMgr::operator=(const FrontMatterMgr& fm) {
    _fms = fm.getMap();
    return *this;
}

QString& FrontMatterMgr::operator[](QString key) {
    return _fms[key];
}

bool FrontMatterMgr::contains(const QString &key)
{
    return _fms.contains(key);
}

QMap<QString, QString> FrontMatterMgr::getMap() const
{
    return _fms;
}

void FrontMatterMgr::initFM(QString path)
{
    QFileInfo fInfo(path);
    if (!fInfo.isFile()) {
        qDebug() << "initFM: path not a file" << path;
        return;
    }

    QFile file(path);

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "can't open file:" << file.errorString();
        return;
    }

    QTextStream in(&file);
    QString line = in.readLine();

    if (line != mark) {
        qDebug() << "can't find frontMatter" << path;
        return;
    }

    while (!in.atEnd()) {
        line = in.readLine();
        if (line == mark) break;
        QStringList res = splitKV(line);
        _fms[res[0]] = res[1];
    }

    QString previewStr;
    for (int i = 0; !in.atEnd() && i < 10; i++) {
        previewStr += in.readLine();
    }
    _fms["previewStr"] = previewStr.remove(" ");
}

QStringList FrontMatterMgr::splitKV(QString &str)
{
    QStringList res;
    QString tmp;
    for (int i = 0; i < str.length(); i++) {
        if (str[i] == ':') {
            res.append(tmp);
            tmp.clear();
            for (int j = i + 1; j < str.length(); j++) {
                if (str[j] == ' ') continue;
                for (int k = j; k < str.length(); k++) {
                    tmp += str[k];
                }
                res.append(tmp);
                break;
            }
            break;
        }
        if (str[i] == ' ') continue;

        tmp += str[i];
    }

    return res;
}
