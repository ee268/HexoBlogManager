#include "include/processUpload.h"
#include <QFile>
#include <QDir>
#include <yaml-cpp/yaml.h>
#include <QRegularExpression>

ProcessUpload::ProcessUpload(QObject* obj/* = nullptr*/)
    : QObject(obj)
{

}

bool ProcessUpload::setFolderPath(QString path)
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
        if (initFlag == 2) break;

        auto fName = file.fileName();
        if (fName.mid(0, 7) == "_config") {
            if (fName == "_config.yml") {
                bool isYml = isYmlFile(file.filePath());
                if (!isYml) {
                    qDebug() << "not yml file: " << file.filePath();
                    return false;
                }

                configYml = file.filePath();
                initFlag++;
                continue;
            }
            if (isThemeConfigYml(fName)) {
                bool isYml = isYmlFile(file.filePath());
                if (!isYml) {
                    qDebug() << "not yml file: " << file.filePath();
                    return false;
                }

                themeConfigYml = file.filePath();
                initFlag++;
                continue;
            }
        }
    }

    folderPath = path;

    return true;
}

bool ProcessUpload::isYmlFile(const QString &path)
{
    try {
        YAML::Node node = YAML::LoadFile(path.toStdString());
        return true;
    }
    catch (std::exception& e) {
        qDebug() << "isYmlFile false: " << e.what();
        return false;
    }

    return false;
}

bool ProcessUpload::isThemeConfigYml(const QString &name)
{
    QRegularExpression re("^_[^.\s]+\.[^.\s]+\.(yml|yaml)$");
    QRegularExpressionMatch match = re.match(name);
    if (match.hasMatch()) {
        return true;
    }

    return true;
}

QString ProcessUpload::getFolderPath() const
{
    return folderPath;
}

QString ProcessUpload::getConfigYml() const
{
    return configYml;
}

QString ProcessUpload::getThemeConfigYml() const
{
    return themeConfigYml;
}
