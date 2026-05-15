import QtQuick
import QtQuick.Controls

ScrollBar {
    id: root
    policy: ScrollBar.AsNeeded
    width: 7
    contentItem: Rectangle {
        implicitWidth: 10
        radius: 4
        color: "#ccc"
    }
}
