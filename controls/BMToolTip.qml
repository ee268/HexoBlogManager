import QtQuick
import QtQuick.Controls
import "qrc:/config/basic"

ToolTip {
    id: customTooltip
    delay: 500
    timeout: 5000
    visible: false

    contentItem: BMText {
        text: customTooltip.text
    }

    background: Rectangle {
        color: Config.isLightMode ? Config.light : Config.dark
        radius: 6
        border.width: 1
        border.color: Config.isLightMode ? Config.dark : Config.light
    }
}
