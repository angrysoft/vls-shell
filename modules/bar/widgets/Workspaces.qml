import Quickshell
import Quickshell.I3
import QtQuick
import qs.theme


Row {
    spacing: Theme.style.spacing

    WheelHandler {
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        onWheel: wheel => {
            if (wheel.angleDelta.y > 0) {
                I3.dispatch("workspace prev");
            } else if (wheel.angleDelta.y < 0) {
                I3.dispatch("workspace next");
            }
        }
    }
    
    Repeater {
        model: I3.workspaces
        delegate: Rectangle {
            id: wdButton
            implicitHeight: Theme.style.barHeight - Theme.style.padding * 2
            implicitWidth: implicitHeight
            radius: Theme.style.borderRadius
            color: modelData.focused ? Theme.colors.surface_container_high : "transparent"
          
            Text {
                anchors.centerIn: parent
                text: modelData.name
                color: modelData.focused ? Theme.colors.on_surface : Theme.colors.on_surface_variant
                font.pixelSize: Theme.style.fontSize
                font.bold: modelData.focused
            }

            TapHandler {
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onTapped: (eventPoint, button) => {
                    if (button === Qt.LeftButton) {
                        I3.dispatch("workspace " + modelData.name);
                    }
                }
            }

            
            }
        }
}