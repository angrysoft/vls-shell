pragma Singleton
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property alias modules: adapter.modules

    FileView {
        id: file
        path: `${Quickshell.env("HOME")}/.config/vls-shell/config.json`
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()
        
        JsonAdapter {
            id: adapter
            property JsonObject modules: JsonObject {
                property BarConfig bar: BarConfig {}
                property WallpaperConfig wallpaper: WallpaperConfig {}
            }
        }
    }
}
