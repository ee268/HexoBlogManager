#ifndef PROCESSUPLOAD_H
#define PROCESSUPLOAD_H
#include <QObject>
#include <QProcess>
#include <QQueue>

struct Command {
    Command(QString pgm, QStringList args)
        : _program(pgm)
        , _args(args)
    {}

    Command& operator=(const Command& cmd) {
        _program = cmd._program;
        _args = cmd._args;
        return *this;
    }

    QString _program;
    QStringList _args;
};

class ProcessUpload: public QObject {
    Q_OBJECT
public:
    explicit ProcessUpload(QObject* parent = nullptr);
    ~ProcessUpload();

    void startCommand(QString program, QStringList args);

    Q_INVOKABLE void addCommand(QString program, QStringList args);

    Q_INVOKABLE void stopHexoS();

private:
    QString cleanAnsiCharacters(const QString& data);
    void initConnect();
    void forceKillProcess();

    QString _workPath;
    QProcess* _process;
    QProcess* _killProcess;
    QQueue<Command> _commands;

signals:
    void sigFinishedCommand(bool);
    void sigSendOutput(QString);
    void sigStartServer();
    void sigStopServer();

public slots:
    void SlotImportFinished(QString path);
    void SlotSendStandardOutput();
    void SlotSendStandardError();
    void SlotProcessFinished(int exitCode, QProcess::ExitStatus exitStatus);
};


#endif // PROCESSUPLOAD_H
