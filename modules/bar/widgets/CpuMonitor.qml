import QtQuick
import Quickshell
import Quickshell.Io
import qs.components

TextLabel {
    property real cpuUsage: 0.0

    // Zmienne do przechowywania wartości z poprzedniej iteracji
    property var prevTotal: 0
    property var prevIdle: 0

    FileView {
        path: "/proc/stat"

        onLoaded: {
            var content = file.readAll();
            var lines = content.split("\n");
            
            // Szukamy pierwszego wiersza zbiorczego "cpu "
            for (var i = 0; i < lines.length; i++) {
                if (lines[i].startsWith("cpu ")) {
                    // Split z wyrażeniem regularnym usuwa wielokrotne spacje
                    var tokens = lines[i].trim().split(/\s+/);
                    
                    // Odczyt poszczególnych czasów (pomijamy tokens[0], czyli ciąg "cpu")
                    var user    = parseInt(tokens[1]) || 0;
                    var nice    = parseInt(tokens[2]) || 0;
                    var system  = parseInt(tokens[3]) || 0;
                    var idle    = parseInt(tokens[4]) || 0;
                    var iowait  = parseInt(tokens[5]) || 0;
                    var irq     = parseInt(tokens[6]) || 0;
                    var softirq = parseInt(tokens[7]) || 0;
                    var steal   = parseInt(tokens[8]) || 0;

                    var currentIdle = idle + iowait;
                    var currentTotal = user + nice + system + idle + iowait + irq + softirq + steal;

                    var deltaTotal = currentTotal - prevTotal;
                    var deltaIdle = currentIdle - prevIdle;

                    if (deltaTotal > 0) {
                        // Obliczenie procentu
                        cpuUsage = ((deltaTotal - deltaIdle) / deltaTotal) * 100;
                    }

                    // Zapamiętanie stanów dla kolejnego odczytu
                    prevTotal = currentTotal;
                    prevIdle = currentIdle;
                    break;
                }
            }
        }
    }

    text: qsTr("CPU: %1%").arg(cpuUsage)
   
}