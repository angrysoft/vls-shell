import QtQuick
import Quickshell
import Quickshell.Widgets

IconImage {
    id: logo
    implicitSize: parent.implicitHeight
    anchors.verticalCenter: parent.verticalCenter
    source: Quickshell.iconPath("archlinux-logo", "distributor-logo-archlinux")
    smooth: true
    
    TapHandler {
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onTapped:(eventPoint, button) => {
            if (button === Qt.LeftButton) {
                console.log("Arch Linux logo left clicked")
            } else if (button === Qt.RightButton) {
                console.log("Arch Linux logo right clicked")
            }
        }
    }
}
