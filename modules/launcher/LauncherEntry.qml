import QtQuick
import Quickshell
import qs.theme

Rectangle {
    id: root
    property var entry
    property bool isSelected: false
    signal clicked()

    height: 44
    radius: 8
    color: isSelected ? Theme.colors.primary_container : "transparent"

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.clicked()
    }

    Row {
        anchors.fill: parent
        anchors.leftMargin: 8
        spacing: Theme.style.spacing

        Image {
            width: 28
            height: 28
            anchors.verticalCenter: parent.verticalCenter
            source: Quickshell.iconPath(entry.icon, "application-x-executable")
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: entry.name
            color: root.isSelected ? Theme.colors.on_primary_container : Theme.colors.on_surface
            font.pixelSize: Theme.style.fontSize
        }
    }
}