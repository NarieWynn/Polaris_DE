cmake_minimum_required(VERSION 3.20)
project(Polaris VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)


if(POLICY QTP0001)
    cmake_policy(SET QTP0001 NEW)
endif()

find_package(Qt6 COMPONENTS Core Gui Qml Quick REQUIRED)


file(GLOB_RECURSE SOURCE_FILES CONFIGURE_DEPENDS "src/*.cpp")


file(GLOB_RECURSE ABSOLUTE_QML_FILES CONFIGURE_DEPENDS "qml/*.qml")


set(QML_FILES)
foreach(file_path ${ABSOLUTE_QML_FILES})
    file(RELATIVE_PATH relative_file ${CMAKE_CURRENT_SOURCE_DIR} ${file_path})
    list(APPEND QML_FILES ${relative_file})
endforeach()


add_executable(Polaris ${SOURCE_FILES})


qt_add_qml_module(Polaris
        URI Polaris
        VERSION 1.0
        QML_FILES ${QML_FILES}
)

target_link_libraries(Polaris PRIVATE
        Qt6::Core
        Qt6::Gui
        Qt6::Qml
        Qt6::Quick
)