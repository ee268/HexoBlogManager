import QtQuick
import QtQuick.Controls
import "qrc:/config/basic"
import "qrc:/qml/controls"

Item {
    anchors.fill: parent
    visible: false
    opacity: 0

    BMCarousel {
        id: carousel
        anchors {
            left: parent.left
            // top: parent.top
            right: parent.right
        }

        height: parent.height * 0.4
    }

    Behavior on opacity {
        NumberAnimation {
            duration: Config.aniDuration
        }
    }

    Component.onCompleted: {
        visible = true
        opacity = 1
    }
}
