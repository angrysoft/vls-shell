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
        respectInhibitors: false
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

      onIsLockedChanged: {
        if (!isLocked) {
            offMonitorOnLock.stop()
            restoreMonitors()
        }
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
        offMonitorOnLock.stop()
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
