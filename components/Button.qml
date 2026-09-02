import QtQuick
import Quickshell
import qs.theme

Rectangle {
    id: button
    required property string  label
    implicitHeight: 32
    implicitWidth: Math.max(100, labelText.implicitWidth + Theme.style.margin)
    radius: implicitHeight / 2
    color: Theme.colors.primary

    Text {
        id: labelText
        anchors.centerIn: parent
        text: button.label
        color: Theme.colors.on_primary
    }
}