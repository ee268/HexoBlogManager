import QtQuick
import "qrc:/config/basic"
import "qrc:/qml/controls"

BMRectangle {
    anchors.fill: parent
    color: "green"

    BMText {
        anchors.centerIn: parent
        text: "todo..."
        font.pixelSize: 25
    }
}
