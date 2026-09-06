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
    


    IdleMonitor {
        id: dimMonitor
        enabled: Config.modules.session.dimmEnabled && BrightnessService.isEnabled
        timeout: Config.modules.session.dimmTimeout
        respectInhibitors: true
        onIsIdleChanged: {
            if (isIdle) dimBacklight()
            else restoreBacklight()
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

    // dłuższy -> zablokowanie sesji
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
            }
        }
    }

    // najdłuższy -> DPMS off / suspend
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
        interval: 30000 // 30 seconds in milliseconds
        repeat: false
        onTriggered: offMonitors()
    }

    Component.onCompleted: {
        console.log("SessionService initialized", Config.modules.session.lockTimeout)
    }

    function offMonitors() {
        // cmd.command = ["swaymsg", "output * dpms off"]
        // cmd.running = true
        for (let i = 0; i < Quickshell.screens.length; i++) {
            let output = Quickshell.screens[i]
            if (output && output.wayland) {
                output.wayland.powerSave = true
            }
        }
    }


    function restoreMonitors() {
        // cmd.command = ["swaymsg", "output * dpms on"]
        // cmd.running = true
        for (let i = 0; i < Quickshell.screens.length; i++) {
            let output = Quickshell.screens[i]
            if (output && output.wayland) {
                output.wayland.powerSave = false
            }
        }
    }

    function dimBacklight() {
        // cmd.command = ["swaymsg", "output * dpms off"]
        // cmd.running = true
        console.log("Dimming backlight")
    }


    function restoreBacklight() {
        // cmd.command = ["swaymsg", "output * dpms on"]
        // cmd.running = true
        console.log("Restoring backlight")
    }

    function lockSession() {
        // cmd.command = ["loginctl", "lock-session"]
        // cmd.command = ["gtklock", "-d"]
        // cmd.running = true
        console.log("Locking session")
        isLocked = true
        offMonitorOnLock.start()
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
