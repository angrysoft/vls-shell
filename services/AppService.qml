pragma Singleton
import Quickshell
import Quickshell.Io

Singleton {
    id: appService
    property bool calculator: false
    

    IpcHandler {
        target: "app"
        function launch(apps: string) {
            if (apps === "calculator") {
                calculator = true;
            }
        }

        function close(name: string) {
            if (name === "calculator") {
                appService.calculator = false;
            }
        }

        function list() {
            return JSON.stringify([
                {
                    app: "calculator",
                    active: appService.calculator
                }
            ]);
        }
    }
}
