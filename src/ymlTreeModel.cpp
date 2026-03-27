#include "include/ymlTreeModel.h"
#include <algorithm>

YmlTreeModel::YmlTreeModel(QObject *parent/* = nullptr*/)
    : QAbstractItemModel(parent)
{

}

QVariant YmlTreeModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || role != Qt::DisplayRole)
        return {};

    const auto *item = static_cast<const TreeItem*>(index.internalPointer());
    return item->data(index.column());
}

Qt::ItemFlags YmlTreeModel::flags(const QModelIndex &index) const
{
    return index.isValid()
    ? QAbstractItemModel::flags(index) : Qt::ItemFlags(Qt::NoItemFlags);
}

QVariant YmlTreeModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    return orientation == Qt::Horizontal && role == Qt::DisplayRole
               ? _rootItem->data(section) : QVariant{};
}

QModelIndex YmlTreeModel::index(int row, int column, const QModelIndex &parent) const
{
    if (!hasIndex(row, column, parent))
        return {};

    TreeItem *parentItem = parent.isValid()
                               ? static_cast<TreeItem*>(parent.internalPointer())
                               : _rootItem.get();

    if (auto *childItem = parentItem->child(row))
        return createIndex(row, column, childItem);
    return {};
}

QModelIndex YmlTreeModel::parent(const QModelIndex &index) const
{
    if (!index.isValid())
        return {};

    auto *childItem = static_cast<TreeItem*>(index.internalPointer());
    TreeItem *parentItem = childItem->parentItem();

    return parentItem != _rootItem.get()
               ? createIndex(parentItem->row(), 0, parentItem) : QModelIndex{};
}

int YmlTreeModel::rowCount(const QModelIndex &parent) const
{
    if (parent.column() > 0)
        return 0;

    const TreeItem *parentItem = parent.isValid()
                                     ? static_cast<const TreeItem*>(parent.internalPointer())
                                     : _rootItem.get();

    return parentItem->childCount();
}

int YmlTreeModel::columnCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return static_cast<TreeItem*>(parent.internalPointer())->columnCount();
    return _rootItem->columnCount();
}

void YmlTreeModel::fillModel(const YAML::Node& node, TreeItem* parentItem) {
    for (auto it = node.begin(); it != node.end(); ++it) {
        QString key = QString::fromStdString(it->first.as<std::string>());
        QString value = "";
        QVariantList list;

        if (it->second.IsScalar()) {
            value = QString::fromStdString(it->second.as<std::string>());
            list = {key, value};
            parentItem->appendChild(std::make_unique<TreeItem>(list, parentItem));
        } else if (it->second.IsSequence()) {
            value = "[List]";
            list = {key, value};
            parentItem->appendChild(std::make_unique<TreeItem>(list, parentItem));
        } else if (it->second.IsMap()) {
            list = {key, value};
            auto child = std::make_unique<TreeItem>(list, parentItem);
            TreeItem* childPtr = child.get();
            parentItem->appendChild(std::move(child));
            fillModel(it->second, childPtr);
        }
    }
}

void YmlTreeModel::init(const QString &filePath)
{
    try {
        YAML::Node config = YAML::LoadFile(filePath.toStdString());

        // 重置 Model 内部状态
        beginResetModel();

        QVariantList item = {"Key", "Value"};

        // 初始化根节点 (Header)
        _rootItem = std::make_unique<TreeItem>(item);

        // 开始递归解析
        if (config.IsDefined()) {
            fillModel(config, _rootItem.get());
        }

        endResetModel();
        emit sigInitFinished();
    } catch (const std::exception& e) {
        qWarning() << "Failed to parse YAML:" << e.what();
    }
}

TreeItem::TreeItem(QVariantList data, TreeItem *parentItem)
    : _itemData(std::move(data))
    , _parentItem(parentItem)
{

}

void TreeItem::appendChild(std::unique_ptr<TreeItem> &&child)
{
    _childItems.push_back(std::move(child));
}

TreeItem *TreeItem::child(int row)
{
    return row >= 0 && row < childCount() ? _childItems.at(row).get() : nullptr;
}

int TreeItem::childCount() const
{
    return int(_childItems.size());
}

int TreeItem::columnCount() const
{
    return int(_itemData.count());
}

QVariant TreeItem::data(int column) const
{
    return _itemData.value(column);
}

int TreeItem::row() const
{
    if (_parentItem == nullptr)
        return 0;
    const auto it = std::find_if(_parentItem->_childItems.cbegin(),
                                 _parentItem->_childItems.cend(),
                                 [this](const std::unique_ptr<TreeItem> &treeItem) {
                                     return treeItem.get() == this;
                                 });

    if (it != _parentItem->_childItems.cend())
        return std::distance(_parentItem->_childItems.cbegin(), it);
    Q_ASSERT(false); // should not happen
    return -1;
}

TreeItem *TreeItem::parentItem()
{
    return _parentItem;
}


