import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import qs.components
import qs.theme
    
IconImage {
    id: powerButton
    implicitSize: Theme.style.barHeight - Theme.style.padding * 2
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

    property var actions: ({
        lock:     ["loginctl", "lock-session"],
        logout:   ["loginctl", "terminate-user", ""],
        suspend:  ["systemctl", "suspend"],
        reboot:   ["systemctl", "reboot"],
        shutdown: ["systemctl", "poweroff"],
    })

    function runAction(actionId) {
        if (!actions[actionId]) {
            console.warn("Unknown action:", actionId)
            return
        }
        actionProcess.command = actions[actionId]
        actionProcess.running = true
    }

    Process {
        id: actionProcess
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
            
            implicitHeight: column.implicitHeight + Theme.style.padding * 2
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
                // border.color: Theme.colors.outline
                // border.width: Theme.style.borderWidth
                // radius: Theme.style.borderRadius
                bottomLeftRadius: Theme.style.borderRadius
                bottomRightRadius: Theme.style.borderRadius
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
                            NumberAnimation { target: slideTransform; property: "y"; duration: 440; easing.type: Easing.OutCubic }
                        }
                    },
                    Transition {
                        from: "open"; to: ""
                        ParallelAnimation {
                            NumberAnimation { target: powerMenu; property: "opacity"; duration: 240; easing.type: Easing.InCubic }
                            NumberAnimation { target: slideTransform; property: "y"; duration: 280; easing.type: Easing.InCubic }
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
                        { id: "lock", label: qsTr("Lock"),     icon: "lock-screen" },
                        { id: "logout", label: qsTr("Logout"),   icon: "system-log-out-symbolic" },
                        { id: "suspend", label: qsTr("Suspend"), icon: "system-suspend-symbolic" },
                        { id: "reboot", label: qsTr("Reboot"),   icon: "system-reboot-symbolic" },
                        { id: "shutdown", label: qsTr("Shutdown"), icon: "system-shutdown-symbolic" },
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
                                powerButton.runAction(item.modelData.id)
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
