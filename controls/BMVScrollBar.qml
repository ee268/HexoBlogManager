import QtQuick
import QtQuick.Controls

ScrollBar {
    anchors.right: parent.right
    width: 7
    contentItem: Rectangle {
        implicitWidth: 10
        radius: 4
        color: "#ccc"
    }
}
