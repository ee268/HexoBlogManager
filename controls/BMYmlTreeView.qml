import QtQuick
import QtQuick.Controls
import Qt.labs.platform
import "qrc:/config/basic"

BMRectangle {
    id: root
    property alias model: treeView.model

    Connections {
        target: ymlThemeModel
        function onSigInitFinished() {
            model = ymlThemeModel
        }
    }

    FileDialog {
        id: folderDlg
        acceptLabel: qsTr("导入")
        rejectLabel: qsTr("取消")
        fileMode: FileDialog.OpenFile
        nameFilters: ["Yaml files (*.yml *yaml)"]

        onAccepted: {
            console.log(currentFile)
            processImport.setThemeConfigYml(currentFile)
        }
    }

    Item {
        id: paddingItem
        anchors.centerIn: parent
        width: parent.width - 10
        height: parent.height - 10

        Column {
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: 50
            }

            spacing: 15
            visible: model ? false : true
            BMText {
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#ccc"
                opacity: 0.8
                font.pixelSize: 23
                text: qsTr("暂无主题配置")
            }
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                color: Config.themeColor
                width: 100
                height: 35
                radius: 6

                BMText {
                    anchors.centerIn: parent
                    color: Config.light
                    font.pixelSize: 20
                    text: qsTr("导入")
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        parent.opacity = 0.5
                    }
                    onReleased: {
                        parent.opacity = 1
                        folderDlg.open()
                    }
                }
            }
        }

        TreeView {
            id: treeView
            anchors.fill: parent
            flickableDirection: Flickable.VerticalFlick
            interactive: true
            clip: true
            visible: model ? true : false

            selectionModel: ItemSelectionModel {}

            columnWidthProvider: function(column) {
                return paddingItem.width / 2
            }

            delegate: Item {
                implicitWidth: padding + bmTxt.x + bmTxt.implicitWidth + padding
                implicitHeight: 45

                readonly property real indentation: 30
                readonly property real padding: 5

                required property TreeView treeView
                required property bool isTreeNode
                required property bool expanded
                required property bool hasChildren
                required property int depth
                required property int row
                required property int column
                required property bool current

                property Animation indicatorAnimation: NumberAnimation {
                    target: indicator
                    property: "rotation"
                    from: expanded ? -90 : 0
                    to: expanded ? 0 : -90
                    duration: 100
                    easing.type: Easing.OutQuart
                }
                TableView.onPooled: indicatorAnimation.complete()
                TableView.onReused: if (current) indicatorAnimation.start()
                onExpandedChanged: indicator.rotation = expanded ? 0 : -90

                ColorImage {
                    id: indicator
                    x: padding + (depth * indentation)
                    anchors.verticalCenter: parent.verticalCenter
                    visible: isTreeNode && hasChildren

                    width: parent.height / 2
                    height: parent.height / 2
                    rotation: -90

                    source: "qrc:/res/treeview/arrow.svg"
                    color: Config.themeColor

                    TapHandler {
                        onSingleTapped: {
                            let index = treeView.index(row, column)
                            treeView.selectionModel.setCurrentIndex(index, ItemSelectionModel.NoUpdate)
                            treeView.toggleExpanded(row)
                        }
                    }
                }

                BMText {
                    id: bmTxt
                    x: padding + (isTreeNode ? (depth + 1) * indentation : 0)
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width - padding - x
                    font.pixelSize: 17
                    clip: true
                    text: column == 1 ? "" : model.display
                }

                Rectangle {
                    anchors.centerIn: parent
                    width: bmTxt.width
                    height: 35
                    color: "transparent"
                    border.color: (row == treeView.currentRow || textInput.focus) ? Config.themeColor :
                                (Config.isLightMode ? Config.dark : Config.light)
                    border.width: 1
                    radius: 10
                    visible: column == 1 ? (hasChildren ? false : true) : false
                    clip: true

                    TextInput {
                        id: textInput
                        anchors.centerIn: parent
                        width: parent.width - 10
                        height: parent.height - 10
                        focus: row == treeView.currentRow
                        text: model.display
                        color: Config.isLightMode ? Config.dark : Config.light
                        verticalAlignment: Text.AlignVCenter
                        onFocusChanged: {
                            if (focus) {
                                let index = treeView.index(row, column)
                                treeView.selectionModel.setCurrentIndex(index, ItemSelectionModel.NoUpdate)
                            }
                        }
                    }
                }
            }
        }
    }
}
