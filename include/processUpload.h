#ifndef PROCESSUPLOAD_H
#define PROCESSUPLOAD_H
#include <QObject>
#include <QString>
#include <QDebug>

class ProcessUpload: public QObject {
    Q_OBJECT
public:
    explicit ProcessUpload(QObject* obj = nullptr);
    ~ProcessUpload() = default;

    Q_INVOKABLE bool setFolderPath(QString path);

    bool isYmlFile(const QString& path);

    bool isThemeConfigYml(const QString& name);

    Q_INVOKABLE QString getFolderPath() const;
    Q_INVOKABLE QString getConfigYml() const;
    Q_INVOKABLE QString getThemeConfigYml() const;

private:
    QString folderPath;
    QString configYml;
    QString themeConfigYml;
};

#endif // PROCESSUPLOAD_H
