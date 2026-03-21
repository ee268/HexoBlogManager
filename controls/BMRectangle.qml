import QtQuick
import "qrc:/config/basic"
import QtQuick.Effects

Item {
    property alias radius: rec.radius
    property alias color: rec.color
    property bool shadowVisible: true
    property alias shadowBlur: multiEffect.shadowBlur

    Rectangle {
        id: rec
        height: parent.height
        width: parent.width
        radius: 5
        color: Config.isLightMode ? Config.light : Config.dark

        Behavior on color {
            ColorAnimation {
                duration: Config.aniDuration
            }
        }
    }

    MultiEffect {
        id: multiEffect
        source: rec
        anchors.fill: rec
        shadowEnabled: true
        shadowBlur: 0.3
        shadowColor: Config.isLightMode ? Config.dark : Config.light
        autoPaddingEnabled: true
        visible: shadowVisible
    }
}
