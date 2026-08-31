import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import qs.theme
import qs.components
import qs.services

Row {
    id: volume
    spacing: Theme.style.spacing
    anchors.verticalCenter: parent.verticalCenter
    property real volumeLevel: Math.floor(VolumeService.volume * 100)
    property string volumeIconName: VolumeService.muted ? "audio-volume-muted" : (volumeLevel > 66 ? "audio-volume-high" : (volumeLevel > 33 ? "audio-volume-medium" : "audio-volume-low"))
    property int wheelTick: 0

    WheelHandler {
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        onWheel: wheel => {
            volume.wheelTick++
            if (volume.wheelTick % 4 !== 0) return;
            volume.wheelTick = 0;
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
        maximumLineCount: 1
        bold: true
    }

    IconImage {
        id: volumeIcon
        implicitSize: parent.height
        anchors.verticalCenter: parent.verticalCenter
        source: Quickshell.iconPath(volume.volumeIconName)
        smooth: true
    }

    Hint {
        text: VolumeService.name
    }
}