#include "commandinterpreter.h"
#include <QProcess>
#include <QStandardPaths>
#include <QDir>
#include <QFile>
#include <QFileInfo>
CommandInterpreter::CommandInterpreter(QObject *parent) : QObject(parent) {}

void CommandInterpreter::execute(const QString &input) {
    QString cleaned = input.trimmed();
    if (cleaned.startsWith(">")) cleaned = cleaned.mid(1).trimmed();
    if (cleaned.isEmpty()) return;

    m_history.append(cleaned);
    emit historyChanged();

    QStringList parts = cleaned.split(' ', Qt::SkipEmptyParts);
    QString cmd = parts[0].toLower();
    QStringList args = parts.mid(1);

    if (cmd == "volume" || cmd == "vol") handleVolume(args);
    else if (cmd == "brightness" || cmd == "br") handleBrightness(args);
    else if (cmd == "find") handleFind(args);
    else if (cmd == "create") handleCreate(args);
    else if (cmd == "help" || cmd == "?" || cmd == "list") {
        emit resultText("Commands List:\n"
                        "  • volume or vol <0-100> : Set audio volume\n"
                        "  • brightness or br <0-100> : Set screen brightness\n"
                        "  • find : find file or folder\n"
                        "  • help / ? : Show this command list");
    }
    else emit resultText("Unknown command: " + cmd + ". Type 'help' or '?' for commands list");
}

QStringList CommandInterpreter::history() const { return m_history; }

bool CommandInterpreter::waitingForConfirm() const { return m_waitingForConfirm; }

QVariantMap CommandInterpreter::parse(const QString &input) {
    QString cleaned = input.trimmed();
    if (cleaned.startsWith(">")) cleaned = cleaned.mid(1).trimmed();

    QStringList parts = cleaned.split(' ', Qt::SkipEmptyParts);
    QVariantMap result;

    if (parts.isEmpty()) return result;

    result["command"] = parts[0].toLower();
    result["args"] = parts.mid(1);
    return result;
}

void CommandInterpreter::handleVolume(const QStringList &args) {
    if (args.isEmpty()) {
        QVariantMap data;
        emit commandType("volume", data);
        return;
    }

    int level = args[0].toInt();
    if (level < 0 || level > 100) {
        emit resultText("Error: volume must be between 0 and 100");
        return;
    }

    QProcess::startDetached("pactl", {
        "set-sink-volume", "@DEFAULT_SINK@",
        QString::number(level) + "%"
    });
    emit resultText(QString("Volume set to %1%").arg(level));
}

void CommandInterpreter::handleBrightness(const QStringList &args) {
    QString brightnessctlPath = QStandardPaths::findExecutable("brightnessctl");
    if (brightnessctlPath.isEmpty()) {
        emit resultText("brightnessctl not found.\nInstall it via terminal: paru -S brightnessctl");
        return;
    }

    if (args.isEmpty()) {
        emit resultText("Usage: brightness <0-100>");
        return;
    }

    int level = args[0].toInt();
    if (level < 0 || level > 100) {
        emit resultText("Error: brightness must be between 0 and 100");
        return;
    }

    QProcess::startDetached("brightnessctl", {"set", QString::number(level) + "%"});
    emit resultText(QString("Brightness set to %1%").arg(level));
}

void CommandInterpreter::handleFind(const QStringList &args) {
    QString fdPath = QStandardPaths::findExecutable("fd");
    if (fdPath.isEmpty()) {
        emit resultText("Error: 'fd' not found. Run: paru -S fd");
        return;
    }

    if (args.isEmpty()) {
        emit resultText("Usage: find <search_term>");
        return;
    }

    QString searchTerm = args[0];
    emit resultText("🔍 Searching for: " + searchTerm + "...");

    auto *proc = new QProcess(this); // NOLINT

    auto hasResults = std::make_shared<bool>(false);

    connect(proc, &QProcess::readyReadStandardOutput, [this, proc, hasResults]() {
        QString output = proc->readAllStandardOutput();
        if (!output.isEmpty()) {
            *hasResults = true;
            emit resultText(output.trimmed());
        }
    });

    connect(proc, &QProcess::finished, [this, proc, hasResults](int exitCode) {
        if (exitCode == 0) {
            if (*hasResults) {
                emit resultText("Search completed successfully!");
            } else {
                emit resultText("No files or folders found matching the keyword.");
            }
        } else {
            emit resultText("Search process crashed.");
        }
        proc->deleteLater();
    });

    QString homePath = QDir::homePath();


    proc->start("fd", {searchTerm, homePath});
}

void CommandInterpreter::handleCreate(const QStringList &args) {
    if (args.isEmpty()) {
        emit resultText("Usage: create <path/to/name> (e.g., create Project/src or create note.txt)");
        return;
    }

    QDir home(QDir::homePath());
    const QString &targetInput = args[0];

    QString absolutePath = home.absoluteFilePath(targetInput);
    QFileInfo fileInfo(absolutePath);

    if (targetInput.contains(".")) {
        QDir parentDir = fileInfo.dir();
        if (!parentDir.exists()) {
            (void) parentDir.mkpath(".");
        }

        QFile file(absolutePath);
        if (file.exists()) {
            emit resultText("⚠File already exists: " + targetInput);
            return;
        }

        if (file.open(QIODevice::WriteOnly)) {
            file.close();
            emit resultText("📄File created successfully: " + targetInput);
        } else {
            emit resultText("❌ Failed to create file: " + targetInput);
        }
    } else {
        // --- XỬ LÝ TẠO FOLDER ---
        QDir dir(absolutePath);
        if (dir.exists()) {
            emit resultText("⚠️ Folder already exists: " + targetInput);
            return;
        }

        if (home.mkpath(targetInput)) {
            emit resultText("📁 Folder created successfully: " + targetInput);
        } else {
            emit resultText("❌ Failed to create folder: " + targetInput);
        }
    }
}

void CommandInterpreter::runViaShell(const QString &command) {
    QProcess::startDetached("/bin/sh", {"-c", command});
}