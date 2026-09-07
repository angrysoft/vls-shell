import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.services
import qs.theme

IconImage {
    id: notifyButton
    implicitSize: parent.implicitHeight
    source: Quickshell.iconPath(NotificationsService.hasNotifications ? "notification-new-symbolic" : "notification-symbolic")
    smooth: true
    // visible: NotificationsService.hasNotifications
    property bool isOpen: false
    
    TapHandler {
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onTapped:(eventPoint, button) => {
            if (button === Qt.LeftButton) {
                notifyButton.isOpen = !notifyButton.isOpen
            } else if (button === Qt.RightButton) {
                console.log("logo right clicked")
            }
        }
    }

    PopupWindow {
        id: notifyPopup
        color: "transparent"
        anchor {
            item: notifyButton
            edges: Edges.Bottom | Edges.Left
            gravity: Edges.Bottom | Edges.Right
        }
        
        implicitHeight: column.implicitHeight + Theme.style.padding * 2
        implicitWidth: implicitHeight
        visible: notifyButton.isOpen || closeTimer.running


        Timer {
            id: closeTimer
            interval: 320
            running: false
        }


        Rectangle {
            id: notifyList
            anchors.fill: parent
            color: Theme.colors.surface
            bottomLeftRadius: Theme.style.borderRadius
            bottomRightRadius: Theme.style.borderRadius
            implicitHeight: column.implicitHeight + Theme.style.padding * 4

            opacity: 0
            transform: Translate {
                id: slideTransform
                y: -notifyList.implicitHeight / 2
            }

            states: State {
                name: "open"
                when: notifyButton.isOpen
                PropertyChanges { target: notifyList; opacity: 1; }
                PropertyChanges { target: slideTransform; y: 0; }
            }

            transitions: [
                Transition {
                    from: ""; to: "open"
                    ParallelAnimation {
                        NumberAnimation { target: notifyList; property: "opacity"; duration: 280; easing.type: Easing.OutCubic }
                        NumberAnimation { target: slideTransform; property: "y"; duration: 440; easing.type: Easing.OutCubic }
                    }
                },
                Transition {
                    from: "open"; to: ""
                    ParallelAnimation {
                        NumberAnimation { target: notifyList; property: "opacity"; duration: 240; easing.type: Easing.InCubic }
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
                                        notifyButton.runAction(item.modelData.id)
                                        notifyButton.isOpen = false
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
