#include "include/blogMgr.h"
#include <QDir>

BlogMgr::BlogMgr(QObject *obj)
    : QObject(obj)
{

}

void BlogMgr::setPostPath(QString path)
{
    _postPath = path;
    initPosts();
}

QJsonArray BlogMgr::getBlogInfo()
{
    if (_postPaths.empty() || _fmMgr.empty()) return QJsonArray();

    QJsonArray jsonArray;
    for (auto& s : _postPaths) {
        QJsonObject jsonObj;
        jsonObj["name"] = _fmMgr[s]["title"];
        jsonObj["date"] = _fmMgr[s]["date"];
        jsonObj["previewStr"] = _fmMgr[s]["previewStr"];
        if (_fmMgr[s].contains("cover")) {
            jsonObj["cover"] = _fmMgr[s]["cover"];
        }
        else {
            jsonObj["cover"] = "qrc:/res/cover/default.jpg";
        }

        jsonArray.append(jsonObj);
    }

    return jsonArray;
}

void BlogMgr::initPosts()
{
    QDir dir(_postPath);
    QFileInfo fInfo(_postPath);
    if (!dir.exists() || !fInfo.isDir()) {
        qDebug() << "_postPath not a directory" << _postPath;
        return;
    }

    QFileInfoList fileList = dir.entryInfoList(QDir::Files | QDir::NoDotAndDotDot);
    for (auto& f : fileList) {
        auto fName = f.fileName();
        if (isMdSuffix(fName)) {
            _postPaths.push_back(f.filePath());
            FrontMatterMgr fmMgr(f.filePath());
            _fmMgr[f.filePath()] = fmMgr;
        }
    }
}

bool BlogMgr::isMdSuffix(QString& name)
{
    return name.mid(name.length() - 3) == ".md";
}

void BlogMgr::SlotImportFinished(QString path)
{
    setPostPath(path);
}

