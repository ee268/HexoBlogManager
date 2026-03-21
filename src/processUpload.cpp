#include "include/processUpload.h"
#include <QDebug>
#include <QRegularExpression>
#include <QDesktopServices>
#include <QUrl>

ProcessUpload::ProcessUpload(QObject *parent/* = nullptr*/)
    : QObject(parent)
    , _workPath("")
    , _process(new QProcess(this))
    , _killProcess(new QProcess(this))
{

}

ProcessUpload::~ProcessUpload()
{
    if (_process) {
        forceKillProcess();
        _process->deleteLater();
        _killProcess->deleteLater();
    }
}

void ProcessUpload::startCommand(QString program, QStringList args) {
    if (_workPath.isEmpty()) {
        emit sigFinishedCommand(false);
        return;
    }

    if (program == "hexo" && args[0] == "s") {
        emit sigStartServer();
        QDesktopServices::openUrl(QUrl("http://localhost:4000"));
    }

    _process->setWorkingDirectory(_workPath);

    initConnect();

#ifdef Q_OS_WIN
    _process->start("cmd", QStringList() << "/c" << program << args);
#else
    _process->start(program, args);
#endif
}

void ProcessUpload::addCommand(QString program, QStringList args)
{
    Command c(program, args);
    _commands.enqueue(c);

    if (_process->state() != QProcess::NotRunning) {
        return;
    }

    if (_commands.size() == 1) {
        startCommand(c._program, c._args);
        return;
    }

    qDebug() << "not excute command";
}

void ProcessUpload::stopHexoS()
{
    if (_process && _process->state() == QProcess::Running) {
        forceKillProcess();
        qDebug() << "Hexo Server has stopped";
    }
}

void ProcessUpload::SlotImportFinished(QString path)
{
    _workPath = path;
}

void ProcessUpload::SlotSendStandardOutput()
{
    QByteArray data = _process->readAllStandardOutput();
    QString output = data;
    // qDebug().noquote() << "StandardOutput: " << output;
    emit sigSendOutput(cleanAnsiCharacters(output));
}

void ProcessUpload::SlotSendStandardError()
{
    QByteArray data = _process->readAllStandardError();
    QString output = data;
    // qDebug().noquote() << "StandardError: " << output;
    emit sigSendOutput(cleanAnsiCharacters(output));
}

void ProcessUpload::SlotProcessFinished(int exitCode, QProcess::ExitStatus exitStatus)
{
    if (!_commands.isEmpty()) {
        Command c = _commands.dequeue();
    }
    if (!_commands.isEmpty()) {
        Command c = _commands.dequeue();
        startCommand(c._program, c._args);
    }

    emit sigFinishedCommand(true);
}

QString ProcessUpload::cleanAnsiCharacters(const QString& data) {
    // 匹配 ANSI 转义序列的正则表达式
    static QRegularExpression ansiRegex("[\u001b\u009b][[\\]()#;?]*"
                                        "(?:(?:(?:[a-zA-Z\\d]*(?:;[-a-zA-Z\\d\\/#&.:=?%@~_]*)*)?\u0007)"
                                        "|(?:(?:\\d{1,4}(?:;\\d{0,4})*)?[\\dA-PR-TZcf-ntqry=><~]))");

    QString cleanStr = data;
    return cleanStr.remove(ansiRegex);
}

void ProcessUpload::initConnect()
{
    connect(_process, &QProcess::readyReadStandardOutput, this, &ProcessUpload::SlotSendStandardOutput);
    connect(_process, &QProcess::readyReadStandardError, this, &ProcessUpload::SlotSendStandardError);

    connect(_process, &QProcess::errorOccurred, this, [this](QProcess::ProcessError error) {
        qDebug() << "QProcess start failed, error is " << error;
        emit sigFinishedCommand(false);
    });

    connect(_process, &QProcess::finished, this, &ProcessUpload::SlotProcessFinished);
    connect(_process, &QProcess::finished, this, [this](){
        emit sigStopServer();
    });
}

void ProcessUpload::forceKillProcess() {
    if (!_process || _process->state() == QProcess::NotRunning) return;

    qint64 pid = _process->processId();

#ifdef Q_OS_WIN
    QStringList killArgs;
    killArgs << "/F" << "/T" << "/PID" << QString::number(pid);

    //阻塞
    _killProcess->start("taskkill", killArgs);
#else
    _process->kill();
#endif
}
