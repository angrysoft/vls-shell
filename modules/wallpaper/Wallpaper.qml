import Quickshell
import Quickshell.Wayland
import QtQuick
import qs.config

Scope {
    id:root
    property string wallpaperPath: Config.modules.wallpaper.path
    property string wallpaperMode: Config.modules.wallpaper.mode

    Variants {
        id: wallpaperVariants
        model: Quickshell.screens


        delegate: Component {
            PanelWindow {
                id: wallpaperWindow
                screen: modelData

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
                exclusionMode: ExclusionMode.Ignore

                Image {
                    id: wallpaperImage
                    anchors.fill: parent
                    source: root.wallpaperPath
                    
                    sourceSize.width: root.wallpaperMode === "tile" ? 0 : root.width
                    sourceSize.height: root.wallpaperMode === "tile" ? 0 : root.height

                    fillMode: root.wallpaperMode === "cover" ? Image.PreserveAspectCrop :
                            root.wallpaperMode === "fill" ? Image.Stretch :
                            root.wallpaperMode === "fit" ? Image.PreserveAspectFit :
                            Image.Tile

                    asynchronous: true

                    mipmap: true

                    // cache: false
                    smooth: true
                    NumberAnimation on opacity {
                        from: 0
                        to: 1
                        duration: 400
                    }
                }
            }
        }
    }
}