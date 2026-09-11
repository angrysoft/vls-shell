import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import Quickshell
import qs.theme

// Rectangle {
//     id: button
//     required property string label
//     property bool disabled: true
//     implicitHeight: 32
//     implicitWidth: Math.max(100, labelText.implicitWidth + Theme.style.margin)
//     radius: implicitHeight / 2
//     color: button.disabled ? Theme.colors.surface_bright : Theme.colors.primary_container

//     Text {
//         id: labelText
//         anchors.centerIn: parent
//         text: button.label
//         color: Theme.colors.on_primary
//     }
// }

Button {
    id: button
    Material.theme: Material.System // Or Material.Light / Material.Dark
    Material.accent: Theme.colors.primary // M3 Primary key color
    Material.background: Theme.colors.primary_container // Filled button container color
    Material.foreground: Theme.colors.on_primary_container // On-primary text color
    Material.elevation: button.down ? 0 : 1

    // Add a modern ripple/hover state layer
    contentItem: Text {
        text: button.text
        font.pixelSize: Theme.style.fontSize
        font.weight: Font.Medium
        color: button.enabled ? button.Material.foreground : Theme.colors.on_primary
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
