import Quickshell
import QtQuick
import qs.theme

Text {
    id: label
    color: Theme.colors.on_surface
    font.family: Theme.style.fontFamily
    font.pixelSize: Theme.style.fontSize
    elide: Text.ElideRight
    wrapMode: Text.WordWrap
}