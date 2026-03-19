import QtQuick
import Qt5Compat.GraphicalEffects
import "qrc:/config/basic"

Rectangle {
    id: root
    color: "#e0646464"
    anchors.fill: parent
    visible: Config.isLoading

    BMRectangle {
        id: loadingBg
        anchors.centerIn: parent
        width: 230
        height: width

        Rectangle {
            id: loadingRec
            anchors.centerIn: parent
            width: 130
            height: width
            color: "transparent"
            border.width: 5
            border.color: Config.themeColor
        }

        BMText {
            id: loadingText
            anchors.centerIn: loadingRec
            text: Config.loadingText
            font.pixelSize: 20
            property int dotCnt: 0
        }
    }

    Rectangle {
        id: closeBtn
        anchors {
            top: loadingBg.bottom
            topMargin: 15
            horizontalCenter: parent.horizontalCenter
        }

        width: 110
        height: 35
        radius: 8
        color: "#ea4132"
        visible: Config.loadingCancelBtn

        BMText {
            anchors.centerIn: parent
            color: Config.light
            font.pixelSize: 16
            text: qsTr("停止")
        }
    }


    Timer {
        id: textTimer
        interval: 700
        repeat: true
        running: true
        onTriggered: {
            if (loadingText.dotCnt === 3) {
                loadingText.text = loadingText.text.slice(0, loadingText.text.length - loadingText.dotCnt)
                loadingText.dotCnt = 0
                return
            }
            loadingText.text += "."
            loadingText.dotCnt++
        }
    }

    RotationAnimation {
        id: rotateAni
        target: loadingRec
        loops: Animation.Infinite
        to: loadingRec.rotation + 360
        duration: 5000
    }


    SequentialAnimation {
        id: borderAni
        loops: Animation.Infinite
        ParallelAnimation {
            NumberAnimation {
                target: loadingRec
                property: "border.width"
                to: 15
                duration: 1000
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: loadingRec
                property: "scale"
                to: 1.1
                duration: 1000
                easing.type: Easing.InOutQuad
            }
        }

        ParallelAnimation {
            NumberAnimation {
                target: loadingRec
                property: "border.width"
                to: 5
                duration: 1000
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: loadingRec
                property: "scale"
                to: 1
                duration: 1000
                easing.type: Easing.InOutQuad
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            let point = mapToItem(closeBtn, mouseX, mouseY)
            if (closeBtn.contains(Qt.point(point.x, point.y))) {
                processUpload.stopHexoS()
                return
            }
        }
    }

    Component.onCompleted: {
        rotateAni.start()
        borderAni.start()
    }
}
