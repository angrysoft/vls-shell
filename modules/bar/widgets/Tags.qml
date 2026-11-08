import Quickshell
import Quickshell.Io
// import Quickshell.I3
import QtQuick
import QtQuick.Layouts
import qs.theme

Rectangle {
    id: tagView
    Layout.fillHeight: true
    Layout.preferredWidth: height
    radius: Theme.style.borderRadius
    color: Theme.colors.surface_container_high
    property int current: -1

    WheelHandler {
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        onWheel: wheel => {
            if (wheel.angleDelta.y > 0) {
                moveToTag.command = ["mmsg", "dispatch", "viewtoleft"];
                moveToTag.running = true;
            } else if (wheel.angleDelta.y < 0) {
                moveToTag.command = ["mmsg", "dispatch", "viewtoright"];
                moveToTag.running = true;
            }
        }
    }

    Process {
        id: moveToTag
        running: false
    }

    Process {
        id: jsonProcess
        command: ["mmsg", "watch", "all-tags"]
        running: true

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => {
                try {
                    let allTags = JSON.parse(data);
                    for (let monitor of allTags.all_tags) {
                        for (let tag of monitor.tags) {
                            if (tag.is_active)
                                tagView.current = tag.index;
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

    Text {
        anchors.centerIn: parent
        text: tagView.current
        color: Theme.colors.on_surface
        font.pixelSize: Theme.style.fontSize
        font.bold: true
    }
}