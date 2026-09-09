// Calculator.qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import qs.theme
import qs.services

FloatingWindow {
    id: vlsCalculator
    title: "Calculator"

    implicitWidth: 260
    implicitHeight: 340
    minimumSize: Qt.size(260, 340)
    color: "transparent"

    onVisibleChanged: {
        if (!visible) {
            AppService.calculator = false;
        }
    }

    property string expression: ""
    property string display: "0"

    function appendToken(token) {
        if (token === ".") {
            if ( expression.includes(".")) {
                return;
            } else if (expression === "") {
                token = "0.";
            }
        }
        expression += token;
        display = expression;
    }

    function clearAll() {
        expression = "";
        display = "0";
    }

    function backspace() {
        expression = expression.slice(0, -1);
        display = expression.length > 0 ? expression : "0";
    }

    function evaluate() {
        try {
            if (!/^[0-9+\-*/.%() ]+$/.test(expression)) {
                throw "invalid";
            }
            let result = Function('"use strict"; return (' + expression + ')')();
            display = String(result);
            expression = String(result);
        } catch (e) {
            display = "Błąd";
            expression = "";
        }
    }

    function handleKey(event) {
        const key = event.key;
        const text = event.text;

        if (key === Qt.Key_Comma || text === ",") {
            appendToken(".");
            event.accepted = true;
            return;
        }

        // cyfry i operatory - po prostu dokładamy tekst
        if (/^[0-9+\-*/.%()]$/.test(text)) {
            appendToken(text);
            event.accepted = true;
            return;
        }

        switch (key) {
        case Qt.Key_Enter:
        case Qt.Key_Return:
            evaluate();
            event.accepted = true;
            break;
        case Qt.Key_Backspace:
            backspace();
            event.accepted = true;
            break;
        case Qt.Key_Delete:
        case Qt.Key_Escape:
            clearAll();
            event.accepted = true;
            break;
        // klawiatura numeryczna używa tych samych kodów co zwykłe cyfry,
        // ale operatory na numpadzie mają swoje Key_*
        case Qt.Key_Plus:
            appendToken("+");
            event.accepted = true;
            break;
        case Qt.Key_Minus:
            appendToken("-");
            event.accepted = true;
            break;
        case Qt.Key_Asterisk:
            appendToken("*");
            event.accepted = true;
            break;
        case Qt.Key_Slash:
            appendToken("/");
            event.accepted = true;
            break;
        case Qt.Key_Percent:
            appendToken("%");
            event.accepted = true;
            break;
        default:
            event.accepted = false;
        }
    }

    Item {
        id: focusScope
        anchors.fill: parent
        focus: true // przechwytuje zdarzenia klawiatury

        Keys.onPressed: event => vlsCalculator.handleKey(event)

        Rectangle {
            anchors.fill: parent
            radius: 12
            color: Theme.colors.surface
            border.color: Theme.colors.outline
            border.width: Theme.style.borderWidth

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: Theme.style.spacing

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 60
                    radius: 8
                    color: Theme.colors.surface_container

                    Text {
                        anchors.right: parent.right
                        anchors.rightMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - 24
                        text: vlsCalculator.display
                        color: Theme.colors.on_surface
                        font.pixelSize: 24
                        elide: Text.ElideLeft
                        horizontalAlignment: Text.AlignRight
                    }
                }

                GridLayout {
                    columns: 4
                    columnSpacing: 6
                    rowSpacing: 6
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Repeater {
                        model: ["C", "⌫", "%", "/", "7", "8", "9", "*", "4", "5", "6", "-", "1", "2", "3", "+", "0", ".", "=", ""]

                        delegate: Button {
                            focusPolicy: Qt.NoFocus
                            visible: modelData !== ""
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            text: modelData

                            background: Rectangle {
                                radius: Theme.style.borderRadius
                                color: parent.down ? Theme.colors.surface_bright : Theme.colors.primary_container
                            }

                            contentItem: Text {
                                text: parent.text
                                color: parent.down ? Theme.colors.on_primary : Theme.colors.on_primary_container
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.pixelSize: 18
                            }

                            onClicked: {
                                switch (modelData) {
                                case "C":
                                    vlsCalculator.clearAll();
                                    break;
                                case "⌫":
                                    vlsCalculator.backspace();
                                    break;
                                case "=":
                                    vlsCalculator.evaluate();
                                    break;
                                default:
                                    vlsCalculator.appendToken(modelData);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
