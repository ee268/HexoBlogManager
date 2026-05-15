#include "include/global.h"
#include <QQmlContext>
#include <QFile>
#include <QCoreApplication>

GlobalMgr::GlobalMgr(QQmlApplicationEngine& engine, QObject* parent/* = nullptr*/)
    : QObject(parent)
    , _engine(engine)
    , _configYmlContent("")
    , _themeYmlContent("")
{
    _processUpload = new ProcessUpload(&_engine);
    _ymlCfg = new YmlConfig(&engine);
    _dateList = new DateListModel(&engine);
    _carouselLouader = new CarouselLoader(&_engine);
    _blogMgr = new BlogMgr(_dateList, _carouselLouader, &_engine);
    _processImport = new ProcessImport(_blogMgr, _processUpload, _ymlCfg, &_engine);
    _themeHelper = new SystemThemeHelper(&_engine);

    readSettings();

    initContextProperty();
}

GlobalMgr::~GlobalMgr()
{
    saveSettings();
}

void GlobalMgr::setValue(QString key, QVariant value)
{
    QJsonObject jsonObj;
    if (!_doc.isEmpty() && !_doc.isNull()) {
        jsonObj = _doc.object();
    }

    jsonObj[key] = value.toJsonValue();
    _doc.setObject(jsonObj);
}

QVariant GlobalMgr::getValue(QString key)
{
    QJsonObject jsonObj;
    if (_doc.isEmpty() && _doc.isNull()) {
        return QVariant();
    }

    jsonObj = _doc.object();
    return jsonObj[key].toVariant();
}

bool GlobalMgr::contains(const QString key)
{
    QJsonObject jsonObj;
    if (!_doc.isEmpty() && !_doc.isNull()) {
        jsonObj = _doc.object();
    }

    return jsonObj.contains(key);
}

QString GlobalMgr::getConfigYmlContent()
{
    QString path = _processImport->getConfigYml();
    if (path.isEmpty())
        return {};

    QFile f(path);
    if (!f.open(QIODevice::ReadOnly)) {
        qDebug() << "getConfigYmlContent open failed" << path;
        f.close();
        return {};
    }

    QString content = QString::fromUtf8(f.readAll());
    f.close();
    return content;
}

QString GlobalMgr::getThemeConfigYmlContent()
{
    QString path = _processImport->getThemeConfigYml();
    if (path.isEmpty())
        return {};

    QFile f(path);
    if (!f.open(QIODevice::ReadOnly)) {
        qDebug() << "getThemeConfigYmlContent open failed" << path;
        f.close();
        return {};
    }

    QString content = QString::fromUtf8(f.readAll());
    f.close();
    return content;
}

bool GlobalMgr::saveConfigYml()
{
    QString path = _processImport->getConfigYml();
    if (path.isEmpty() || _configYmlContent.isEmpty())
        return false;

    QFile f(path);
    if (!f.open(QIODevice::WriteOnly)) {
        qDebug() << "saveConfigYml open failed" << path;
        f.close();
        return false;
    }

    f.write(_configYmlContent.toUtf8());

    return true;
}

bool GlobalMgr::saveThemeYml()
{
    QString path = _processImport->getThemeConfigYml();
    if (path.isEmpty() || _themeYmlContent.isEmpty())
        return false;

    QFile f(path);
    if (!f.open(QIODevice::WriteOnly)) {
        qDebug() << "saveConfigYml open failed" << path;
        f.close();
        return false;
    }

    f.write(_themeYmlContent.toUtf8());

    return true;
}

void GlobalMgr::setThemeYmlContent(QString content)
{
    _themeYmlContent = content;
}

void GlobalMgr::setConfigYmlContent(QString content)
{
    _configYmlContent = content;
}

void GlobalMgr::initContextProperty()
{
    _engine.rootContext()->setContextProperty("carouselLoader", _carouselLouader);

    _engine.rootContext()->setContextProperty("processImport", _processImport);

    _engine.rootContext()->setContextProperty("blogMgr", _blogMgr);

    _engine.rootContext()->setContextProperty("ymlConfig", _ymlCfg);

    _engine.rootContext()->setContextProperty("processUpload", _processUpload);

    _engine.rootContext()->setContextProperty("dateModel", _dateList);

    _engine.rootContext()->setContextProperty("themeHelper", _themeHelper);
}

void GlobalMgr::readSettings()
{
    QString path = QCoreApplication::applicationDirPath() + "/settings.json";
    QFile f(path);
    if (!f.open(QIODevice::ReadOnly)) {
        qDebug() << "readSettings settings.json open failed" << path;
        f.close();
        return;
    }

    QByteArray all = f.readAll();
    f.close();
    QJsonParseError jsonErr;
    QJsonDocument jsonDoc = QJsonDocument::fromJson(all, &jsonErr);
    if (jsonErr.error != QJsonParseError::NoError) {
        qDebug() << "readSettings json parse failed" << path;
        return;
    }

    _doc = jsonDoc;

    if (contains("themeConfigYml")) {
        _processImport->setThemeConfigYml(getValue("themeConfigYml").toString());
    }
}

void GlobalMgr::saveSettings()
{
    QString path = QCoreApplication::applicationDirPath() + "/settings.json";
    QFile f(path);
    if (!f.open(QIODevice::WriteOnly)) {
        qDebug() << "saveSettings settings.json open failed" << path;
        f.close();
        return;
    }

    f.write(_doc.toJson(QJsonDocument::Indented));
    f.close();
}
