#pragma once
#include <QAbstractListModel>

class AppModel : public QAbstractListModel
{
    Q_OBJECT

public:
    explicit AppModel(QObject *parent = nullptr);


    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

private:

    enum AppRoles {
        NameRole = Qt::UserRole + 1
    };

    QStringList m_names;
};