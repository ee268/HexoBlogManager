import QtQuick
import QtQuick.Controls
 import Qt.labs.platform
import "qrc:/config/basic"
import "qrc:/qml/controls"
import Qt5Compat.GraphicalEffects

Item {
    anchors.fill: parent

    FolderDialog {
        id: folderDlg
        acceptLabel: qsTr("导入")
        rejectLabel: qsTr("取消")

        onAccepted: {
            console.log(currentFolder.toString().slice(8))
        }
    }

    BMRectangle {
        id: importRect
        anchors {
            left: parent.left
            // top: parent.top
            right: parent.right
        }

        height: parent.height * 0.4

        Column {
            anchors.centerIn: parent
            spacing: 20

            Item {
                width: 100
                height: 100
                anchors.horizontalCenter: parent.horizontalCenter
                opacity: 0.5

                Image {
                    id: image
                    anchors.centerIn: parent
                    source: "qrc:/res/import/importBox.svg"
                    fillMode: Image.PreserveAspectFit
                    width: parent.width
                    height: parent.height
                    visible: false
                }
                ColorOverlay {
                    anchors.fill: image
                    source: image
                    color: Config.themeColor
                }
            }

            BMText {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("点击上传或拖拽到此（单个文件夹）")
                color: "#bfbfbf"
                font.pixelSize: 20
            }
        }

        Canvas {
            id: dashedRoundedRect
            width: parent.width - 10
            height: parent.height - 10
            anchors.centerIn: parent
            opacity: 0.5

            // 基础配置（用偶数，减少像素偏差）
            property int borderRadius: 8        // 圆角半径（偶数）
            property color borderColor: "#a9a9a9"
            property int borderWidth: 2          // 边框宽度（偶数）
            property int dashRatio: 2            // 虚实比例（整数）
            property int baseDashTotal: 10       // 基准总步长（整数）

            // 内部计算（强制整数，消除小数偏差）
            property int rectX: Math.round(borderWidth / 2)
            property int rectY: Math.round(borderWidth / 2)
            property int rectW: Math.round(width - borderWidth)
            property int rectH: Math.round(height - borderWidth)
            property int rectR: Math.max(1, Math.min(borderRadius, rectW/2, rectH/2))

            // 计算整数周长（减少浮点误差）
            property real perimeter: 2 * (rectW - 2*rectR + rectH - 2*rectR) + 2 * Math.PI * rectR
            property int intPerimeter: Math.round(perimeter)

            // 强制整数步长（核心修复）
            property var dashPattern: {
                // 1. 计算能整除整数周长的总步长（强制整数）
                var totalStep = intPerimeter / Math.round(intPerimeter / baseDashTotal);
                totalStep = Math.round(totalStep); // 转为整数
                totalStep = Math.max(totalStep, dashRatio + 1); // 避免步长过小

                // 2. 按比例分配整数步长
                var dash = Math.round(totalStep * dashRatio / (dashRatio + 1));
                var gap = totalStep - dash; // 保证总步长精准

                // 3. 边界保护（至少1px）
                dash = Math.max(dash, 1);
                gap = Math.max(gap, 1);
                return [dash, gap];
            }

            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);

                // 关闭抗锯齿（可选，进一步提升清晰度）
                ctx.imageSmoothingEnabled = false;

                if (rectW <= 0 || rectH <= 0) {
                    return;
                }

                // 绘制圆角矩形路径（整数坐标）
                ctx.beginPath();
                ctx.moveTo(rectX + rectR, rectY);
                ctx.lineTo(rectX + rectW - rectR, rectY);
                ctx.arcTo(rectX + rectW, rectY, rectX + rectW, rectY + rectR, rectR);
                ctx.lineTo(rectX + rectW, rectY + rectH - rectR);
                ctx.arcTo(rectX + rectW, rectY + rectH, rectX + rectW - rectR, rectY + rectH, rectR);
                ctx.lineTo(rectX + rectR, rectY + rectH);
                ctx.arcTo(rectX, rectY + rectH, rectX, rectY + rectH - rectR, rectR);
                ctx.lineTo(rectX, rectY + rectR);
                ctx.arcTo(rectX, rectY, rectX + rectR, rectY, rectR);
                ctx.closePath();

                // 绘制虚线（整数步长+像素对齐）
                ctx.setLineDash(dashPattern);
                ctx.lineWidth = borderWidth;
                ctx.strokeStyle = borderColor;
                ctx.stroke();
            }

            // 尺寸变化时刷新
            onWidthChanged: requestPaint()
            onHeightChanged: requestPaint()
            onBorderColorChanged: requestPaint()
        }

        DropArea {
            anchors.fill: parent

            onDropped: (drop) => {
                if(drop.hasUrls){
                    if (drop.urls.length > 1) {
                        console.log("too many directory path, only need single directory")
                        return
                    }

                    let dicPath = drop.urls[0].toString().slice(8)
                    let isSuccess = processUpload.setFolderPath(dicPath)
                    if (!isSuccess) {
                        console.log("SetFolderPath failed,", dicPath)
                    }

                    let loadPath = processUpload.getFolderPath() + "\n"
                    loadPath += processUpload.getConfigYml() + "\n"
                    loadPath += processUpload.getThemeConfigYml() + "\n"
                    console.log("loadPath:", loadPath)
                    Config.showMsgBox = true
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                folderDlg.open()
            }
        }
    }

    BMRectangle {
        id: historyRect
        anchors {
            top: importRect.bottom
            topMargin: Config.windowDistance
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        BMText {
            id: title
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: 7
            }

            text: qsTr("历史")
            font.pixelSize: 24
        }

        Item {
            id: innerItem
            width: parent.width - 14
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: title.bottom
                topMargin: 7
                bottom: parent.bottom
                bottomMargin: 7
            }

            // clip: true

            ListView {
                id: listView
                anchors.fill: parent
                spacing: 7
                model: 10
                clip: true
                property bool hovered: false

                ScrollBar.vertical: ScrollBar {
                    anchors.right: parent.right
                    width: 7
                    contentItem: Rectangle {
                        visible: listView.hovered
                        implicitWidth: 10
                        radius: 4
                        color: Config.isLightMode ? Config.dark : Config.light
                    }
                }

                delegate: Rectangle {
                    id: rec
                    radius: 6
                    width: innerItem.width
                    height: 100
                    color: Config.isLightMode ? "#dbdbdb" : "#404040"

                    Row {
                        spacing: 30
                        anchors {
                            left: parent.left
                            leftMargin: 7
                            verticalCenter: parent.verticalCenter
                        }

                        Rectangle {
                            id: imgRec
                            width: 180
                            height: rec.height - 14
                            radius: rec.radius
                            layer.enabled: true
                            layer.effect: OpacityMask {
                                source: imgRec
                                maskSource: Rectangle {
                                    width: imgRec.width
                                    height: imgRec.height
                                    radius: imgRec.radius
                                }
                            }

                            Image {
                                source: "qrc:/res/cover/default.jpg"
                                width: parent.width
                                height: parent.height
                                fillMode: Image.PreserveAspectCrop
                            }
                        }

                        Column {
                            spacing: 10
                            anchors.verticalCenter: parent.verticalCenter

                            BMText {
                                text: "folderName"
                                font.pixelSize: 18
                            }

                            BMText {
                                text: "folderPath"
                                font.pixelSize: 16
                                opacity: 0.5
                            }
                        }
                    }

                    BMText {
                        anchors {
                            verticalCenter: parent.verticalCenter
                            right: parent.right
                            rightMargin: 7
                        }

                        text: "importDate"
                        font.pixelSize: 18
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: {
                        listView.hovered = true
                    }

                    onExited: {
                        listView.hovered = false
                    }
                }
            }
        }
    }
}
