#ifndef SYSTEMTHEMEHELPER_H
#define SYSTEMTHEMEHELPER_H
#include <QObject>
#include <QtQml/qqml.h>
#include <QTimer>

class SystemThemeHelper : public QObject
{
    Q_OBJECT
    Q_PROPERTY(SystemThemeHelper::ColorScheme colorScheme READ colorScheme NOTIFY colorSchemeChanged)

public:
    enum ColorScheme {
        Dark,
        Light,
        None
    };

    explicit SystemThemeHelper(QObject* parent = nullptr);
    ~SystemThemeHelper() = default;

    Q_INVOKABLE ColorScheme V_Dark() const;
    Q_INVOKABLE ColorScheme V_Light() const;
    Q_INVOKABLE ColorScheme V_None() const;

    ColorScheme colorScheme() const;

    ColorScheme getColorScheme();

signals:
    void colorSchemeChanged(ColorScheme scheme);

private:
    ColorScheme _colorScheme;
    QTimer* _timer;
};

#endif // SYSTEMTHEMEHELPER_H
