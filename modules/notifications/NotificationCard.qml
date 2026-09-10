pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications
import qs.theme
import qs.components

Item {
    id: root
    required property Notification notification

    implicitHeight: card.implicitHeight
    Layout.fillWidth: true

    property real timeout: notification.expireTimeout > 0 ? notification.expireTimeout : 5000

    Timer {
        running: true
        interval: root.timeout
        onTriggered: root.notification.expire()
    }

    NumberAnimation on opacity {
        from: 0
        to: 1
        duration: 200
    }

    Rectangle {
        id: card
        width: parent.width
        radius: Theme.style.dialogRadius
        color: Theme.colors.surface
        border.color: {
            switch (root.notification.urgency) {
            case NotificationUrgency.Critical:
                return Theme.colors.error;
            case NotificationUrgency.Low:
                return "transparent";
            default:
                return Theme.colors.outline;
            }
        }
        border.width: root.notification.urgency === NotificationUrgency.Low ? 0 : 1

        implicitHeight: content.implicitHeight + 24

        ColumnLayout {
            id: content
            anchors {
                fill: parent
                margins: 12
            }
            spacing: Theme.style.spacing

            RowLayout {
                spacing: Theme.style.spacing

                Image {
                    visible: root.notification.appIcon !== "" || root.notification.image !== ""
                    source: root.notification.image !== "" ? root.notification.image : "image://icon/" + root.notification.appIcon
                    Layout.preferredWidth: 32
                    Layout.preferredHeight: 32
                    fillMode: Image.PreserveAspectFit
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.style.spacing

                    Text {
                        text: root.notification.summary
                        color: Theme.colors.on_surface
                        font.bold: true
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }
                    Text {
                        visible: root.notification.body !== ""
                        text: root.notification.body.replace(/&(?!amp;|lt;|gt;|quot;|apos;|#\d+;|#x[0-9a-fA-F]+;)/g, "&amp;")
                        color: Theme.colors.on_surface_variant
                        wrapMode: Text.Wrap
                        Layout.fillWidth: true
                        maximumLineCount: 3
                        elide: Text.ElideRight
                        textFormat: Text.StyledText // bo bodyMarkupSupported, ale escapujemy luźne '&'
                    }
                }
            }

            RowLayout {
                visible: root.notification.actions.length > 0
                spacing: Theme.style.spacing

                Repeater {
                    model: root.notification.actions
                    Button {
                        required property var modelData
                        label: modelData.text
                        MouseArea {
                            anchors.fill: parent
                            onClicked: modelData.invoke()
                        }
                    }
                }
            }
        }

        TapHandler {
            acceptedButtons: Qt.RightButton
            onTapped: (eventPoint, button) => {
                if (button === Qt.RightButton) {
                    root.notification.dismiss();
                }
            }
        }
    }
}
