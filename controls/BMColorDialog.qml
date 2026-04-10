import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import "qrc:/config/basic"

Popup {
    id: root
    width: 540
    height: 360
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape
    padding: 0
    margins: 0
    leftInset: 0
    rightInset: 0
    topInset: 0
    bottomInset: 0

    property color selectedColor: Config.themeColor
    property int alphaValue: 255
    property real hueValue: 0.0
    property real valueValue: 1.0
    signal saved(color colorValue)

    BMMessageBox {
        id: msgBox
        // parent: root
    }

    function toHexByte(value) {
        let v = Math.max(0, Math.min(255, Math.round(value)))
        let hex = v.toString(16).toUpperCase()
        return (hex.length === 1 ? "0" + hex : hex)
    }

    function colorToHex(c) {
        return "#" + toHexByte(c.r * 255) + toHexByte(c.g * 255) + toHexByte(c.b * 255)
    }

    function colorToHexAARRGGBB(c, alpha) {
        return "#" + toHexByte(alpha) + toHexByte(c.r * 255) + toHexByte(c.g * 255) + toHexByte(c.b * 255)
    }

    function applyAlpha(c, alpha) {
        return Qt.rgba(c.r, c.g, c.b, Math.max(0, Math.min(255, alpha)) / 255.0)
    }

    function setColor(c) {
        selectedColor = applyAlpha(c, alphaValue)
    }

    function setHsvaColor(h, s, v) {
        hueValue = Math.max(0, Math.min(1, h))
        valueValue = Math.max(0, Math.min(1, v))
        setColor(Qt.hsva(hueValue, s, valueValue, 1.0))
    }

    function centerInParent() {
        if (!parent) return
        x = Math.max(0, Math.round((parent.width - width) / 2))
        y = Math.max(0, Math.round((parent.height - height) / 2))
    }

    onOpened: {
        alphaValue = Math.round(selectedColor.a * 255)
        centerInParent()
    }

    onWidthChanged: centerInParent()
    onHeightChanged: centerInParent()
    onParentChanged: centerInParent()

    onAlphaValueChanged: {
        if (!alphaField.activeFocus) {
            alphaField.text = alphaValue.toString()
        }
    }

    onSelectedColorChanged: {
        if (!hexField.activeFocus) {
            hexField.text = colorToHex(selectedColor)
        }
    }

    background: BMRectangle {
        id: bg
        layer.enabled: true
        layer.effect: OpacityMask {
            source: bg
            maskSource: Rectangle {
                width: bg.width
                height: bg.height
                radius: bg.radius
            }
        }
        Item {
            height: 32
            width: parent.width

            BMText {
                text: qsTr("颜色选择")
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 16
            }

            BMTitleButton {
                id: closeButton
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                height: parent.height
                width: height * 1.5
                source: "qrc:/res/title_bar/close.svg"
                background: Rectangle {
                    color: {
                        if (!closeButton.enabled) {
                            return "gray"
                        }
                        if (closeButton.pressed || closeButton.hovered) {
                            return "#e81123"
                        }
                        return "transparent"
                    }
                }
                onClicked: root.close()
            }
        }
    }

    contentItem: Item {
        id: contentItem
        anchors.fill: parent

        Column {
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                top: parent.top
                topMargin: 32 + spacing
            }

            width: parent.width
            spacing: 12

            Row {
                spacing: 12
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - 28
                height: 200

                Column {
                    id: swatchCol
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 10
                    width: 90

                    Repeater {
                        model: [
                            "#4682b4", "#FFA94D", "#FFD43B",
                            "#69DB7C", "#EE00B6"
                        ]

                        delegate: Rectangle {
                            width: swatchCol.width
                            height: 26
                            radius: 6
                            color: modelData
                            border.width: colorToHex(selectedColor) === colorToHex(Qt.color(modelData)) ? 2 : 1
                            border.color: Config.isLightMode ? "#333333" : "#dddddd"

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    setColor(Qt.color(modelData))
                                }
                            }
                        }
                    }
                }

                Column {
                    id: paletteCol
                    width: parent.width - swatchCol.width - 12
                    height: parent.height
                    spacing: 8

                    Item {
                        id: paletteWrap
                        width: parent.width
                        height: parent.height - 18

                        Rectangle {
                            id: paletteBase
                            anchors.fill: parent
                            radius: 8
                            gradient: Gradient {
                                orientation: Gradient.Horizontal
                                GradientStop { position: 0.0; color: "#FF0000" }
                                GradientStop { position: 0.17; color: "#FFFF00" }
                                GradientStop { position: 0.33; color: "#00FF00" }
                                GradientStop { position: 0.50; color: "#00FFFF" }
                                GradientStop { position: 0.67; color: "#0000FF" }
                                GradientStop { position: 0.83; color: "#FF00FF" }
                                GradientStop { position: 1.0; color: "#FF0000" }
                            }
                        }

                        Rectangle {
                            anchors.fill: paletteBase
                            radius: paletteBase.radius
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: "#00FFFFFF" }
                                GradientStop { position: 1.0; color: "#FF000000" }
                            }
                        }

                        Rectangle {
                            id: cursor
                            width: 10
                            height: 10
                            radius: width / 2
                            color: "transparent"
                            border.width: 2
                            border.color: "#FFFFFF"
                            x: Math.max(0, Math.min(paletteWrap.width - width, paletteWrap.width * hueValue - width / 2))
                            y: Math.max(0, Math.min(paletteWrap.height - height, paletteWrap.height * (1.0 - valueValue) - height / 2))
                        }

                        MouseArea {
                            anchors.fill: paletteWrap
                            onPressed: handlePick(mouseX, mouseY)
                            onPositionChanged: handlePick(mouseX, mouseY)

                            function handlePick(px, py) {
                                let xRatio = Math.max(0, Math.min(1, px / paletteWrap.width))
                                let yRatio = Math.max(0, Math.min(1, py / paletteWrap.height))
                                setHsvaColor(xRatio, 1.0, 1.0 - yRatio)
                            }
                        }
                    }

                    Slider {
                        id: valueSlider
                        width: parent.width
                        height: 10
                        from: 0
                        to: 1
                        value: valueValue
                        padding: 0

                        background: Rectangle {
                            radius: 4
                            gradient: Gradient {
                                orientation: Gradient.Horizontal
                                GradientStop { position: 0.0; color: "#000000" }
                                GradientStop { position: 1.0; color: Qt.hsva(hueValue, 1.0, 1.0, 1.0) }
                            }
                        }

                        handle: Rectangle {
                            width: 8
                            height: 14
                            radius: 3
                            color: "white"
                            border.color: "#333333"
                            x: valueSlider.leftPadding + valueSlider.visualPosition * (valueSlider.availableWidth - width)
                            y: valueSlider.topPadding + valueSlider.availableHeight / 2 - height / 2
                        }

                        onValueChanged: {
                            if (pressed) {
                                setHsvaColor(hueValue, 1.0, value)
                            }
                        }
                    }
                }
            }

            Item {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - 28
                height: 36

                Row {
                    id: hexColorEdit
                    spacing: 8
                    height: parent.height

                    BMText {
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("十六进制")
                        font.pixelSize: 14
                    }

                    TextField {
                        id: hexField
                        anchors.verticalCenter: parent.verticalCenter
                        width: 260
                        height: parent.height
                        readOnly: false
                        text: colorToHex(selectedColor)
                        validator: RegularExpressionValidator {
                            regularExpression: /^(#)?([0-9A-Fa-f]{6})$/
                        }
                        font.pixelSize: 14
                        color: acceptableInput ? (Config.isLightMode ? "#1a1a1a" : "#f2f2f2") : "#e81123"
                        background: Rectangle {
                            radius: 6
                            color: Config.isLightMode ? "#f4f4f4" : "#2b2b2b"
                            border.color: Config.isLightMode ? "#d0d0d0" : "#444444"
                            border.width: 1
                        }
                        onEditingFinished: {
                            if (!acceptableInput) {
                                hexField.text = colorToHex(selectedColor)
                                return
                            }
                            let normalized = text
                            if (normalized.length === 6) {
                                normalized = "#" + normalized
                            }
                            setColor(Qt.color(normalized))
                        }
                    }
                }

                Row {
                    id: alphaEdit
                    anchors {
                        right: parent.right
                    }

                    spacing: 8
                    height: parent.height

                    BMText {
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("Alpha")
                        font.pixelSize: 14
                    }

                    TextField {
                        id: alphaField
                        anchors.verticalCenter: parent.verticalCenter
                        width: 90
                        height: parent.height
                        text: alphaValue.toString()
                        inputMethodHints: Qt.ImhDigitsOnly
                        maximumLength: 3
                        validator: IntValidator { bottom: 0; top: 255 }
                        font.pixelSize: 14
                        color: Config.isLightMode ? "#1a1a1a" : "#f2f2f2"
                        background: Rectangle {
                            radius: 6
                            color: Config.isLightMode ? "#f4f4f4" : "#2b2b2b"
                            border.color: Config.isLightMode ? "#d0d0d0" : "#444444"
                            border.width: 1
                        }
                        onEditingFinished: {
                            let parsed = parseInt(text)
                            if (isNaN(parsed)) {
                                parsed = 255
                            }
                            alphaValue = Math.max(0, Math.min(255, parsed))
                            selectedColor = applyAlpha(selectedColor, alphaValue)
                        }
                            onTextEdited: {
                                let filtered = text.replace(/\D+/g, "")
                                if (filtered.length === 0) {
                                    text = ""
                                    return
                                }
                                let value = Math.min(255, parseInt(filtered))
                                let nextText = value.toString()
                                if (nextText !== text) {
                                    text = nextText
                                }
                            }
                    }
                }
            }

            Item {
                width: parent.width
                height: 40

                Button {
                    id: saveBtn
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 120
                    height: parent.height
                    text: qsTr("保存")
                    onClicked: {
                        if (!hexField.acceptableInput) {
                            msgBox.setMsgBox(true, "Error", "颜色代码不符合规范")
                            console.log("ahaaaa")
                            return
                        }
                        Config.themeColor = selectedColor
                        saved(selectedColor)
                        globalMgr.sigRefreshMenuColor()
                        globalMgr.setValue("themeColor", colorToHexAARRGGBB(Config.themeColor, alphaValue))
                        root.close()
                    }

                    background: Rectangle {
                        radius: 8
                        color: saveBtn.pressed ? "#1f6feb" : Qt.rgba(selectedColor.r, selectedColor.g, selectedColor.b, 1.0)
                        border.width: 1
                        border.color: "#1a1a1a"
                    }

                    contentItem: BMText {
                        text: saveBtn.text
                        color: "white"
                        font.pixelSize: 18
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }
    }
}


