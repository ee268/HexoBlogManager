#include "include/systemThemeHelper.h"
#include <QGuiApplication>
#include <QStyleHints>
#include <QPalette>

SystemThemeHelper::SystemThemeHelper(QObject *parent)
    : QObject(parent)
    , _timer(new QTimer(this))
{
    _colorScheme = getColorScheme();

    _timer->setInterval(200);
    connect(_timer, &QTimer::timeout, [this](){
        _colorScheme = getColorScheme();
        emit colorSchemeChanged(_colorScheme);
    });
    _timer->start();
}

SystemThemeHelper::ColorScheme SystemThemeHelper::V_None() const
{
    return ColorScheme::None;
}

SystemThemeHelper::ColorScheme SystemThemeHelper::V_Light() const
{
    return ColorScheme::Light;
}

SystemThemeHelper::ColorScheme SystemThemeHelper::V_Dark() const
{
    return ColorScheme::Dark;
}

SystemThemeHelper::ColorScheme SystemThemeHelper::getColorScheme()
{
#if QT_VERSION >= QT_VERSION_CHECK(6, 5, 0)
    const auto scheme = QGuiApplication::styleHints()->colorScheme();
    return scheme == Qt::ColorScheme::Dark ? ColorScheme::Dark : ColorScheme::Light;
#else
#ifdef Q_OS_WIN
    return !d->m_colorSchemeSettings.value("AppsUseLightTheme").toBool() ? ColorScheme::Dark : ColorScheme::Light;
#else //linux
    const QPalette defaultPalette;
    const auto text = defaultPalette.color(QPalette::WindowText);
    const auto window = defaultPalette.color(QPalette::Window);
    return text.lightness() > window.lightness() ? ColorScheme::Dark : ColorScheme::Light;
#endif // Q_OS_WIN
#endif // QT_VERSION
}

SystemThemeHelper::ColorScheme SystemThemeHelper::colorScheme() const
{
    return _colorScheme;
}
