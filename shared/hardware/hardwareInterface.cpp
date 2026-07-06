#include "hardwareInterface.h"
#include <unistd.h>
#include <sys/wait.h>
#include <string>
#include <fstream>
#include <cstdio>
#include <iostream>
#include <filesystem>

namespace fs = std::filesystem;

HardwareInterface::HardwareInterface(QObject *parent) : QObject(parent) {
    syncFromSystem();
}

void HardwareInterface::syncFromSystem() {
    std::string basePath = "/sys/class/backlight/";
    std::string actualPath = "";

    try {
        if (fs::exists(basePath) && !fs::is_empty(basePath)) {
            for (const auto& entry : fs::directory_iterator(basePath)) {
                actualPath = entry.path().string() + "/";
                break;
            }
        }
    } catch (...) {
        actualPath = "";
    }

    if (!actualPath.empty()) {
        std::ifstream bFile(actualPath + "brightness");
        std::ifstream mFile(actualPath + "max_brightness");

        if (bFile.is_open() && mFile.is_open()) {
            int currentB = 0, maxB = 1;
            bFile >> currentB;
            mFile >> maxB;
            if (maxB > 0) {
                m_brightness = (currentB * 100) / maxB;
            }
            bFile.close();
            mFile.close();
        }
    } else {
        m_brightness = 50;
    }

    FILE* pipe = popen("pactl get-sink-volume @DEFAULT_SINK@", "r");
    if (pipe) {
        char buffer[128];
        std::string result = "";
        while (fgets(buffer, sizeof(buffer), pipe) != nullptr) {
            result += buffer;
        }
        pclose(pipe);

        size_t pctPos = result.find('%');
        if (pctPos != std::string::npos) {
            size_t startPos = pctPos;
            while (startPos > 0 && result[startPos - 1] != ' ') {
                startPos--;
            }
            try {
                m_volume = std::stoi(result.substr(startPos, pctPos - startPos));
            } catch (...) {
                m_volume = 50;
            }
        }
    } else {
        m_volume = 50;
    }
}

void HardwareInterface::executeCommand(const char* program, char* const argv[]) {
    pid_t pid = fork();

    if (pid == 0) {
        execvp(program, argv);
        _exit(127);
    }
    else if (pid > 0) {
        int status;
        waitpid(pid, &status, WNOHANG);
    }
}

void HardwareInterface::setVolume(int val) {
    if (val < 0) val = 0;
    if (val > 100) val = 100;
    if (m_volume != val) {
        m_volume = val;
        updateSystemVolume();
        emit volumeChanged(m_volume);
    }
}

void HardwareInterface::adjustVolume(int delta) {
    setVolume(m_volume + delta);
}

void HardwareInterface::updateSystemVolume() {
    std::string volStr = std::to_string(m_volume) + "%";
    char* const args[] = {
        const_cast<char*>("pactl"),
        const_cast<char*>("set-sink-volume"),
        const_cast<char*>("@DEFAULT_SINK@"),
        const_cast<char*>(volStr.c_str()),
        nullptr
    };

    executeCommand("pactl", args);
}

void HardwareInterface::setBrightness(int val) {
    if (val < 0) val = 0;
    if (val > 100) val = 100;
    if (m_brightness != val) {
        m_brightness = val;
        updateSystemBrightness();
        emit brightnessChanged(m_brightness);
    }
}

void HardwareInterface::adjustBrightness(int delta) {
    setBrightness(m_brightness + delta);
}

void HardwareInterface::updateSystemBrightness() {
    std::string brightStr = std::to_string(m_brightness) + "%";
    char* const args[] = {
        const_cast<char*>("brightnessctl"),
        const_cast<char*>("set"),
        const_cast<char*>(brightStr.c_str()),
        nullptr
    };

    executeCommand("brightnessctl", args);
}