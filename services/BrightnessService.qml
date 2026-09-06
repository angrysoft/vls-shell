pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string device: ""
    property int current: 0
    property int max: 1
    readonly property real percent: max > 0 ? current / max : 0
    readonly property bool isEnabled: device.length > 0

    Process {
        id: detectDevice
        command: ["sh", "-c", "ls /sys/class/backlight/ 2>/dev/null | head -n1"]
        stdout: StdioCollector {
            onStreamFinished: {
                const name = text.trim()
                if (name.length > 0) {
                    root.device = name
                } else {
                    console.warn("BrightnessService: no backlight device found")
                }
            }
        }
    }

    Component.onCompleted: {
        detectDevice.running = true
    }

    FileView {
        path: root.device ? `/sys/class/backlight/${root.device}/brightness` : ""
        watchChanges: true
        onFileChanged: reload()
        onLoaded: root.current = parseInt(text())
    }

    FileView {
        path: root.device ? `/sys/class/backlight/${root.device}/max_brightness` : ""
        onLoaded: root.max = parseInt(text())
    }

    function getIconName() {
        if (percent >= 0.75) return "display-brightness-high-symbolic"
        if (percent >= 0.5) return "display-brightness-medium-symbolic"
        if (percent > 0) return "display-brightness-low-symbolic"
        return "display-brightness-off-symbolic"
    }

    IpcHandler {
        id: ipc
        target: "brightness"
        
    }
}