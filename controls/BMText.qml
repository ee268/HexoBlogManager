import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import "qrc:/config/basic"

Text {
    id: root
    property int idxx: 1
    property bool runRainbow: false

    function pauseRainbow() {
        if (!rainbowAni.running) return

        rainbowAni.pause()
    }

    function resumeRainbow() {
        if (!rainbowAni.running) return

        rainbowAni.resume()
    }

    FontLoader {
        id: fontLoader
        source: Config.font
    }
    color: Config.isLightMode ? Config.dark : Config.light
    font.family: fontLoader.name
    font.pixelSize: 14

    LinearGradient  {
        anchors.fill: root
        source: root
        start: Qt.point(0, 0)  // start 和 end主要作用是从左往右
        end: Qt.point(root.width, 0)
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.hsva((15 - (((idxx + 10) > 15) ? idxx - 15 + 10:idxx + 10)) * 16/255, 1, 1,1) }
            GradientStop { position: 0.1; color: Qt.hsva((15 - (((idxx + 9) > 15) ? idxx - 15 + 9:idxx + 9)) * 16/255, 1, 1,1) }
            GradientStop { position: 0.2; color: Qt.hsva((15 - (((idxx + 8) > 15) ? idxx - 15 + 8:idxx + 8)) * 16/255, 1, 1,1) }
            GradientStop { position: 0.3; color: Qt.hsva((15 - (((idxx + 7) > 15) ? idxx - 15 + 7:idxx + 7)) * 16/255, 1, 1,1) }
            GradientStop { position: 0.4; color: Qt.hsva((15 - (((idxx + 6) > 15) ? idxx - 15 + 6:idxx + 6)) * 16/255, 1, 1,1) }
            GradientStop { position: 0.5; color: Qt.hsva((15 - (((idxx + 5) > 15) ? idxx - 15 + 5:idxx + 5)) * 16/255, 1, 1,1) }
            GradientStop { position: 0.6; color: Qt.hsva((15 - (((idxx + 4) > 15) ? idxx - 15 + 4:idxx + 4)) * 16/255, 1, 1,1) }
            GradientStop { position: 0.7; color: Qt.hsva((15 - (((idxx + 3) > 15) ? idxx - 15 + 3:idxx + 3)) * 16/255, 1, 1,1) }
            GradientStop { position: 0.8; color: Qt.hsva((15 - (((idxx + 2) > 15) ? idxx - 15 + 2:idxx + 2)) * 16/255, 1, 1,1) }
            GradientStop { position: 0.9; color: Qt.hsva((15 - (((idxx + 1) > 15) ? idxx - 15 + 1:idxx + 1)) * 16/255, 1, 1,1) }
            GradientStop { position: 1.0; color: Qt.hsva((15 - (((idxx) > 15) ? idxx - 15:idxx)) * 16/255, 1, 1,1) }
        }
        visible: runRainbow
    }

    SequentialAnimation {
        id: rainbowAni
        running: runRainbow  // 默认启动
        loops:Animation.Infinite  // 无限循环
        NumberAnimation {
            target: root  // 目标对象
            property: "idxx"  // 目标对象中的属性
            duration: 1000 // 变化时间
            to: 15  // 目标值
        }
    }
}
