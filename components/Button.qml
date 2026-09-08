import QtQuick
import Quickshell
import qs.theme

Rectangle {
    id: button
    required property string label
    property bool disabled: true
    implicitHeight: 32
    implicitWidth: Math.max(100, labelText.implicitWidth + Theme.style.margin)
    radius: implicitHeight / 2
    color: button.disabled ? Theme.colors.surface_bright : Theme.colors.primary_container

    Text {
        id: labelText
        anchors.centerIn: parent
        text: button.label
        color: Theme.colors.on_primary
    }
}
