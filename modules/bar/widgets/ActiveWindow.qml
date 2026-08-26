import Quickshell
import Quickshell.Widgets
import Quickshell.I3
import Quickshell.Io
import QtQuick

import qs.theme
import qs.config
import qs.components




Row {
    spacing: Theme.style.spacing
    anchors.verticalCenter: parent.verticalCenter

    property string focusedWindow: ""
    property string focusedAppId: ""

     I3IpcListener {
        subscriptions: ["window", "workspace"]

        onIpcEvent: function (event) {
            const data = JSON.parse(event.data)
            if (event.type === "window") {
                if (data.change === "close") {
                    hideStatus()
                } else if (data.change === "focus") {
                    visible = data.container.visible ?? false
                    focusedWindow = data.container.name ?? ""
                    focusedAppId = (data.container.app_id ?? "").toLowerCase()
                }
            } else if (event.type === "workspace" && data.change === "focus" && data.current.nodes.length === 0) {
                hideStatus()
            }
        }
    }

    function hideStatus() {
        visible = false
        focusedWindow = ""
        focusedAppId = ""
    }

    function findFocused(node) {
        if (node.focused) return node
        for (var i = 0; i < (node.nodes?.length ?? 0); i++) {
            var result = findFocused(node.nodes[i])
            if (result) return result
        }
        for (var j = 0; j < (node.floating_nodes?.length ?? 0); j++) {
            var result = findFocused(node.floating_nodes[j])
            if (result) return result  // strip sway's instance numbers, e.g. "Alacritty__instance_1"
        }
        return null
    }

    function resolveIcon(appId) {
        if (!appId) return "application-x-executable"
        // console.log("Resolving icon for appId:", appId)
        var map = {
            "code":               "vscode",
            "org.gnome.boxes":    "gnome-boxes",
            "alacritty":          "Alacritty",
            "org.gnome.nautilus": "org.gnome.Nautilus",
            "org.gnome.terminal": "org.gnome.Terminal",
            "jetbrains-idea":     "idea",
            "jetbrains-goland":   "goland",
        }
        return map[appId] || appId
    }

    
    // Initially fetch the focused window and appId from sway
    // This is necessary because the I3IpcListener only receives events after it has been created, so we need to fetch the current state of the tree to get the initial focused window and appId. 
    Process {
        id: treeProc
        command: ["swaymsg", "-t", "get_tree"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var tree = JSON.parse(text)
                    var focused = findFocused(tree)
                    if (focused) {
                        visible = focused.visible ??  false 
                        focusedWindow = focused.name ?? ""
                        focusedAppId = (focused.app_id ?? focused.window_properties?.class ?? "").toLowerCase()
                    }
                } catch(e) {}
            }
        }
    }
    
    IconImage {
        implicitSize: Theme.style.barHeight - Theme.style.padding * 2
        source: Quickshell.iconPath("view-close", "gtk-close")
        smooth: true
        anchors.verticalCenter: parent.verticalCenter

        HoverHandler {
            id: hover
            cursorShape: Qt.PointingHandCursor
        }

        TapHandler {
            acceptedButtons: Qt.LeftButton
            onTapped: (eventPoint, button) => {
                if (button === Qt.LeftButton) {
                    I3.dispatch("kill")
                }
            }
        }
    }

    IconImage {
        implicitSize: Theme.style.fontSize
        anchors.verticalCenter: parent.verticalCenter
        source: focusedWindow !== "" ? Quickshell.iconPath(resolveIcon(focusedAppId), "application-x-executable") : ""
        smooth: true
    }

    TextLabel {
        text: focusedWindow
        maximumLineCount: 1
        maxWidth: 400
    }
}