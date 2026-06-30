#include "appmodel.h"

AppModel::AppModel(QObject *parent)
    : QAbstractListModel(parent)
{

    m_names << "Firefox" << "Kitty" << "VSCode";
}

int AppModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_names.count();
}

QVariant AppModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_names.count())
        return QVariant();

    if (role == NameRole)
        return m_names.at(index.row());

    return QVariant();
}

QHash<int, QByteArray> AppModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    return roles;
}