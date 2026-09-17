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
    property int year: 2026
    property date currentDate: clock.date

    text: locale.toString(clock.date, format)

    bold: true

    property bool isOpen: false

    onIsOpenChanged: {
        if (isOpen) {
            clockView.month = clock.date.getMonth();
            clockView.year = clock.date.getFullYear();
            clockView.currentDate = clock.date;
        }
    }

    function prevMonth() {
        let d = new Date(clockView.currentDate);
        d.setMonth(d.getMonth() - 1);
        clockView.currentDate = d;
    }

    function nextMonth() {
        let d = new Date(clockView.currentDate);
        d.setMonth(d.getMonth() + 1);
        clockView.currentDate = d;
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
        implicitWidth: 7 * 50 + (Theme.style.dialogPadding * 2)
        visible: clockView.isOpen || closeTimer.running

        onVisibleChanged: {
            if (!visible) {
                closeTimer.stop();
                clockView.isOpen = false;
            }
        }

        WheelHandler {
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
            onWheel: wheel => {
                if (wheel.angleDelta.y > 0) {
                    clockView.prevMonth();
                } else if (wheel.angleDelta.y < 0) {
                    clockView.nextMonth();
                }
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

            ColumnLayout {
                id: calendar
                anchors.fill: parent
                spacing: Theme.style.spacing

                RowLayout {
                    Layout.fillWidth: true
                    Layout.margins: Theme.style.dialogPadding
                    spacing: Theme.style.spacing

                    ButtonFilled {
                        text: "<"
                        onClicked: {
                            clockView.prevMonth();
                        }
                    }
                    TextLabel {
                        text: {
                            let monthName = clockView.locale.standaloneMonthName(clockView.currentDate.getMonth(), Locale.LongFormat);
                            // Powiększamy pierwszą literę: "wrzesień" -> "Wrzesień"
                            monthName = monthName.charAt(0).toUpperCase() + monthName.slice(1);

                            return monthName + " " + clockView.currentDate.getFullYear();
                        }
                        bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter
                    }
                    ButtonFilled {
                        text: ">"
                        onClicked: {
                            clockView.nextMonth();
                        }
                    }
                }

                DayOfWeekRow {
                    Layout.fillWidth: true
                    Layout.leftMargin: Theme.style.dialogPadding
                    Layout.rightMargin: Theme.style.dialogPadding
                }

                MonthGrid {
                    id: grid
                    month: clockView.currentDate.getMonth()
                    year: clockView.currentDate.getFullYear()
                    locale: clockView.locale
                    Layout.leftMargin: Theme.style.dialogPadding
                    Layout.rightMargin: Theme.style.dialogPadding
                    Layout.bottomMargin: Theme.style.dialogPadding
                    Layout.fillWidth: true

                    function isToday(date) {
                        let today = clock.date;
                        return date.getDate() === today.getDate() && date.getMonth() === today.getMonth() && date.getFullYear() === today.getFullYear();
                    }

                    delegate: Item {
                        implicitWidth: 40
                        implicitHeight: 36

                        readonly property bool today: grid.isToday(model.date)

                        Rectangle {
                            anchors.centerIn: parent
                            width: 32
                            height: 32
                            radius: 16
                            color: parent.today ? Theme.colors.primary_container : "transparent"
                            visible: parent.today
                        }

                        TextLabel {
                            anchors.centerIn: parent
                            text: model.day
                            opacity: model.month === grid.month ? 1.0 : 0.3
                            bold: parent.today
                            color: parent.today ? Theme.colors.on_primary_container : Theme.colors.on_surface
                        }

                        required property var model
                    }
                }
            }
        }
    }
}
