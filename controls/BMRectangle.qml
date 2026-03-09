import QtQuick
import "qrc:/config/basic"
import QtQuick.Effects
import Qt5Compat.GraphicalEffects

Item {
    property alias radius: rec.radius
    property alias color: rec.color

    Rectangle {
        id: rec
        height: parent.height
        width: parent.width
        radius: 5
    }

    MultiEffect {
        source: rec
        anchors.fill: rec
        shadowEnabled: true
        shadowBlur: 0.4
        shadowColor: Config.isLightMode ? Config.dark : Config.light
        autoPaddingEnabled: true
    }
}
