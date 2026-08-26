import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.config

Scope {
    id: root

    // Konwersja ścieżki na format URL (file://) na wypadek braku przedrostka
    readonly property string wallpaperPath: {
        let path = Config.modules.wallpaper.path;
        return (path.startsWith("/") ? "file://" + path : path);
    }
    readonly property string wallpaperMode: Config.modules.wallpaper.mode

    Variants {
        model: Quickshell.screens

        delegate: PanelWindow {
            required property var modelData
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

            Image {
                id: wallpaperImage
                anchors.fill: parent
                source: root.wallpaperPath

                sourceSize.width: width
                sourceSize.height: height

                fillMode: root.wallpaperMode === "cover" ? Image.PreserveAspectCrop :
                          root.wallpaperMode === "fill"  ? Image.Stretch :
                          root.wallpaperMode === "fit"   ? Image.PreserveAspectFit :
                          Image.Tile

                asynchronous: true
                mipmap: true
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