// LockScreen.qml
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pam
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import qs.services
import qs.theme
import qs.components
import qs.config

WlSessionLock {
    id: lock

    locked: SessionService.isLocked

    WlSessionLockSurface {
        id: surface

        readonly property bool isPasswordScreen: surface.screen === (Quickshell.screens.find(s => s.name === Config.modules.main.screen) ?? Quickshell.screens[0])

        PamContext {
            id: pam
            config: "veles-shell-lock"  // patrz niżej: /etc/pam.d/veles-shell-lock

            // onPamMessage: {
            //     // wiadomości typu "Password: " albo błędy — pokaż w UI
            //     console.log("PAM message:", message)
            // }

            onResponseRequiredChanged: {
                if (pam.responseRequired) {
                    pam.respond(passwordField.text);
                }
            }

            onCompleted: result => {
                if (result === PamResult.Success) {
                    SessionService.isLocked = false;
                    SessionService.restoreMonitors();
                } else {
                    passwordField.triggerShake();
                }
            }
        }

        Rectangle {
            id: background
            anchors.fill: parent
            color: Theme.colors.surface

            Column {
                anchors.centerIn: parent
                spacing: Theme.style.spacing
                visible: surface.isPasswordScreen

                TextLabel {
                    id: clockView
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: Theme.style.fontSize * 6
                    SystemClock {
                        id: clock
                        precision: SystemClock.Seconds
                    }

                    readonly property var locale: Qt.locale()
                    readonly property string format: "hh:mm"

                    text: locale.toString(clock.date, format)

                    bold: true
                }

                TextLabel {
                    id: dateView
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: Theme.style.fontSize * 2
                    SystemClock {
                        id: dateClock
                        precision: SystemClock.Hours
                    }

                    readonly property var locale: Qt.locale()
                    readonly property string format: "ddd d MMM"

                    text: locale.toString(dateClock.date, format)

                    bold: true
                }

                StyledTextField {
                    id: passwordField
                    anchors.horizontalCenter: parent.horizontalCenter
                    implicitWidth: 260
                    implicitHeight: 48
                    placeholderText: qsTr("Password")
                    // focus: true
                    echoMode: TextInput.Password
                    passwordCharacter: "*"

                    enabled: !pam.active

                    onAccepted: {
                        pam.start();
                    }

                    Keys.onEscapePressed: passwordField.clear()

                    Component.onCompleted: {
                        if (surface.isPasswordScreen) {
                            passwordField.forceActiveFocus();
                        }
                    }

                    function triggerShake() {
                        shakeAnimation.restart();
                        passwordField.clear();
                    }

                    property real originX: x

                    SequentialAnimation {
                        id: shakeAnimation

                        NumberAnimation {
                            target: passwordField
                            property: "anchors.horizontalCenterOffset"
                            to: -10
                            duration: 50
                            easing.type: Easing.InOutQuad
                        }
                        NumberAnimation {
                            target: passwordField
                            property: "anchors.horizontalCenterOffset"
                            to: 10
                            duration: 50
                            easing.type: Easing.InOutQuad
                        }
                        NumberAnimation {
                            target: passwordField
                            property: "anchors.horizontalCenterOffset"
                            to: -8
                            duration: 50
                            easing.type: Easing.InOutQuad
                        }
                        NumberAnimation {
                            target: passwordField
                            property: "anchors.horizontalCenterOffset"
                            to: 8
                            duration: 50
                            easing.type: Easing.InOutQuad
                        }
                        NumberAnimation {
                            target: passwordField
                            property: "anchors.horizontalCenterOffset"
                            to: -4
                            duration: 50
                            easing.type: Easing.InOutQuad
                        }
                        NumberAnimation {
                            target: passwordField
                            property: "anchors.horizontalCenterOffset"
                            to: 0
                            duration: 50
                            easing.type: Easing.InOutQuad
                        }
                    }
                }
            }
        }
    }
}
