pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import qs.config

Singleton {
    id: sessionService

    property bool inhibited: false
    property bool isLocked: false
    property bool screensOff: false
    


    IdleMonitor {
        id: dimMonitor
        enabled: Config.modules.session.dimmEnabled && BrightnessService.isEnabled
        timeout: Config.modules.session.dimmTimeout
        respectInhibitors: true
        onIsIdleChanged: {
            if (isIdle) dimBacklight()
            else {
                restoreBacklight()
                restoreMonitors()
            }
        }
    }

    IdleMonitor {
        id: offMonitor
        enabled: Config.modules.session.offMonitorsEnabled
        timeout: Config.modules.session.offMonitorsTimeout
        respectInhibitors: true
        onIsIdleChanged: {
            if (isIdle) offMonitors()
            else restoreMonitors()
        }
    }

    IdleMonitor {
        id: lockMonitor
        enabled: Config.modules.session.lockEnabled
        timeout: Config.modules.session.lockTimeout
        respectInhibitors: true
        onIsIdleChanged: {
            if (isIdle) {
                lockSession()
            } else {
                offMonitorOnLock.stop()
                restoreMonitors()
            }
        }
    }

    IdleMonitor {
        id: suspendMonitor
        enabled: Config.modules.session.suspendEnabled
        timeout: Config.modules.session.suspendTimeout
        respectInhibitors: true
        onIsIdleChanged: {
            if (isIdle) suspendSystem()
            
        }
    }

    Timer {
        id: offMonitorOnLock
        interval: 15000 // 15 seconds in milliseconds
        repeat: false
        onTriggered: offMonitors()
    }

    Component.onCompleted: {
        console.log("SessionService lock", Config.modules.session.lockEnabled)
        console.log("SessionService dim", Config.modules.session.dimmTimeout)
        console.log("SessionService off", Config.modules.session.offMonitorsTimeout)
        console.log("SessionService suspend", Config.modules.session.suspendTimeout)
        console.log("SessionService inhibited", inhibited)
        console.log("SessionService screens", Config.modules.session.offMonitorsEnabled)
    }

    function offMonitors() {
        console.log("Turning off monitors")
        if (screensOff) return
        cmd.command = ["swaymsg", "output * power off"]
        cmd.running = true
        screensOff = true
    }


    function restoreMonitors() {
        console.log("Restoring monitors")
        if (!screensOff) return
        cmd.command = ["swaymsg", "output * power on"]
        cmd.running = true
        screensOff = false
    }

    function dimBacklight() {
        console.log("Dimming backlight")
    }


    function restoreBacklight() {
        console.log("Restoring backlight")
    }

    function lockSession() {
        console.log("Locking session")
        isLocked = true
        offMonitorOnLock.restart()
    }

    function suspendSystem() {
        cmd.command = ["systemctl", "suspend"]
        cmd.running = true
    }

    function powerOffSystem() {
        cmd.command = ["systemctl", "poweroff"]
        cmd.running = true
    }

    Process {
        command: [
            "dbus-monitor", 
            "--system", 
            "type='signal',interface='org.freedesktop.login1.Session',member='Lock'"
        ]
        running: true
        
        stdout: SplitParser {
            splitMarker: "\n"
            onRead: (data) => {
                if (data.includes("member=Lock")) {
                    lockSession()
                }
            }
        }
    }


    Process {
        id: cmd
    }

    IpcHandler {
        target: "session"

        function lock() {
            lockSession()
        }

        function suspend() {
            suspendSystem()
        }

        function powerOff() {
            powerOffSystem()
        }
    }
}
