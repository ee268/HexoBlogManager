import QtQuick
import QtQuick.Controls
import "qrc:/config/basic"

BMRectangle {
    id: root
    height: rectSize * 7 + 6 * 3 + 51 + levelItem.height
    property int rectSize: 14
    property int cellSpacing: 3

    BMToolTip {
        id: hoverTip
        visible: false
        z: 9999
    }

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
            spacing: cellSpacing
            cacheBuffer: 1000
            reuseItems: true
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

                Item {
                    id: gridItem
                    property int columns: days == 28 ? 4 : 5
                    width: columns * rectSize + (columns - 1) * cellSpacing
                    height: 7 * rectSize + 6 * cellSpacing

                    Canvas {
                        id: gridCanvas
                        anchors.fill: parent
                        renderTarget: Canvas.Image
                        renderStrategy: Canvas.Threaded
                        antialiasing: true
                        
                        function roundRect(ctx, x, y, w, h, r) {
                            ctx.beginPath()
                            ctx.moveTo(x + r, y)
                            ctx.lineTo(x + w - r, y)
                            ctx.quadraticCurveTo(x + w, y, x + w, y + r)
                            ctx.lineTo(x + w, y + h - r)
                            ctx.quadraticCurveTo(x + w, y + h, x + w - r, y + h)
                            ctx.lineTo(x + r, y + h)
                            ctx.quadraticCurveTo(x, y + h, x, y + h - r)
                            ctx.lineTo(x, y + r)
                            ctx.quadraticCurveTo(x, y, x + r, y)
                            ctx.closePath()
                        }
                        
                        onPaint: {
                            var ctx = getContext("2d")
                            ctx.reset()
                            ctx.clearRect(0, 0, width, height)

                            for (var i = 0; i < days; i++) {
                                var week = Math.floor(i / 7)
                                var row = i % 7
                                var x = week * (rectSize + cellSpacing)
                                var y = row * (rectSize + cellSpacing)
                                ctx.fillStyle = Config.isLightMode
                                    ? dateModel.getColorLevel(col.idx, i, "light")
                                    : dateModel.getColorLevel(col.idx, i, "dark")
                                roundRect(ctx, x, y, rectSize, rectSize, 2)
                                ctx.fill()
                            }
                        }
                    }

                    Rectangle {
                        id: hoverRect
                        width: rectSize
                        height: rectSize
                        radius: 2
                        color: "transparent"
                        border.color: "#000000"
                        visible: false
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        function indexFromPosition(x, y) {
                            var colIndex = Math.floor(x / (rectSize + cellSpacing))
                            var rowIndex = Math.floor(y / (rectSize + cellSpacing))
                            if (colIndex < 0 || rowIndex < 0) {
                                return -1
                            }
                            if (colIndex >= gridItem.columns || rowIndex >= 7) {
                                return -1
                            }
                            var dayIndex = colIndex * 7 + rowIndex
                            return dayIndex < days ? dayIndex : -1
                        }

                        function updateTip(x, y, dayIndex) {
                            hoverRect.x = x
                            hoverRect.y = y
                            hoverRect.visible = true

                            var p = gridItem.mapToItem(root, x, y)
                            hoverTip.x = p.x + rectSize + 4
                            hoverTip.y = p.y - hoverTip.height - 4
                            hoverTip.text = dateModel.getToolTipText(col.idx, dayIndex)
                            hoverTip.visible = true
                        }

                        onPositionChanged: function(mouseEvent) {
                            var dayIndex = indexFromPosition(mouseEvent.x, mouseEvent.y)
                            if (dayIndex >= 0) {
                                var colIndex = Math.floor(dayIndex / 7)
                                var rowIndex = dayIndex % 7
                                var x = colIndex * (rectSize + cellSpacing)
                                var y = rowIndex * (rectSize + cellSpacing)
                                updateTip(x, y, dayIndex)
                            } else {
                                hoverRect.visible = false
                                hoverTip.visible = false
                            }
                        }

                        onExited: {
                            hoverRect.visible = false
                            hoverTip.visible = false
                        }
                    }

                    Component.onCompleted: gridCanvas.requestPaint()
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
