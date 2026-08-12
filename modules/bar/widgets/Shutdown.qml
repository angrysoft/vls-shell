import Quickshell
import Quickshell.Widgets
import QtQuick
import qs.components
import qs.theme


// Rectangle {
//     id: powerButton
//     implicitHeight: Theme.style.barHeight + Theme.style.padding * 2
//     implicitWidth: implicitHeight
    
//     color: "transparent"
    
    IconImage {
        id: powerButton
        implicitSize: Theme.style.barHeight + Theme.style.padding * 2
        anchors.verticalCenter: parent.verticalCenter
        source: Quickshell.iconPath("system-shutdown-panel")
        smooth: true
        property bool isOpen: false

        HoverHandler{
            id: hover
            cursorShape: Qt.PointingHandCursor
        }

        TapHandler {
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onTapped:(eventPoint, button) => {
                if (button === Qt.LeftButton) {
                    isOpen = !isOpen;
                } else if (button === Qt.RightButton) {
                    isOpen = !isOpen;
                }
            }
        }

        onIsOpenChanged: {
    if (!isOpen) closeTimer.start()
}
        
        PopupWindow {
            id: popup
            color: "transparent"
            anchor {
                //window: bar
                item: powerButton
                edges: Edges.Bottom | Edges.Left
                gravity: Edges.Bottom | Edges.Right
            }
            // anchor.rect.x: parentWindow.width / 2 - width / 2
            // anchor.rect.y: parentWindow.height
            implicitHeight: column.implicitHeight + Theme.style.padding
            implicitWidth: implicitHeight
            visible: powerButton.isOpen || closeTimer.running

             Timer {
                id: closeTimer
                interval: 320
                running: false
            }


            Rectangle {
                id: powerMenu
                anchors.fill: parent
                color: Theme.colors.surface
                border.color: Theme.colors.outline
                border.width: Theme.style.borderWidth
                radius: Theme.style.borderRadius
                implicitHeight: column.implicitHeight + Theme.style.padding * 4

                opacity: 0
                transform: Translate {
                    id: slideTransform
                    y: -powerMenu.implicitHeight / 2
                }

                states: State {
                    name: "open"
                    when: powerButton.isOpen
                    PropertyChanges { target: powerMenu; opacity: 1; }
                    PropertyChanges { target: slideTransform; y: 0; }
                }

                transitions: [
                    Transition {
                        from: ""; to: "open"
                        ParallelAnimation {
                            NumberAnimation { target: powerMenu; property: "opacity"; duration: 280; easing.type: Easing.OutCubic }
                            NumberAnimation { target: slideTransform; property: "y"; duration: 440; easing.type: Easing.OutBack }
                        }
                    },
                    Transition {
                        from: "open"; to: ""
                        ParallelAnimation {
                            NumberAnimation { target: powerMenu; property: "opacity"; duration: 240; easing.type: Easing.InCubic }
                            NumberAnimation { target: slideTransform; property: "y"; duration: 280; easing.type: Easing.InBack }
                        }
                    }
                ]

            Column {
                id: column
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: Theme.style.padding
                anchors.verticalCenter: parent.verticalCenter
                spacing: Theme.style.spacing

                Repeater {
                    model: [
                        { label: "Lock",     icon: "lock-screen" },
                        { label: "Logout",   icon: "system-log-out-symbolic" },
                        { label: "Reboot",   icon: "system-reboot-symbolic" },
                        { label: "Shutdown", icon: "system-shutdown-symbolic" }
                    ]

                    delegate: Rectangle {
                        id: item
                        required property var modelData
                        required property int index

                        width: column.width
                        height: Theme.style.barHeight - Theme.style.padding * 2
                        radius: Theme.style.borderRadius
                        color: itemHover.hovered ? Theme.colors.surface_container : "transparent"


                        HoverHandler { id: itemHover }

                        TapHandler {
                            onTapped: {
                                console.log("Clicked:", item.modelData.label)
                                powerButton.isOpen = false
                                // TODO: wywołaj akcję
                            }
                        }

                        Row {
                            anchors {
                                left: parent.left
                                verticalCenter: parent.verticalCenter
                                leftMargin: Theme.style.padding
                                rightMargin: Theme.style.padding

                            }
                            spacing: Theme.style.spacing

                            IconImage {
                                implicitSize: parent.implicitHeight
                                anchors.verticalCenter: parent.verticalCenter
                                source: Quickshell.iconPath(item.modelData.icon)
                            }

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: item.modelData.label
                                color: Theme.colors.on_surface
                            }
                        }
                    }
                }
            }
        }
    }
}
