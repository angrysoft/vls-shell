// shell/Wallpaper.qml
import Quickshell
import Quickshell.Wayland
import QtQuick
import qs.config

PanelWindow {
    property string wallpaperPath: Config.modules.wallpaper.path
    property string wallpaperMode: Config.modules.wallpaper.mode
    WlrLayershell.layer: WlrLayer.Background
    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    WlrLayershell.namespace: "wallpaper"

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    color: "transparent"

    Image {
        anchors.fill: parent
        source: wallpaperPath
        fillMode: wallpaperMode === "cover" ? Image.PreserveAspectCrop :
                  wallpaperMode === "fill" ? Image.Stretch :
                  wallpaperMode === "fit" ? Image.PreserveAspectFit :
                  Image.Tile
        cache: false
    }
}