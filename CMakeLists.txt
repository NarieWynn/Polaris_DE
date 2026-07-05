cmake_minimum_required(VERSION 3.20)
project(PolarisDesktopEnvironment LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)

find_package(Qt6 COMPONENTS Core Qml Quick REQUIRED)
find_package(Vulkan)

if(Vulkan_FOUND)
    message(STATUS "Found Vulkan: Using Vulkan backend for optimal performance.")
    add_compile_definitions(HAS_VULKAN)
else()
    message(STATUS "No Vulkan found: Fallback to standard OpenGL/CPU rendering.")
endif()

add_subdirectory(modules/launcher)
add_subdirectory(modules/taskbar)
add_subdirectory(modules/settings)
add_subdirectory(shared)