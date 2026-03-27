#include "include/processImport.h"
#include <QFile>
#include <QDir>
#include <yaml-cpp/yaml.h>
#include <QRegularExpression>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QCoreApplication>
#include <QDate>

ProcessImport::ProcessImport(BlogMgr* blogMgr, ProcessUpload* pUpload,
                             YmlConfig* ymlCfg, YmlTreeModel* themeModel,
                             QObject* obj/* = nullptr*/)
    : QObject(obj)
    , _themeModel(themeModel)
{
    connect(
        this,
        &ProcessImport::SigImportFinished,
        blogMgr,
        &BlogMgr::SlotImportFinished);

    connect(
        this,
        &ProcessImport::SigImportFinished,
        pUpload,
        &ProcessUpload::SlotImportFinished);

    connect(
        this,
        &ProcessImport::SigImportConfigFinished,
        ymlCfg,
        &YmlConfig::slotInitConfig);

    loadHistory();
}

bool ProcessImport::setFolderPath(QString path)
{
    QDir dir(path);
    QFileInfo fInfo(path);
    if (!dir.exists() || !fInfo.isDir()) {
        qDebug() << "this path not a directory" << path;
        return false;
    }

    QFileInfoList fileList = dir.entryInfoList(QDir::Dirs | QDir::Files | QDir::NoDotAndDotDot);

    int initFlag = 0;

    for (auto& file : fileList) {
        // qDebug() << file.filePath();
        if (initFlag == 3) break;

        auto fName = file.fileName();
        if (fName.mid(0, 7) == "_config") {
            if (fName == "_config.yml") {
                bool isYml = isYmlFile(file.filePath());
                if (!isYml) {
                    qDebug() << "not yml file: " << file.filePath();
                    return false;
                }

                _configYml = file.filePath();
                emit SigImportConfigFinished(_configYml);
                initFlag++;
                continue;
            }
        }

        if (fName == "source") {
            QDir srcDir(file.filePath());
            QFileInfoList fl = srcDir.entryInfoList(QDir::Dirs | QDir::NoDotAndDotDot);
            for (auto& f : fl) {
                if (f.fileName() == "_posts") {
                    _postPath = f.filePath();
                    // qDebug() << f.fileName() << " haha " << f.filePath();
                    initFlag++;
                    break;
                }
            }
        }
    }

    if (initFlag != 2) {
        return false;
    }

    _folderPath = path;

    emit SigImportFinished(_postPath);

    if (!isLoad) {
        saveHistory();
    }
    isLoad = false;

    return true;
}

void ProcessImport::setThemeConfigYml(QString path)
{
    _themeConfigYml = path.mid(8);
    _themeModel->init(_themeConfigYml);
}

bool ProcessImport::isYmlFile(const QString &path)
{
    try {
        YAML::Node node = YAML::LoadFile(path.toStdString());
        return true;
    }
    catch (const std::exception& e) {
        qDebug() << "isYmlFile false: " << e.what();
        return false;
    }

    return false;
}

bool ProcessImport::isThemeConfigYml(const QString &name)
{
    QRegularExpression re("^_[^.\s]+\.[^.\s]+\.(yml|yaml)$");
    QRegularExpressionMatch match = re.match(name);
    if (match.hasMatch()) {
        return true;
    }

    return true;
}

QString ProcessImport::getFolderPath() const
{
    return _folderPath;
}

QString ProcessImport::getConfigYml() const
{
    return _configYml;
}

QString ProcessImport::getThemeConfigYml() const
{
    return _themeConfigYml;
}

QString ProcessImport::getPostPath() const
{
    return _postPath;
}

void ProcessImport::saveHistory()
{
    QString path = QCoreApplication::applicationDirPath() + "/history.json";
    QFile r(path);
    if (!r.open(QIODevice::ReadOnly)) {
        QFile f(path);
        if (!f.open(QIODevice::WriteOnly)) {
            qDebug() << "ReadOnly: save to history.json occur error" << path;
            return;
        }
        f.close();
    }

    QByteArray all = r.readAll();
    r.close();
    QJsonParseError jsonErr;
    QJsonDocument jsonDoc(QJsonDocument::fromJson(all, &jsonErr));

    QFile f(path);
    if (!f.open(QIODevice::WriteOnly)) {
        qDebug() << "WriteOnly: save to history.json occur error";
        return;
    }

    if (jsonErr.error != QJsonParseError::NoError) {
        QJsonArray jsonArray;
        QJsonObject jsonObj;
        QFileInfo fInfo(_folderPath);
        jsonObj["name"] = fInfo.fileName();
        jsonObj["path"] = _folderPath;
        QString curDate =
            QString::number(QDate::currentDate().year()) + "/" +
            QString::number(QDate::currentDate().month()) + "/" +
            QString::number(QDate::currentDate().day());
        jsonObj["date"] = curDate;
        jsonArray.append(jsonObj);
        QJsonDocument res(jsonArray);
        f.write(res.toJson(QJsonDocument::Compact));
        f.close();
        return;
    }

    QJsonArray array = jsonDoc.array();
    QJsonObject jsonObj;
    QFileInfo fInfo(_folderPath);
    jsonObj["name"] = fInfo.fileName();
    jsonObj["path"] = _folderPath;
    QString curDate =
        QString::number(QDate::currentDate().year()) + "/" +
        QString::number(QDate::currentDate().month()) + "/" +
        QString::number(QDate::currentDate().day());
    jsonObj["date"] = curDate;

    if (array.size() > 10) {
        array.removeLast();
    }
    array.insert(0, jsonObj);

    QJsonDocument res(array);
    // qDebug() << QString(res.toJson());
    f.write(res.toJson(QJsonDocument::Compact));
    f.close();
}

void ProcessImport::loadHistory()
{
    QString path = QCoreApplication::applicationDirPath() + "/history.json";
    QFile r(path);
    if (!r.open(QIODevice::ReadOnly)) {
        qDebug() << "ReadOnly: load to history.json occur error" << path;
        return;
    }

    QByteArray all = r.readAll();
    r.close();
    QJsonParseError jsonErr;
    QJsonDocument jsonDoc(QJsonDocument::fromJson(all, &jsonErr));
    if (jsonErr.error != QJsonParseError::NoError) {
        return;
    }

    QJsonArray array = jsonDoc.array();
    QString folderPath =  array[0].toObject()["path"].toString();

    isLoad = true;
    setFolderPath(folderPath);
}

QJsonArray ProcessImport::readHistory()
{
    QString path = QCoreApplication::applicationDirPath() + "/history.json";
    QFile r(path);
    if (!r.open(QIODevice::ReadOnly)) {
        qDebug() << "ReadOnly: read to history.json occur error";
        return QJsonArray();
    }

    QByteArray all = r.readAll();
    r.close();
    QJsonParseError jsonErr;
    QJsonDocument jsonDoc(QJsonDocument::fromJson(all, &jsonErr));
    if (jsonErr.error != QJsonParseError::NoError) {
        qDebug() << "JsonParseError: " << jsonErr.errorString();
        return QJsonArray();
    }

    return jsonDoc.array();
}
