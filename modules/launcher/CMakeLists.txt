cmake_minimum_required(VERSION 3.20)
project(polaris_launcher VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)

if(POLICY QTP0001)
    cmake_policy(SET QTP0001 NEW)
endif()
if(POLICY QTP0004)
    cmake_policy(SET QTP0004 NEW)
endif()

find_package(Qt6 COMPONENTS Core Gui Qml Quick REQUIRED)

add_executable(polaris_launcher
        src/main.cpp
)


qt_add_qml_module(polaris_launcher
        URI polaris
        VERSION 1.0
        QML_FILES
        qml/main.qml
        qml/AppLauncher.qml
)

target_link_libraries(polaris_launcher PRIVATE
        Qt6::Core
        Qt6::Gui
        Qt6::Qml
        Qt6::Quick
)