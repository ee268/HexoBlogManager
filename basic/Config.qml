pragma Singleton
import QtQuick

QtObject {
   id: config
   property bool isLightMode: true
   property int aniDuration: 500
   property int titleBarHeight: 32
   property int windowDistance: 8
   property color themeColor: "#4682b4"
   property string font: "qrc:/res/font/dingliezhuhaifont-20240831GengXinBan)-2.ttf"
   property int curMenu: 0
   property bool isTopMenu: true
   property bool showMsgBox: false
   property string msgBoxType: "Info"
   property string msgBoxContent: "content"
   property bool isLoading: false
   property string loadingText: "加载中"
   property bool loadingCancelBtn: false

   function setMsgBox(isShow, type, content) {
      showMsgBox = isShow
      msgBoxType = type
      msgBoxContent = content
   }

   readonly property color light: "#fdfbfb"
   readonly property color dark: "#2b2b2b"
}
