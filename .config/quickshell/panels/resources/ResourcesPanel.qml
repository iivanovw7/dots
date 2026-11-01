
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
    id: root

    WlrLayershell.layer: WlrLayer.Bottom

    property string targetMonitor: "DVI-I-2"

    property var targetScreen: Quickshell.screens.find(
        s => s.name === root.targetMonitor
    )

    screen: root.targetScreen
    visible: root.targetScreen !== undefined &&
            root.targetScreen !== null

    implicitWidth: 290
    implicitHeight: 340

    anchors {
        top: true
        right: true
    }

    margins {
        top: 12
        right: 350
    }

    exclusiveZone: 0
    color: "transparent"

    property color bg: "#CC2D2A2E"
    property color borderColor: "#5B595C"
    property color textColor: "#FCFCFA"
    property color muted: "#B0B0B0"
    property color yellow: "#FFD866"
    property color green: "#A9DC76"
    property color cyan: "#78DCE8"
    property color purple: "#AB9DF2"
    property color pink: "#FF6188"
    property color orange: "#FC9867"
    property color barBg: "#48444A"

    property real cpu: 0
    property real memory: 0
    property real memoryUsed: 0
    property real memoryTotal: 0
    property real rxRate: 0
    property real txRate: 0
    property real temperature: -1
    property real disk: 0

    property double previousRx: -1
    property double previousTx: -1
    property double previousTime: 0

    property string cpuLabel: "—"
    property string memoryLabel: "—"
    property string downloadLabel: "—"
    property string uploadLabel: "—"
    property string temperatureLabel: "—"
    property string diskLabel: "—"

    property var topCpuProcesses: []
    property var topMemoryProcesses: []

    function formatRate(bytesPerSecond) {
        if (bytesPerSecond >= 1048576)
            return (bytesPerSecond / 1048576).toFixed(1) + " MB/s"

        if (bytesPerSecond >= 1024)
            return (bytesPerSecond / 1024).toFixed(0) + " KB/s"

        return bytesPerSecond.toFixed(0) + " B/s"
    }

    function handleMetrics(output) {
        const values = {}

        output.trim().split("\n").forEach(line => {
            const index = line.indexOf("=")

            if (index > 0) {
                values[line.substring(0, index)] =
                    line.substring(index + 1).trim()
            }
        })

        if (values.cpu !== undefined) {
            cpu = Number(values.cpu) || 0
            cpuLabel = Math.round(cpu) + "%"
        }

        if (values.memUsed !== undefined) {
            memoryUsed = Number(values.memUsed) || 0
            memoryTotal = Number(values.memTotal) || 0
            memory = Number(values.memPercent) || 0

            memoryLabel = memoryUsed.toFixed(1) + " / " +
                memoryTotal.toFixed(1) + " GB"
        }

        const now = Date.now()
        const rx = Number(values.rx) || 0
        const tx = Number(values.tx) || 0

        if (previousRx >= 0 && previousTx >= 0 &&
            previousTime > 0) {
            const elapsed = (now - previousTime) / 1000

            if (elapsed > 0) {
                rxRate = Math.max(0, (rx - previousRx) / elapsed)
                txRate = Math.max(0, (tx - previousTx) / elapsed)

                downloadLabel = formatRate(rxRate)
                uploadLabel = formatRate(txRate)
            }
        }

        previousRx = rx
        previousTx = tx
        previousTime = now

        if (values.temp !== undefined &&
            Number(values.temp) >= 0) {
            temperature = Number(values.temp)
            temperatureLabel = temperature.toFixed(0) + "°C"
        } else {
            temperature = -1
            temperatureLabel = "N/A"
        }

        if (values.disk !== undefined) {
            disk = Number(values.disk) || 0
            diskLabel = Math.round(disk) + "% used"
        }
    }

    function handleProcesses(output) {
        const cpuList = []
        const memList = []
        let section = ""

        output.trim().split("\n").forEach(line => {
            line = line.trim()

            if (line === "CPU" || line === "MEM") {
                section = line
                return
            }

            if (!line)
                return

            const parts = line.split("|")

            if (parts.length < 3)
                return

            const process = {
                name: parts[0],
                cpu: Number(parts[1]) || 0,
                mem: Number(parts[2]) || 0
            }

            if (section === "CPU")
                cpuList.push(process)
            else if (section === "MEM")
                memList.push(process)
        })

        topCpuProcesses = cpuList
        topMemoryProcesses = memList
    }

    Process {
        id: metricsProcess

        command: [
            "bash", "-c",
            "read cpu u n s idle iow irq sirq steal rest < /proc/stat; " +
            "t1=$((u+n+s+idle+iow+irq+sirq+steal)); " +
            "i1=$((idle+iow)); " +
            "sleep 0.5; " +
            "read cpu u n s idle iow irq sirq steal rest < /proc/stat; " +
            "t2=$((u+n+s+idle+iow+irq+sirq+steal)); " +
            "i2=$((idle+iow)); " +
            "awk -v t1=\"$t1\" -v i1=\"$i1\" -v t2=\"$t2\" -v i2=\"$i2\" " +
            "'BEGIN {d=t2-t1; if(d>0) printf \"cpu=%.1f\\n\", " +
            "100*(d-(i2-i1))/d; else print \"cpu=0\"}'; " +

            "awk '/MemTotal:/ {t=$2} /MemAvailable:/ {a=$2} " +
            "END {if(t>0) printf \"memUsed=%.2f\\nmemTotal=%.2f\\n" +
            "memPercent=%.1f\\n\", (t-a)/1048576, " +
            "t/1048576, 100*(t-a)/t}' /proc/meminfo; " +

            "awk 'BEGIN {rx=0;tx=0} " +
            "/:/ && $1 !~ /lo:/ {gsub(\":\", \"\", $1); " +
            "rx+=$2;tx+=$10} " +
            "END {printf \"rx=%.0f\\ntx=%.0f\\n\",rx,tx}' " +
            "/proc/net/dev; " +

            "temp=0; " +
            "for f in /sys/class/thermal/thermal_zone*/temp /sys/class/hwmon/hwmon*/temp*_input; do " +
            "if [ -r \"$f\" ]; then " +
            "read v < \"$f\"; " +
            "if [ \"$v\" -gt 0 ] 2>/dev/null; then " +
            "if [ \"$v\" -gt 1000 ]; then v=$((v/1000)); fi; " +
            "if [ \"$v\" -gt \"$temp\" ]; then temp=$v; fi; " +
            "fi; fi; done; " +
            "printf 'temp=%s\\n' \"$temp\"; " +

            "df -P / | awk 'NR==2 {gsub(\"%\", \"\", $5); " +
            "printf \"disk=%s\\n\", $5}'"
        ]

        stdout: StdioCollector {
            onStreamFinished: root.handleMetrics(this.text)
        }
    }

    // Five busiest processes by CPU and memory
    Process {
        id: processListProcess

        command: [
            "bash", "-c",
            "printf 'CPU\\n'; " +
            "ps -eo comm=,pcpu=,pmem= --sort=-pcpu | " +
            "head -n 5 | " +
            "awk '{printf \"%s|%.1f|%.1f\\n\", $1, $2, $3}'; " +
            "printf 'MEM\\n'; " +
            "ps -eo comm=,pcpu=,pmem= --sort=-pmem | " +
            "head -n 5 | " +
            "awk '{printf \"%s|%.1f|%.1f\\n\", $1, $2, $3}'"
        ]

        stdout: StdioCollector {
            onStreamFinished: root.handleProcesses(this.text)
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true

        onTriggered: {
            if (!metricsProcess.running)
                metricsProcess.running = true

            if (!processListProcess.running)
                processListProcess.running = true
        }
    }

    Component.onCompleted: {
        metricsProcess.running = true
        processListProcess.running = true
    }

    Rectangle {
        anchors.fill: parent
        color: root.bg
        border.color: root.borderColor
        border.width: 1
        radius: 0

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 11
            spacing: 7

            // Header
            RowLayout {
                Layout.fillWidth: true
                spacing: 7

                RowLayout {
                    spacing: 7

                    Rectangle {
                        Layout.preferredWidth: 3
                        Layout.preferredHeight: 22
                        color: root.yellow
                    }

                    ColumnLayout {
                        spacing: 1

                        Text {
                            text: "SYSTEM"
                            color: root.textColor
                            font.family: "monospace"
                            font.pixelSize: 13
                            font.bold: true
                        }

                        Text {
                            text: "LIVE HARDWARE STATUS"
                            color: root.muted
                            font.family: "monospace"
                            font.pixelSize: 9
                        }
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                Text {
                    text: "● LIVE"
                    color: root.green
                    font.family: "monospace"
                    font.pixelSize: 9
                    Layout.alignment: Qt.AlignVCenter
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: root.borderColor
            }

            // CPU usage
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 3

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: "CPU"
                        color: root.textColor
                        font.family: "monospace"
                        font.pixelSize: 10
                        font.bold: true
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Text {
                        text: root.cpuLabel
                        color: root.yellow
                        font.family: "monospace"
                        font.pixelSize: 11
                        font.bold: true
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 5
                    color: root.barBg

                    Rectangle {
                        width: parent.width *
                            Math.max(0, Math.min(100, root.cpu)) / 100
                        height: parent.height
                        color: root.yellow
                    }
                }
            }

            // Memory usage
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 3

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: "MEMORY"
                        color: root.textColor
                        font.family: "monospace"
                        font.pixelSize: 10
                        font.bold: true
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Text {
                        text: root.memoryLabel
                        color: root.green
                        font.family: "monospace"
                        font.pixelSize: 10
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 5
                    color: root.barBg

                    Rectangle {
                        width: parent.width *
                            Math.max(0, Math.min(100, root.memory)) / 100
                        height: parent.height
                        color: root.green
                    }
                }
            }

            // Network throughput
            GridLayout {
                Layout.fillWidth: true
                columns: 2
                columnSpacing: 8
                rowSpacing: 5

                Rectangle {
                    Layout.fillWidth: true
                    color: "transparent"
                    border.color: root.borderColor
                    border.width: 1
                    implicitHeight: 24

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 6
                        spacing: 3

                        Text {
                            text: "↓ DOWNLOAD"
                            color: root.cyan
                            font.family: "monospace"
                            font.pixelSize: 9
                        }

                        Text {
                            text: root.downloadLabel
                            color: root.textColor
                            font.family: "monospace"
                            font.pixelSize: 11
                            font.bold: true
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    color: "transparent"
                    border.color: root.borderColor
                    border.width: 1
                    implicitHeight: 24

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 6
                        spacing: 3

                        Text {
                            text: "↑ UPLOAD"
                            color: root.purple
                            font.family: "monospace"
                            font.pixelSize: 9
                        }

                        Text {
                            text: root.uploadLabel
                            color: root.textColor
                            font.family: "monospace"
                            font.pixelSize: 11
                            font.bold: true
                        }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "CPU TEMP"
                    color: root.orange
                    font.family: "monospace"
                    font.pixelSize: 10
                }

                Item {
                    Layout.fillWidth: true
                }

                Text {
                    text: root.temperatureLabel
                    color: root.textColor
                    font.family: "monospace"
                    font.pixelSize: 11
                    font.bold: true
                }
            }

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "ROOT DISK"
                    color: root.muted
                    font.family: "monospace"
                    font.pixelSize: 10
                }

                Item {
                    Layout.fillWidth: true
                }

                Text {
                    text: root.diskLabel
                    color: root.textColor
                    font.family: "monospace"
                    font.pixelSize: 10
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: root.borderColor
            }

            GridLayout {
                Layout.fillWidth: true
                columns: 2
                columnSpacing: 10
                rowSpacing: 4

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4

                    Text {
                        text: "CPU"
                        color: root.yellow
                        font.family: "monospace"
                        font.pixelSize: 10
                        font.bold: true
                    }

                    Repeater {
                        model: root.topCpuProcesses

                        delegate: ColumnLayout {
                            required property var modelData

                            Layout.fillWidth: true
                            spacing: 2

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 3

                                Text {
                                    Layout.fillWidth: true
                                    text: modelData.name
                                    color: root.textColor
                                    font.family: "monospace"
                                    font.pixelSize: 9
                                    elide: Text.ElideRight
                                }

                                Text {
                                    text: modelData.cpu.toFixed(1) + "%"
                                    color: root.yellow
                                    font.family: "monospace"
                                    font.pixelSize: 9
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 3
                                color: root.barBg

                                Rectangle {
                                    width: parent.width *
                                        Math.max(0, Math.min(
                                            100, modelData.cpu)) / 100
                                    height: parent.height
                                    color: root.yellow
                                }
                            }
                        }
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4

                    Text {
                        text: "MEM"
                        color: root.green
                        font.family: "monospace"
                        font.pixelSize: 10
                        font.bold: true
                    }

                    Repeater {
                        model: root.topMemoryProcesses

                        delegate: ColumnLayout {
                            required property var modelData

                            Layout.fillWidth: true
                            spacing: 2

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 3

                                Text {
                                    Layout.fillWidth: true
                                    text: modelData.name
                                    color: root.textColor
                                    font.family: "monospace"
                                    font.pixelSize: 9
                                    elide: Text.ElideRight
                                }

                                Text {
                                    text: modelData.mem.toFixed(1) + "%"
                                    color: root.green
                                    font.family: "monospace"
                                    font.pixelSize: 9
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 3
                                color: root.barBg

                                Rectangle {
                                    width: parent.width *
                                        Math.max(0, Math.min(
                                            100, modelData.mem)) / 100
                                    height: parent.height
                                    color: root.green
                                }
                            }
                        }
                    }
                }
            }

            Item {
                Layout.fillHeight: true
                Layout.minimumHeight: 0
            }
        }
    }
}
