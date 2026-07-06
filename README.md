# Polaris Desktop Environment

A lightweight Desktop Environment shell built from scratch with **C++23** and **Qt6/QML**,
targeting **Hyprland/Wayland**. Polaris is designed as a daily-driver DE replacement
and a portfolio project demonstrating real-world Qt6 application development.

---

## Screenshots

> *(Add screenshots later)*

---

## Modules

Polaris is split into independent executables — each module is a separate process:

| Module | Description |
|--------|-------------|
| `polaris_launcher` | App launcher with fuzzy search and built-in command interpreter |
| `polaris_taskbar` | System tray bar pinned to screen via Wayland layer-shell |
| `polaris_settings` | Settings panel (WIP) |

---

## Features

### Launcher
- Reads installed applications from `.desktop` files (XDG standard)
- Real-time search/filter via `QSortFilterProxyModel`
- Launches apps via `QProcess`
- **Built-in Command Interpreter** — custom shell commands:
    - `volume <0-100>` — set audio volume via PipeWire/PulseAudio
    - `brightness <0-100>` — set screen brightness via brightnessctl
    - `find <term>` — fast file search via `fd`
    - `create <path>` — create files/folders directly from launcher
    - `help` — list all available commands

### Taskbar
- Pinned to screen edge via **Wayland layer-shell protocol** (LayerShellQt)
- Real-time system info:
    - 🕐 Clock & Date — updates every minute
    - 🔋 Battery — reads from `/sys/class/power_supply/`
    - 📶 Wifi — NetworkManager integration via `nmcli`
    - 🖥️ Workspace Indicator — real-time Hyprland IPC via socket
- **Wifi Popup Window** — scan nearby networks, connect/disconnect, password input

---

## Architecture

Polaris follows a strict **C++ Backend / QML Frontend** separation:
```
┌─────────────────────────────────────────────┐
│                  QML Layer                   │
│   (UI, animations, layout, user interaction) │
│                                              │
│  main.qml → components/*.qml                │
└──────────────────┬──────────────────────────┘
│  Q_PROPERTY (data binding)
│  Q_INVOKABLE (method calls)
│  Signals/Slots
┌──────────────────┴──────────────────────────┐
│               C++ Backend Layer              │
│   (system data, business logic, APIs)        │
│                                              │
│  AppModel      → reads .desktop files        │
│  BatteryManager→ reads /sys/class/           │
│  WifiManager   → calls nmcli                 │
│  ClockManager  → QDateTime + QTimer          │
│  WorkspaceManager → Hyprland IPC socket      │
│  CommandInterpreter → custom shell commands  │
└──────────────────┬──────────────────────────┘
│
┌──────────────────┴──────────────────────────┐
│              System Layer                    │
│                                              │
│  Wayland / layer-shell protocol              │
│  Linux sysfs (/sys/class/power_supply/)      │
│  NetworkManager (nmcli)                      │
│  Hyprland IPC ($XDG_RUNTIME_DIR/hypr/)       │
│  PipeWire/PulseAudio (pactl)                 │
└─────────────────────────────────────────────┘
```
### Key Design Decisions

**Why Qt6/QML?**
Qt6/QML is the industry standard for automotive HMI (Human-Machine Interface)
development — used by Mercedes, BMW, Volvo for in-car infotainment systems.
Building a real DE with Qt6 directly mirrors the tech stack used in production
automotive software.

**Why separate executables per module?**
Each component (launcher, taskbar) has a different lifecycle:
- Taskbar runs continuously as a layer-shell surface
- Launcher spawns on-demand via keybind

**Why Wayland layer-shell?**
Regular windows are managed by the compositor (Hyprland) — position, opacity,
and z-order can be overridden. Layer-shell gives Polaris direct control over
its own rendering without compositor interference, enabling true transparency,
precise positioning, and always-on-top behavior.

**Why custom CommandInterpreter instead of alias?**
Aliases go through shell parsing overhead. Polaris CommandInterpreter calls
system APIs directly from C++ — no shell spawning, no alias lookup,
faster execution.

---

## Tech Stack

- **Language**: C++23, QML (Qt Quick)
- **Framework**: Qt6 — QtCore, QtGui, QtQml, QtQuick, QtDBus
- **Wayland**: LayerShellQt (layer-shell protocol binding for Qt)
- **Build System**: CMake 3.20+
- **Target**: Hyprland / any wlr-layer-shell compatible Wayland compositor

---

## Building

### Dependencies
```bash
# Arch/CachyOS
paru -S qt6-base qt6-declarative qt6-wayland layer-shell-qt
# Optional
paru -S brightnessctl fd
```

### Build
```bash
git clone https://github.com/NarieWynn/Polaris_DE
cd Polaris
cmake -B cmake-build-release -DCMAKE_BUILD_TYPE=Release
cmake --build cmake-build-release
```

### Run
```bash
# Taskbar (add to Hyprland autostart)
./cmake-build-release/modules/taskbar/polaris_taskbar

# Launcher (bind to a key in Hyprland)
./cmake-build-release/modules/launcher/polaris_launcher
```

---

```
Polaris/
├── modules/
│   ├── launcher/
│   │   ├── src/
│   │   │   ├── appmodel.h/.cpp
│   │   │   └── commandinterpreter.h/.cpp
│   │   └── qml/
│   │       ├── main.qml
│   │       └── components/
│   │           ├── AppLauncher.qml
│   │           └── SearchBar.qml
│   ├── taskbar/
│   │   ├── src/
│   │   │   ├── clock.h/.cpp
│   │   │   ├── battery.h/.cpp
│   │   │   ├── workspace.h/.cpp
│   │   │   └── wifi.h/.cpp
│   │   └── qml/
│   │       ├── main.qml
│   │       ├── WifiPopupWindow.qml
│   │       └── components/
│   │           ├── Clock.qml
│   │           ├── Battery.qml
│   │           ├── WifiIndicator.qml
│   │           ├── WifiPopup.qml
│   │           └── WorkspaceIndicator.qml
│   └── settings/
└── shared/
    └── network/
        └── wifi.h/.cpp
```
---

## Roadmap

- [x] App Launcher with search
- [x] Custom command interpreter
- [x] Taskbar with layer-shell
- [x] Battery, Clock, Wifi indicators
- [x] Workspace indicator (Hyprland IPC)
- [x] Wifi popup with connect/disconnect
- [ ] Notification daemon
- [ ] Volume/Brightness popup
- [ ] Settings panel
- [ ] Dynamic theming from wallpaper

---

## Author

**Huynh Ngoc Nguyen** — CS Student at HCMIU, VNU-HCM  
Interested in automotive UI development with Qt6/QML