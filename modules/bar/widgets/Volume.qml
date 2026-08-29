import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import qs.theme
import qs.components
import qs.services

Row {
    id: volume
    height: parent.height
    spacing: Theme.style.spacing
    property real volumeLevel: Math.floor(VolumeService.volume * 100)
    property string volumeIconName: VolumeService.muted ? "audio-volume-muted" : (volumeLevel > 66 ? "audio-volume-high" : (volumeLevel > 33 ? "audio-volume-medium" : "audio-volume-low"))

    WheelHandler {
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        onWheel: wheel => {
            console.log("Wheel event detected: angleDelta.y =", wheel.angleDelta.y)
            if (wheel.angleDelta.y > 0) {
                VolumeService.adjustVolume(-0.01);
            } else if (wheel.angleDelta.y < 0) {
                VolumeService.adjustVolume(0.01);
            }
        }
    }

    TextLabel {
        text: volume.volumeLevel + "%"
        anchors.verticalCenter: parent.verticalCenter
        bold: true
        visible: true
    }

    IconImage {
        id: volumeIcon
        implicitSize: parent.height
        anchors.verticalCenter: parent.verticalCenter
        source: Quickshell.iconPath(volume.volumeIconName)
        smooth: true
    }

    HoverHandler {
        id: hoverHandler
    }

    PopupWindow {
        id: tooltip
        visible: hoverHandler.hovered
        
        // Position relative to the parent item
        anchor.item: volume
        // anchor.rect: Qt.rect(volume.x, volume.y, volume.width, volume.height)
        anchor.edges: Edges.Bottom | Edges.Left
        anchor.gravity: Edges.Bottom | Edges.Right

        color: "transparent"

        Rectangle {
            implicitWidth: tipText.implicitWidth + 16
            implicitHeight: tipText.implicitHeight + 8
            color: Theme.colors.surface
            border.color: Theme.colors.outline
            border.width: 1
            radius: 4

            Text {
                id: tipText
                anchors.centerIn: parent
                text: volume.volumeLevel + "%"
                color: Theme.colors.on_surface
                font.pixelSize: 12
            }
        }
    }
    
}