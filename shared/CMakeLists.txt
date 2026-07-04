cmake_minimum_required(VERSION 3.20)
project(polaris_shared LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Core DBus)

add_library(polaris_shared SHARED
        network/wifi.cpp

)

target_include_directories(polaris_shared PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}
        ${CMAKE_CURRENT_SOURCE_DIR}/network

)

target_link_libraries(polaris_shared PUBLIC
        Qt6::Core
        Qt6::DBus
)

set_target_properties(polaris_shared PROPERTIES POSITION_INDEPENDENT_CODE ON)