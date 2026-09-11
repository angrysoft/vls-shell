import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.components
import qs.config
import qs.theme

TextLabel {
    id: clockView

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    readonly property var locale: Qt.locale()
    readonly property string format: Config.modules.bar.clockFormat ? Config.modules.bar.clockFormat : "ddd d MMM hh:mm:ss"
    property int month: Calendar.December
    property int year: 2015

    text: locale.toString(clock.date, format)

    bold: true

    property bool isOpen: false

    onIsOpenChanged: {
        if (isOpen) {
            clockView.month = clock.date.getMonth();
            clockView.year = clock.date.getFullYear();
        }
    }

    TapHandler {
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onTapped: (eventPoint, button) => {
            if (button === Qt.LeftButton) {
                clockView.isOpen = !clockView.isOpen;
            } else if (button === Qt.RightButton) {
                console.log("logo right clicked");
            }
        }
    }

    PopupWindow {
        id: calendarPopup
        color: "transparent"
        // grabFocus: true

        anchor {
            window: bar
            rect.x: bar.width / 2 - width / 2
            rect.y: bar.height
        }

        // Fixed width breaks the DayOfWeekRow/ColumnLayout polish() feedback
        // loop that happens when the popup width is derived from the row's
        // own implicitWidth while the row also fills that same width.
        implicitHeight: calendar.implicitHeight + Theme.style.dialogPadding
        implicitWidth: 7 * 40 + Theme.style.dialogPadding
        visible: clockView.isOpen || closeTimer.running

        onVisibleChanged: {
            if (!visible) {
                closeTimer.stop();
                clockView.isOpen = false;
            }
        }

        Timer {
            id: closeTimer
            interval: 320
            running: false
        }

        Rectangle {
            id: calendarContainer
            anchors.fill: parent
            color: Theme.colors.surface
            radius: Theme.style.dialogRadius

            FlexboxLayout {
                id: calendar
                // columns: 3
                anchors.fill: parent
                gap: Theme.style.spacing

                DayOfWeekRow {

                    Layout.fillWidth: true
                }

                // DayOfWeekRow {
                //     locale: clockView.locale

                //     // Layout.column: 1
                //     Layout.fillWidth: true
                // }

                // MonthGrid {
                //     id: grid
                //     month: clockView.month
                //     year: clockView.year
                //     locale: clockView.locale

                //     Layout.fillWidth: true
                //     Layout.fillHeight: true
                // }
            }
        }
    }
}
