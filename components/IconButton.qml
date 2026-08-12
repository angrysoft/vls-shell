// components/IconButton.qml
import QtQuick
import qs.theme

Rectangle {
    id: root

    property alias text: label.text
    property alias icon: icon.icon
    signal clicked()

    implicitWidth: 32
    implicitHeight: 32
    radius: Theme.style.borderRadius
    color: mouse.containsMouse ? Theme.colors.surface : "transparent"

    Behavior on color { ColorAnimation { duration: 150 } }

    Image {
        id: icon
        anchors.centerIn: parent
        width: 16
        height: 16
        fillMode: Image.PreserveAspectFit
        source: Quickshell.iconPath(icon, "actions")
        color: Theme.colors.on_surface
    }

    Text {
        id: label
        anchors.centerIn: parent
        color: Theme.colors.on_surface
        font.family: Theme.style.fontFamily
        font.pixelSize: Theme.style.fontSize
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}