pragma Singleton
import Quickshell
import Quickshell.Services.UPower
import QtQuick

Singleton {
    id: root
// Access the primary composite/system device
    readonly property var battery: UPower.displayDevice

    // Percentage formatted (0-100)
    readonly property int percentage: Math.round((battery?.percentage ?? 0) * 100)
    
    // State indicators
    readonly property bool isCharging: battery?.state === UPowerDeviceState.Charging
    readonly property bool isOnBattery: UPower.onBattery
    readonly property bool isPresent: battery?.isPresent ?? false
    readonly property string iconName: battery?.iconName ?? "battery-missing"
    readonly property string remainingTime: isOnBattery ? (battery?.timeToEmpty > 0 ? formatTime(battery.timeToEmpty) : "") : formatTime(battery.timeToFull)

    function formatTime(seconds) {
        console.log("Formatting time for seconds:", seconds)
        if (seconds <= 0) return ""
        const hours = Math.floor(seconds / 3600)
        const minutes = Math.floor((seconds % 3600) / 60)
        return `${hours}h ${minutes}m`
    }

    function getRemainingTime() {
        if (!isPresent) return "No battery detected"
        if (isOnBattery) {
            return battery?.timeToEmpty > 0 ? formatTime(battery.timeToEmpty) : "Calculating..."
        } else {
            return battery?.timeToFull > 0 ? formatTime(battery.timeToFull) : "Calculating..."
        }
    }
}