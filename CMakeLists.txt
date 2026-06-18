cmake_minimum_required(VERSION 3.20)

project(PolarisDesktopEnvironment LANGUAGES CXX)

find_package(Vulkan REQUIRED)

if(Vulkan_FOUND)
    message(STATUS "Found Vulkan: Using Vulkan backend for optimal performance.")
    add_compile_definitions(HAS_VULKAN)
else()
    message(STATUS "No Vulkan found: Fallback to standard OpenGL/CPU rendering.")
endif()

add_subdirectory(modules/launcher)