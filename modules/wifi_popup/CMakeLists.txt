cmake_minimum_required(VERSION 3.20)
project(polaris_wifi_popup VERSION 1.0.0 LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)

find_package(Qt6 COMPONENTS Core Gui Qml Quick DBus REQUIRED)
find_package(LayerShellQt REQUIRED)

qt_policy(SET QTP0001 NEW)
qt_policy(SET QTP0004 NEW)

qt_add_executable(polaris_wifi_popup
        src/main.cpp
)

qt_add_qml_module(polaris_wifi_popup
        URI polaris
        VERSION 1.0
        QML_FILES
        qml/main.qml
        qml/components/WifiList.qml
)

target_link_libraries(polaris_wifi_popup PRIVATE
        Qt6::Core
        Qt6::Gui
        Qt6::Qml
        Qt6::Quick
        Qt6::DBus
        LayerShellQt::Interface
        polaris_shared
)