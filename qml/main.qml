import QtQuick
import QtQuick.Controls

Window {
    id: root
    width: 500
    height: 600
    visible: true
    title: "Polaris App Launcher"

    // 1. Tạo màu nền tối (Dark mode) sang trọng cho Launcher
    color: "#1e1e2e"

    // 2. Định hình bố cục sắp xếp các thành phần theo chiều dọc (Từ trên xuống dưới)
    Column {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        // 3. Ô nhập liệu để người dùng gõ từ khóa tìm kiếm app
        TextField {
            id: searchField
            width: parent.width
            height: 50
            placeholderText: "Search apps..."

            // Trang trí cho ô tìm kiếm
            background: Rectangle {
                color: "#313244"
                radius: 8 // Bo góc 8 pixel cho đúng gu ricing
            }
            color: "white" // Chữ gõ vào màu trắng
            font.pointSize: 14
            focus: true // Tự động nhảy con trỏ chuột vào đây khi bật launcher
        }

        // 4. Dòng chữ tạm thời hiển thị những gì bạn đang gõ (Để test tính năng)
        Text {
            text: "You are searching for: " + searchField.text
            color: "#a6adc8"
            font.pointSize: 12
        }
    }
}
