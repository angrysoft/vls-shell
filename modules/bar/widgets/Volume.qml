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
            if (wheel.angleDelta.y > 0) {
                VolumeService.adjustVolume(0.01);
            } else if (wheel.angleDelta.y < 0) {
                VolumeService.adjustVolume(-0.01);
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

    // HoverHandler {
    //     id: hoverHandler
    // }

    // ToolTip {
    //     visible: hoverHandler.hovered
        
    //     // Place immediately above the parent with a 5px gap
    //     y: -100
    //     text: volume.volumeLevel + "%"
    //     delay: 400 // Milliseconds before appearing
    //     timeout: 5000 // Milliseconds before auto-hiding
    // }
    
}