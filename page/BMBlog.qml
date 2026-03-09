import QtQuick
import QtQuick.Shapes
import "qrc:/config/basic"
import "qrc:/qml/controls"

BMRectangle {
    anchors.fill: parent
    color: "orange"

    BMText {
        anchors.centerIn: parent
        text: "todo..."
        font.pixelSize: 25
    }
}
