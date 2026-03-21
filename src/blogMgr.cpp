#include "include/blogMgr.h"
#include <QDir>

BlogMgr::BlogMgr(QObject *obj)
    : QObject(obj)
{

}

void BlogMgr::setPostPath(QString path)
{
    clear();
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

QString BlogMgr::getPostContent(int idx)
{
    if (idx < 0 || idx >= _postPaths.size()) {
        qDebug() << "index out of range";
        return QString();
    }

    QFile r(_postPaths[idx]);
    if (!r.open(QFile::ReadOnly)) {
        qDebug() << "open " << _postPaths[idx] << " failed";
        return QString();
    }

    QString content = r.readAll();
    r.close();
    return content;
}

bool BlogMgr::savePost(int idx, QByteArray content)
{
    if (idx < 0 || idx >= _postPaths.size()) {
        return false;
    }

    QString path = _postPaths[idx];
    QFile f(path);
    if (!f.open(QFile::WriteOnly)) {
        qDebug() << "open md file failed, " << path << " error, " << f.errorString();
        return false;
    }

    f.write(content);
    f.close();

    return true;
}

void BlogMgr::reload()
{
    setPostPath(_postPath);
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

void BlogMgr::clear()
{
    _postPath.clear();
    _postPaths.clear();
    _fmMgr.clear();
}

void BlogMgr::SlotImportFinished(QString path)
{
    setPostPath(path);
}

