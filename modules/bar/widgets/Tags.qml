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
                console.log("Dane procesu:", data);
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

// Repeater {
//     model: tagsRow.tags.all_tags
//     delegate: Rectangle {
//         id: wdButton
//         Layout.fillHeight: true
//         Layout.preferredWidth: height
//         radius: Theme.style.borderRadius
//         color: modelData.focused ? Theme.colors.surface_container_high : "transparent"

//         Text {
//             anchors.centerIn: parent
//             text: modelData.monitor
//             color: modelData.focused ? Theme.colors.on_surface : Theme.colors.on_surface_variant
//             font.pixelSize: Theme.style.fontSize
//             font.bold: modelData.focused
//         }

//         TapHandler {
//             acceptedButtons: Qt.LeftButton | Qt.RightButton
//             onTapped: (eventPoint, button) => {
//                 if (button === Qt.LeftButton) {
//                     // I3.dispatch("workspace " + modelData.name);
//                     console.log("Left button tapped on tag:", modelData.index);
//                 }
//             }
//         }
//     }
// }
// }
