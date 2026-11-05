import QtQuick
import Quickshell
import "panels/keybindings"
import "panels/resources"

ShellRoot {
    QtObject {
        id: themeFont
        readonly property string family: "JetBrainsMono Nerd Font"
        readonly property int size: 12
    }

    KeybindingsPanel {
        targetMonitor: "DVI-I-2"
    }

    KeybindingsPanel {
        targetMonitor: "eDP-1"
    }

    ResourcesPanel {
        targetMonitor: "DVI-I-2"
    }

    ResourcesPanel {
        targetMonitor: "eDP-1"
    }
}
