import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland

ShellWindow {
    id: root
    width: 300
    height: 100
    visible: true

    // Winstancjonowanie menedżera gamma
    WlrGammaControlManager {
        id: gammaManager
    }

    // Instancja sterowania dla domyślnego/pierwszego ekranu
    WlrGammaControl {
        id: gammaControl
        // Przypisanie do wybranego ekranu Wayland
        target: Quickshell.screens[0] ? Quickshell.screens[0].wlrOutput : null
        manager: gammaManager
    }

    Column {
        anchors.centerIn: parent
        spacing: 10

        Text {
            text: "Temperatura barwowa: " + Math.round(tempSlider.value) + "K"
            color: "white"
        }

        Slider {
            id: tempSlider
            from: 3000
            to: 6500
            value: 6500
            stepSize: 100

            onValueChanged: {
                if (gammaControl.valid) {
                    // Przeliczenie temperatury w Kelvinach na składowe RGB
                    let rgb = kelvinToRgb(value)

                    // Ustawienie korekcji rampy gamma w QuickShell
                    gammaControl.setRgb(rgb.r, rgb.g, rgb.b)
                }
            }
        }
    }

    // Funkcja przeliczająca temperaturę barwową (Kelvin) na mnożniki RGB (0.0 - 1.0)
    function kelvinToRgb(kelvin) {
        let temp = kelvin / 100;
        let r, g, b;

        // Czerwony
        if (temp <= 66) {
            r = 255;
        } else {
            r = temp - 60;
            r = 329.698727446 * Math.pow(r, -0.1332047592);
            r = Math.min(Math.max(r, 0), 255);
        }

        // Zielony
        if (temp <= 66) {
            g = temp;
            g = 99.4708025861 * Math.log(g) - 161.1195681661;
            g = Math.min(Math.max(g, 0), 255);
        } else {
            g = temp - 60;
            g = 288.1221695283 * Math.pow(g, -0.0755148492);
            g = Math.min(Math.max(g, 0), 255);
        }

        // Niebieski
        if (temp >= 66) {
            b = 255;
        } else if (temp <= 19) {
            b = 0;
        } else {
            b = temp - 10;
            b = 138.5177312231 * Math.log(b) - 305.0447927307;
            b = Math.min(Math.max(b, 0), 255);
        }

        return {
            r: r / 255.0,
            g: g / 255.0,
            b: b / 255.0
        };
    }
}