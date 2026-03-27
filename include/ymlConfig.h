#ifndef YMLCONFIG_H
#define YMLCONFIG_H
#include <QObject>
#include <yaml-cpp/yaml.h>

class YmlConfig: public QObject {
    Q_OBJECT
public:
    explicit YmlConfig(QObject* parent = nullptr);
    ~YmlConfig() = default;

    Q_INVOKABLE QString getAuthor();

    Q_INVOKABLE QString getDesc();

    Q_INVOKABLE QString getBlogUrl();

private:
    void initConfig();

    YAML::Node _node;
    QString _cfgPath;

public slots:
    void slotInitConfig(QString path);
};

#endif // YMLCONFIG_H
