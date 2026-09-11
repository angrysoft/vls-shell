//@ pragma ShellId vls-shell
//@ pragma UseQApplication
//@ pragma IconTheme Papirus
//@ pragma NativeTextRendering

import QtQuick
import QtQuick.Controls.Material
import Quickshell
import Quickshell.Io
import qs.config
import qs.modules.bar
import qs.modules.launcher
import qs.modules.notifications
import qs.modules.wallpaper
import qs.modules.session
import qs.modules.lock
import qs.app.calculator
import qs.services
import qs.theme

ShellRoot {
    id: shellRoot
  
    Material.theme: Material.System // Or Material.Light / Material.Dark
    Material.accent: Theme.colors.primary // M3 Primary key color
    Material.background: Theme.colors.primary_container // Filled button container color
    Material.foreground: Theme.colors.on_primary_container // On-primary text color
    Material.elevation: button.down ? 0 : 1

    LazyLoader {
        active: Config.modules.bar.enabled
        component: Bar {}
    }

    LazyLoader {
        active: Config.modules.wallpaper.enabled
        component: Wallpaper {}
    }

    Notifications {}

    Launcher {}

    // LazyLoader {
    //     active: Config.modules.session.enabled
    //     component: Session {}
    // }

    LazyLoader {
        active: Config.modules.session.enabled
        component: ScreenLock {}
    }

    LazyLoader {
        id: calculatorLoader    
        active: AppService.calculator
        component: Calculator {
        }
    }

    // Component.onCompleted: {
    //     // 1. Odczytaj zmienną LANG z systemu
    //     let langEnv = Quickshell.env("LANG") ?? "en_US";
        
    //     // 2. Wyciągnij sam kod języka (np. z "pl_PL.UTF-8" wyciągnij "pl_PL")
    //     let sysLang = langEnv.split(".")[0];

    //     console.log("Wykryto język systemowy z LANG:", sysLang, langEnv);

    //     // 3. Ustaw Qt.uiLanguage - to powiadomi wszystkie qsTr() w QML
    //     I18n.locale = sysLang;
    //     Qt.uiLanguage = sysLang;
    // }
}
