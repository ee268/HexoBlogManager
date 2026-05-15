import QtQuick
import QtQuick.Controls
import BlogManager
import "qrc:/config/basic"

BMRectangle {
    id: root

    property alias text: textArea.text
    property alias readOnly: textArea.readOnly
    property var textChangedEvent: () => {}

    BMText {
        anchors.centerIn: parent
        font.pixelSize: 23
        color: "#ccc"
        opacity: 0.8
        text: qsTr("暂未导入配置(请前往设置或导入页面)")
        visible: !textArea.text
    }

    ScrollView {
        id: scrollView
        anchors.fill: parent
        anchors.margins: 5
        visible: !!textArea.text

        ScrollBar.vertical: BMVScrollBar{
            height: scrollView.height
            anchors.right: scrollView.right
        }

        TextArea {
            id: textArea
            background: Item {}
            wrapMode: TextArea.Wrap
            selectByMouse: true
            color: Config.isLightMode ? Config.dark : Config.light
            font.family: "Monospace"
            font.pixelSize: 15
            tabStopDistance: font.pixelSize * 2

            onTextChanged: {
                textChangedEvent()
            }
        }
    }

    YmlHighlighter {
        id: ymlHighlighter
        textDocument: textArea.textDocument
        isLightMode: Config.isLightMode
    }
}
