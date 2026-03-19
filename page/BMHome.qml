import QtQuick
import QtCharts
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

    ChartView {
        title: "Line Chart"
        anchors {
            top: carousel.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        antialiasing: true

        LineSeries {
            name: "Line"
            XYPoint { x: 0; y: 0 }
            XYPoint { x: 1.1; y: 2.1 }
            XYPoint { x: 1.9; y: 3.3 }
            XYPoint { x: 2.1; y: 2.1 }
            XYPoint { x: 2.9; y: 4.9 }
            XYPoint { x: 3.4; y: 3.0 }
            XYPoint { x: 4.1; y: 3.3 }
        }
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
