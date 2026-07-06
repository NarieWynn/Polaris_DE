cmake_minimum_required(VERSION 3.20)
project(polaris_settings VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)

find_package(Qt6 COMPONENTS Core Gui Qml Quick REQUIRED)

qt_policy(SET QTP0001 NEW)
qt_policy(SET QTP0004 NEW)

qt_add_executable(polaris_settings
        src/main.cpp
)

qt_add_qml_module(polaris_settings
        URI polaris
        VERSION 1.0
        QML_FILES
        qml/main.qml
        qml/components/WifiButton.qml
        qml/components/WifiSettings.qml
        qml/components/SoundSettings.qml
        qml/components/DisplaySettings.qml
        qml/components/AboutSettings.qml
        qml/components/ShortcutsSettings.qml
        qml/components/PowerSettings.qml
        qml/components/BluetoothSettings.qml
        qml/components/UsbSettings.qml
        qml/components/SharingSettings.qml
        qml/components/FirewallSettings.qml
        qml/components/SandboxSettings.qml
        qml/components/ComingSoon.qml
)

target_link_libraries(polaris_settings PRIVATE
        Qt6::Core
        Qt6::Gui
        Qt6::Qml
        Qt6::Quick
        polaris_shared
)