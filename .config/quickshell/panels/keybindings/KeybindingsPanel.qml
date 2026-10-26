import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    WlrLayershell.layer: WlrLayer.Bottom

    implicitWidth: 330
    implicitHeight: 530

    anchors {
        top: true
        right: true
    }

    margins {
        top: 12
        right: 8
    }

    exclusiveZone: 0
    color: "transparent"

    property string targetMonitor: "DVI-I-2"

    property var targetScreen: Quickshell.screens.find(
        s => s.name === root.targetMonitor
    )

    screen: root.targetScreen
    visible: root.targetScreen !== undefined &&
            root.targetScreen !== null

    property color backgroundColor: "#CC2D2A2E"
    property color secondaryBackground: "#B0B0B0"
    property color textColor: "#FCFCFA"
    property color borderColor: "#5B595C"
    property color focusedColor: "#FFD866"
    property color focusedGreen: "#A9DC76"
    property color cyanColor: "#78DCE8"
    property color purpleColor: "#AB9DF2"
    property color pinkColor: "#FF6188"
    property color orangeColor: "#FC9867"

    property var shortcuts: [
        { section: "NAVIGATION" },
        { key: "j", action: "Move down" },
        { key: "k", action: "Move up" },
        { key: "PgUp", action: "Page up" },
        { key: "PgDn", action: "Page down" },
        { key: "-", action: "Go to parent directory" },
        { key: "Enter", action: "Open / confirm" },
        { key: "Esc", action: "Cancel input" },
        { key: "/", action: "Search files" },

        { section: "FILE PANELS" },
        { key: "n", action: "Create new panel" },
        { key: "q", action: "Close panel" },
        { key: "Tab", action: "Next panel" },
        { key: "Shift+Tab", action: "Previous panel" },
        { key: "N", action: "Split panel" },
        { key: "f", action: "Preview file" },
        { key: "o", action: "Change sort order" },
        { key: "R", action: "Reverse sort order" },
        { key: "m", action: "Toggle panel mode" },

        { section: "FILE OPERATIONS" },
        { key: "a", action: "Create file / folder" },
        { key: "r", action: "Rename item" },
        { key: "y", action: "Copy selected items" },
        { key: "x", action: "Cut selected items" },
        { key: "p", action: "Paste items" },
        { key: "d", action: "Delete item" },
        { key: "D", action: "Permanently delete" },
        { key: "Y", action: "Copy item path" },
        { key: "c", action: "Copy current directory" },
        { key: "Ctrl+E", action: "Extract archive" },
        { key: "Ctrl+A", action: "Compress items" },

        { section: "FOCUS & PANELS" },
        { key: "Ctrl+P", action: "Toggle process bar" },
        { key: "Ctrl+S", action: "Toggle sidebar" },
        { key: "Ctrl+D", action: "Toggle metadata" },
        { key: "Ctrl+F", action: "Toggle footer" },
        { key: ".", action: "Show hidden files" },

        { section: "OTHER ACTIONS" },
        { key: "e", action: "Open file in editor" },
        { key: "E", action: "Edit current directory" },
        { key: "P", action: "Open pinned directories" },
        { key: "z", action: "Open Zoxide" },
        { key: ">", action: "Open prompt" },
        { key: ":", action: "Open command line" },
        { key: "?", action: "Show help" },
        { key: "Q", action: "Quit to directory" },
        { key: "Ctrl+C", action: "Quit Superfile" },

        { section: "SELECTION" },
        { key: "J", action: "Select downward" },
        { key: "K", action: "Select upward" },
        { key: "A", action: "Select all items" },

        { section: "INPUT" },
        { key: "Enter", action: "Confirm input" },
        { key: "Esc", action: "Cancel input" }
    ]

    Rectangle {
        anchors.fill: parent
        color: root.backgroundColor
        border.color: root.borderColor
        border.width: 1
        radius: 0

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 4

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 3

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 7

                    Rectangle {
                        width: 3
                        height: 21
                        color: root.focusedColor
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0

                        Text {
                            text: "SUPERFILE"
                            color: root.textColor
                            font.family: "monospace"
                            font.pixelSize: 14
                            font.bold: true
                        }

                        Text {
                            text: "KEYBINDING REFERENCE"
                            color: root.secondaryBackground
                            font.family: "monospace"
                            font.pixelSize: 9
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: root.borderColor
                }
            }

            ListView {
                id: bindingList

                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 0
                model: root.shortcuts
                boundsBehavior: Flickable.StopAtBounds

                delegate: Item {
                    id: bindingDelegate

                    required property var modelData

                    width: bindingList.width
                    height: modelData.section !== undefined ? 16 : 14

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 1
                        anchors.verticalCenter: parent.verticalCenter

                        visible: bindingDelegate.modelData.section !== undefined
                        text: bindingDelegate.modelData.section || ""

                        color: root.focusedGreen
                        font.family: "monospace"
                        font.pixelSize: 9
                        font.bold: true
                    }

                    RowLayout {
                        anchors.fill: parent
                        spacing: 9

                        visible: bindingDelegate.modelData.section === undefined

                        Text {
                            Layout.preferredWidth: 65
                            text: bindingDelegate.modelData.key || ""
                            color: root.focusedColor
                            font.family: "monospace"
                            font.pixelSize: 10
                            font.bold: true
                            verticalAlignment: Text.AlignVCenter
                        }

                        Text {
                            Layout.fillWidth: true
                            text: bindingDelegate.modelData.action || ""
                            color: root.textColor
                            font.family: "monospace"
                            font.pixelSize: 10
                            elide: Text.ElideRight
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: root.borderColor
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 4

                Item {
                    Layout.fillWidth: true
                }

                Text {
                    text: root.shortcuts.filter(
                        item => item.section === undefined
                    ).length + " SHORTCUTS"
                    color: root.secondaryBackground
                    font.family: "monospace"
                    font.pixelSize: 9
                }
            }
        }
    }
}
