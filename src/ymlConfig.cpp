#include "include/ymlConfig.h"
#include <QDebug>
#include <algorithm>

YmlConfig::YmlConfig(QObject *parent/* = nullptr*/)
    : QObject(parent)
    , _cfgPath("")
{

}

QString YmlConfig::getAuthor()
{
    if (_node["author"]) {
        return QString::fromStdString(_node["author"].as<std::string>());
    }

    return "";
}

QString YmlConfig::getDesc()
{
    if (_node["description"]) {
        return QString::fromStdString(_node["description"].as<std::string>());
    }

    return "";
}

QString YmlConfig::getBlogUrl()
{
    if (_node["deploy"]) {
        std::string url = _node["deploy"]["repository"].as<std::string>();
        std::string repoName = "";
        for (int i = url.length() - 5; i >= 0; i--) {
            if (url[i] == '/') {
                break;
            }
            repoName += url[i];
        }

        std::reverse(repoName.begin(), repoName.end());
        std::string link = "https://" + repoName;
        return QString::fromStdString(link);
    }

    return "";
}

void YmlConfig::initConfig()
{
    try {
        _node = YAML::LoadFile(_cfgPath.toStdString());

    } catch(std::exception& e) {
        qDebug () << "initConfig failed" << " error is: " << e.what();
    }
}

void YmlConfig::slotInitConfig(QString path)
{
    _cfgPath = path;
    initConfig();
}
