#ifndef YMLTREEMODEL_H
#define YMLTREEMODEL_H
#include <QAbstractItemModel>
#include <qqmlintegration.h>
#include <vector>
#include <memory>
#include <yaml-cpp/yaml.h>

class TreeItem;

class YmlTreeModel: public QAbstractItemModel {
    Q_OBJECT
public:
    explicit YmlTreeModel(QObject* parent = nullptr);
    ~YmlTreeModel() = default;

    QVariant data(const QModelIndex& index, int role) const override;
    Qt::ItemFlags flags(const QModelIndex& index) const override;
    QVariant headerData(int section, Qt::Orientation orientation,
                        int role = Qt::DisplayRole) const override;
    QModelIndex index(int row, int column,
                      const QModelIndex& parent = {}) const override;
    QModelIndex parent(const QModelIndex& index) const override;
    int rowCount(const QModelIndex& parent = {}) const override;
    int columnCount(const QModelIndex& parent = {}) const override;

    void init(const QString& path);

private:
    void fillModel(const YAML::Node& node, TreeItem* parentItem);

    std::unique_ptr<TreeItem> _rootItem;

signals:
    void sigInitFinished();
};

class TreeItem {
public:
    explicit TreeItem(QVariantList data, TreeItem* parentItem = nullptr);

    void appendChild(std::unique_ptr<TreeItem>&& child);

    TreeItem *child(int row);
    int childCount() const;
    int columnCount() const;
    QVariant data(int column) const;
    int row() const;
    TreeItem *parentItem();

private:
    std::vector<std::unique_ptr<TreeItem>> _childItems;
    QVariantList _itemData;
    TreeItem* _parentItem;
};

#endif // YMLTREEMODEL_H
