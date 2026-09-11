import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import qs.services
import qs.theme
import qs.components

IconImage {
    id: notifyButton
    implicitSize: parent.implicitHeight
    source: Quickshell.iconPath(NotificationsService.hasNotifications ? "notification-new-symbolic" : "notification-symbolic")
    smooth: true
    // visible: NotificationsService.hasNotifications
    property bool isOpen: false

    TapHandler {
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onTapped: (eventPoint, button) => {
            if (button === Qt.LeftButton) {
                notifyButton.isOpen = !notifyButton.isOpen;
            } else if (button === Qt.RightButton) {
                console.log("logo right clicked");
            }
        }
    }

    PopupWindow {
        id: notifyPopup
        color: "transparent"
        // grabFocus: true

        anchor {
            window: bar
            rect.x: bar.width / 2 - width / 2
            rect.y: bar.height
        }

        implicitHeight: 600 + (PlayerService.hasPlayers ? 200 : 0)
        implicitWidth: 500
        visible: notifyButton.isOpen || closeTimer.running

        onVisibleChanged: {
            if (!visible) {
                closeTimer.stop();
                notifyButton.isOpen = false;
            }
        }

        Timer {
            id: closeTimer
            interval: 320
            running: false
        }

        Rectangle {
            id: notifyList
            anchors.fill: parent
            color: Theme.colors.surface
            radius: Theme.style.dialogRadius

            ColumnLayout {
                id: notifyColumn
                spacing: Theme.style.spacing
                anchors.fill: parent

                Players {}

                RowLayout {
                    Layout.margins: Theme.style.dialogPadding

                    TextLabel {
                        Layout.fillWidth: true
                        text: "Notifications"
                        font.pixelSize: Theme.style.fontSize * 1.2
                    }

                    ButtonFilled {
                        id: clearAllButton
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        text: "Clear All"
                        enabled: NotificationsService.hasHistory()

                        onClicked: {
                            NotificationsService.clearHistory();
                            notifyButton.isOpen = false;
                        }
                    }
                }

                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.leftMargin: Theme.style.dialogPadding
                    Layout.rightMargin: Theme.style.dialogPadding
                    clip: true
                    spacing: Theme.style.spacing

                    model: NotificationsService.getHistory()

                    delegate: NotifyCard {
                        width: ListView.view.width
                        required property var modelData
                        notification: modelData
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }
}
