import Quickshell
import QtQuick
import qs.theme

Text {
    id: label
    property alias text: label.text
    property alias color: label.color
    property alias bold: label.font.bold
    property alias maximumLineCount: label.maximumLineCount
    property int maxWidth: implicitWidth + 1
    // property int implicitHeight: label.implicitHeight
    // anchors.verticalCenter: parent.verticalCenter
    color: Theme.colors.on_surface
    font.family: Theme.style.fontFamily
    font.pixelSize: Theme.style.fontSize
    elide: Text.ElideRight
    width: maxWidth
}