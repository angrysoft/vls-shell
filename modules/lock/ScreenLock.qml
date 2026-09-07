// LockScreen.qml
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pam
import QtQuick
import QtQuick.Controls
import qs.services
import qs.theme
import qs.components

WlSessionLock {
    id: lock

    // ustawiane np. przez IPC albo sygnał z Twojego Go-backendu (idle/inhibit)
    locked: SessionService.isLocked

    WlSessionLockSurface {
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

        onCompleted: (result) => {
            // console.log("PAM authentication completed with result:", result)
            if (result === PamResult.Success) {
                SessionService.isLocked = false;
            } else {
                // Failed / Error / MaxTries — pokaż shake, wyczyść pole
                passwordField.clear();
                // passwordField.showError();
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

                TextLabel {
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: Theme.style.fontSize * 6
                    id: clockView
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
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: Theme.style.fontSize * 2
                    id: dateView
                    SystemClock {
                        id: dateClock
                        precision: SystemClock.Hours
                    }

                    readonly property var locale: Qt.locale()
                    readonly property string format: "ddd d MMM"

                    text: locale.toString(dateClock.date, format)
                    
                    bold: true
                }


                TextField {
                    id: passwordField
                    // width: parent.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    implicitWidth: 260
                    implicitHeight: 48
                    padding: Theme.style.padding
                    font.pixelSize: Theme.style.fontSize
                    placeholderText: qsTr("Password")
                    focus: true
                    color: Theme.colors.on_surface
                    echoMode: TextInput.Password
                    passwordCharacter: "*"

                    background: Rectangle {
                        border.width: Theme.style.borderWidth
                        border.color: Theme.colors.outline
                        radius: Theme.style.borderRadius
                        color: Theme.colors.surface_container
                    }

                    onAccepted: pam.start()

                    // Keys.onReturnPressed: tryUnlock(text)

                    Keys.onEscapePressed: passwordField.clear()

                    // Keys.onPressed: (event) => {
                    //     SessionService.restoreMonitors()
                    // }
                    // Keys.onEscapePressed: {
                    //     SessionService.isLocked = false
                    // }

                    Component.onCompleted: passwordField.forceActiveFocus()
                }
            }

        }
    }

}