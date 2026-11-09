import Quickshell
import Quickshell.Widgets
// import Quickshell.I3
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import qs.theme
import qs.config
import qs.components

RowLayout {
    spacing: Theme.style.spacing

    property string focusedWindow: ""
    property string focusedAppId: ""

    //  I3IpcListener {
    //     subscriptions: ["window", "workspace"]

    //     onIpcEvent: function (event) {
    //         const data = JSON.parse(event.data)
    //         if (event.type === "window") {
    //             if (data.change === "close") {
    //                 hideStatus()
    //             } else if (data.change === "focus") {
    //                 visible = data.container.visible ?? false
    //                 focusedWindow = data.container.name ?? ""
    //                 focusedAppId = (data.container.app_id ?? "").toLowerCase()
    //             }
    //         } else if (event.type === "workspace" && data.change === "focus" && data.current.nodes.length === 0) {
    //             hideStatus()
    //         }
    //     }
    // }

    function hideStatus() {
        visible = false;
        focusedWindow = "";
        focusedAppId = "";
    }

    function findFocused(node) {
        if (node.focused)
            return node;
        for (var i = 0; i < (node.nodes?.length ?? 0); i++) {
            var result = findFocused(node.nodes[i]);
            if (result)
                return result;
        }
        for (var j = 0; j < (node.floating_nodes?.length ?? 0); j++) {
            var result = findFocused(node.floating_nodes[j]);
            if (result)
                return result;  // strip sway's instance numbers, e.g. "Alacritty__instance_1"
        }
        return null;
    }

    function resolveIcon(appId) {
        if (!appId)
            return "application-x-executable";
        var map = {
            "code": "vscode",
            "com.microsoft.VSCode": "vscode",
            "org.gnome.boxes": "gnome-boxes",
            "alacritty": "Alacritty",
            "org.gnome.nautilus": "org.gnome.Nautilus",
            "org.gnome.terminal": "org.gnome.Terminal",
            "jetbrains-idea": "idea",
            "jetbrains-goland": "goland"
        };
        return map[appId] || appId;
    }

    // Initially fetch the focused window and appId from sway
    // This is necessary because the I3IpcListener only receives events after it has been created, so we need to fetch the current state of the tree to get the initial focused window and appId.
    // Process {
    //     id: treeProc
    //     command: ["swaymsg", "-t", "get_tree"]
    //     running: true
    //     stdout: StdioCollector {
    //         onStreamFinished: {
    //             try {
    //                 var tree = JSON.parse(text);
    //                 var focused = findFocused(tree);
    //                 if (focused) {
    //                     visible = focused.visible ?? false;
    //                     focusedWindow = focused.name ?? "";
    //                     focusedAppId = (focused.app_id ?? focused.window_properties?.class ?? "").toLowerCase();
    //                 }
    //             } catch (e) {}
    //         }
    //     }
    // }

    Process {
        id: jsonProcess
        command: ["mmsg", "watch", "all-clients"]
        running: true

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => {
                try {
                    let allClients = JSON.parse(data);
                    visible = false;
                    for (let client of allClients.clients) {
                        if (client.is_focused) {
                            visible = true;
                            focusedWindow = client.title ?? "";
                            focusedAppId = client.appid ?? "";
                            break;
                        }
                    }
                } catch (e) {
                    console.error("Błąd parsowania JSON:", e);
                }
            }
        }

        stderr: SplitParser {
            splitMarker: "\n"
            onRead: data => {
                console.error("Błąd procesu:", data);
            }
        }
    }

    Process {
        id: mangoDispatch
        running: false
    }

    IconImage {
        implicitSize: Layout.preferredHeight
        source: Quickshell.iconPath("window-close-symbolic")
        smooth: true

        HoverHandler {
            id: hover
            cursorShape: Qt.PointingHandCursor
        }

        TapHandler {
            acceptedButtons: Qt.LeftButton
            onTapped: (eventPoint, button) => {
                if (button === Qt.LeftButton) {
                    mangoDispatch.command = ["mmsg", "dispatch", "killclient"];
                    mangoDispatch.running = true;
                }
            }
        }
    }

    IconImage {
        implicitSize: Theme.style.fontSize
        source: focusedWindow !== "" ? Quickshell.iconPath(resolveIcon(focusedAppId), "application-x-executable") : ""
        smooth: true
    }

    Text {
        text: focusedWindow
        elide: Text.ElideRight
        color: Theme.colors.on_surface
        font.family: Theme.style.fontFamily
        font.pixelSize: Theme.style.fontSize
        maximumLineCount: 1
        Layout.maximumWidth: 400
        Layout.preferredWidth: implicitWidth
    }

    Hint {
        text: focusedWindow
    }
}
