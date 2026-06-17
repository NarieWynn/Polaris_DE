cmake_minimum_required(VERSION 3.20)
project(Polaris VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)

# 🤫 VÁ LỖI WARNING POLICY: Bật policy QTP0001 để tắt cái warning phiền phức của Qt6
if(POLICY QTP0001)
    cmake_policy(SET QTP0001 NEW)
endif()

find_package(Qt6 COMPONENTS Core Gui Qml Quick REQUIRED)

# 🪄 TỰ ĐỘNG QUÉT C++: Tự nhận file mới trong src/ khi bấm Build
file(GLOB_RECURSE SOURCE_FILES CONFIGURE_DEPENDS "src/*.cpp")

# 🪄 TỰ ĐỘNG QUÉT QML: Quét lấy đường dẫn (nhưng lúc này đang là đường dẫn tuyệt đối)
file(GLOB_RECURSE ABSOLUTE_QML_FILES CONFIGURE_DEPENDS "qml/*.qml")

# 🔥 VŨ KHÍ BẺ ĐƯỜNG DẪN: Chuyển toàn bộ đường dẫn tuyệt đối thành tương đối cho thằng Qt6 vừa lòng!
set(QML_FILES)
foreach(file_path ${ABSOLUTE_QML_FILES})
    file(RELATIVE_PATH relative_file ${CMAKE_CURRENT_SOURCE_DIR} ${file_path})
    list(APPEND QML_FILES ${relative_file})
endforeach()

# Tạo file thực thi từ đống file C++
add_executable(Polaris ${SOURCE_FILES})

# 🚀 VŨ KHÍ TỐI TÂN QT6: Nạp đống QML_FILES đã được làm sạch đường dẫn tương đối!
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