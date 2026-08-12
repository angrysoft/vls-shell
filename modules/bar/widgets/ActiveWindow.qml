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
                        visible = focused.visible ??  false  // only update if the focused window has changed
                        focusedWindow = focused.name ?? ""
                        focusedAppId = (focused.app_id ?? focused.window_properties?.class ?? "").toLowerCase()
                    }
                } catch(e) {}
            }
        }
    }


    // Long-running subscriber — fires on every window/workspace event
    Process {
        command: ["swaymsg", "-t", "subscribe", "-m", "[\"window\", \"workspace\"]"]
        running: true
        stdout: SplitParser {
            onRead: treeProc.running = true   // re-run tree query
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

    // Text {
    //     text: focusedWindow
    //     color: Theme.colors.on_surface
    //     font.family: Theme.style.fontFamily
    //     font.pixelSize: Theme.style.fontSize
    //     font.bold: true
    //     anchors.verticalCenter: parent.verticalCenter
    //     elide: Text.ElideRight
    //     maximumLineCount: 1
    // }
    TextLabel {
        text: focusedWindow
        maximumLineCount: 1
        maxWidth: 400
    }
}