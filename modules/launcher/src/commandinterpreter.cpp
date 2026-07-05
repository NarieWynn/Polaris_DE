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
        emit resultText("Commands List: <br>"
                        "  • volume or vol <0-100> : Set audio volume <br>"
                        "  • brightness or br <0-100> : Set screen brightness <br>"
                        "  • find : find file or folder <br>"
                        "  • create : create file or folder <br>"
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
        emit resultText("💡 Usage: create <path1> [path2...] (e.g., create Project/src/main.cpp Project/docs/ README.md)");
        return;
    }

    QDir home(QDir::homePath());
    int successCount = 0;
    int failCount = 0;
    QStringList createdItems;

    for (const QString &rawInput : args) {
        QString targetInput = QDir::cleanPath(rawInput);
        QString absolutePath = home.absoluteFilePath(targetInput);

        bool isFolder = rawInput.endsWith("/") || rawInput.endsWith("\\");
        QFileInfo fileInfo(absolutePath);

        if (isFolder) {
            QDir dir(absolutePath);
            if (dir.exists()) {
                continue;
            }
            if (home.mkpath(targetInput)) {
                successCount++;
                createdItems << ("📁 " + targetInput + "/");
            } else {
                failCount++;
            }
        } else {
            QDir parentDir = fileInfo.dir();
            if (!parentDir.exists()) {
                home.mkpath(parentDir.path());
            }

            QFile file(absolutePath);
            if (file.exists()) {
                continue;
            }

            if (file.open(QIODevice::WriteOnly)) {
                file.close();
                successCount++;
                createdItems << ("📄 " + targetInput);
            } else {
                failCount++;
            }
        }
    }

    if (successCount > 0) {
        QString summary = QString("✅ Successfully created %1 item(s):\n").arg(successCount) + createdItems.join("\n");
        if (failCount > 0) {
            summary += QString("\n⚠️ Skipped or failed: %1 item(s)").arg(failCount);
        }
        emit resultText(summary);
    } else {
        emit resultText("⚠️ No new files or folders created (they might already exist or paths are invalid).");
    }
}

void CommandInterpreter::runViaShell(const QString &command) {
    QProcess::startDetached("/bin/sh", {"-c", command});
}