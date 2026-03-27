import QtQuick
import QtQuick.Controls
import "qrc:/config/basic"

BMRectangle {
    id: root
    height: rectSize * 7 + 6 * 3 + 51 + levelItem.height
    property int rectSize: 14

    Item {
        id: borderItem
        anchors.centerIn: parent
        width: parent.width - 10
        height: parent.height - 10

        ListView {
            id: listView
            anchors.fill: parent
            model: dateModel
            clip: true
            orientation: ListView.Horizontal
            spacing: 3
            cacheBuffer: 1000
            delegate: Column {
                id: col
                spacing: 5
                property int idx: index

                Column {
                    Item {
                        width: 10
                        height: 18
                        BMText {
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 16
                            text: year
                        }
                    }

                    Item {
                        width: 10
                        height: 18
                        BMText {
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 16
                            text: monthName
                        }
                    }
                }

                Grid {
                    rows: 7
                    columns: days == 28 ? 4 : 5
                    flow: Grid.TopToBottom
                    spacing: 3

                    Repeater {
                        model: days
                        delegate: Rectangle {
                            width: rectSize
                            height: rectSize
                            radius: 2
                            BMToolTip {
                                id: toolTip
                                text: dateModel.getToolTipText(col.idx, index)
                            }

                            // 根据 level 映射颜色
                            color: Config.isLightMode ? dateModel.getColorLevel(col.idx, index, "light") : dateModel.getColorLevel(col.idx, index, "dark")

                            // 鼠标悬停效果
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: {
                                    parent.border.color = "#000000"
                                    toolTip.visible = true
                                }

                                onExited: {
                                    parent.border.color = "transparent"
                                    toolTip.visible = false
                                }
                            }
                        }
                    }
                }
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: Config.aniDuration
                }
            }
        }
    }

    Item {
        id: levelItem
        width: rectSize * 5 + 48 + 34
        height: rectSize + 5
        anchors {
            bottom: parent.bottom
            right: parent.right
            rightMargin: 5
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 5

            BMText {
                font.pixelSize: 14
                text: qsTr("less")
            }

            Repeater {
                model: 5
                delegate: Rectangle {
                    width: rectSize
                    height: rectSize
                    radius: 2

                    // 根据 level 映射颜色
                    color: {
                        switch(index) {
                            case 0: return Config.isLightMode ? "#ebedf0" : "#2D3743"
                            case 1: return "#9be9a8"
                            case 2: return "#40c463"
                            case 3: return "#30a14e"
                            case 4: return "#216e39"
                        }
                    }
                }
            }

            BMText {
                font.pixelSize: 14
                text: qsTr("more")
            }
        }
    }
}
