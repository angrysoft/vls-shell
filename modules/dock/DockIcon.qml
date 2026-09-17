import QtQuick
import Quickshell

Item {
    id: root

    required property string appName
    required property string iconName
    signal clicked()

    implicitWidth: 48
    implicitHeight: 48

    property bool hovered: false
    scale: hovered ? 1.25 : 1.0

    Behavior on scale {
        NumberAnimation { duration: 140; easing.type: Easing.OutBack }
    }

    Image {
        anchors.fill: parent
        source: Quickshell.iconPath(root.iconName, true)
        fillMode: Image.PreserveAspectFit
        smooth: true
    }

    Rectangle {
        visible: root.hovered
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom
        anchors.topMargin: 4
        width: 4
        height: 4
        radius: 2
        color: "#feb877"

        // ToolTip.visible: root.hovered
        // ToolTip.text: root.appName
        // ToolTip.delay: 400
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered: root.hovered = true
        onExited: root.hovered = false
        onClicked: root.clicked()
    }
}