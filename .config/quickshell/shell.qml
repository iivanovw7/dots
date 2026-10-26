
import Quickshell
import "panels/keybindings"
import "panels/resources"

ShellRoot {
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
