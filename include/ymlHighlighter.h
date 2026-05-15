#ifndef YMLHIGHLIGHTER_H
#define YMLHIGHLIGHTER_H

#include <QSyntaxHighlighter>
#include <QQuickTextDocument>
#include <QRegularExpression>
#include <QTextCharFormat>
#include <QVector>
class YmlHighlighter : public QSyntaxHighlighter
{
    Q_OBJECT
    Q_PROPERTY(QQuickTextDocument* textDocument READ textDocument WRITE setTextDocument NOTIFY textDocumentChanged)
    Q_PROPERTY(bool isLightMode READ isLightMode WRITE setIsLightMode NOTIFY isLightModeChanged)

public:
    explicit YmlHighlighter(QObject* parent = nullptr);

    QQuickTextDocument* textDocument() const;
    void setTextDocument(QQuickTextDocument* doc);

    bool isLightMode() const;
    void setIsLightMode(bool light);

signals:
    void textDocumentChanged();
    void isLightModeChanged();

protected:
    void highlightBlock(const QString& text) override;

private:
    void updateFormats();

    struct HighlightingRule {
        QRegularExpression pattern;
        QTextCharFormat format;
    };
    QVector<HighlightingRule> m_rules;

    QQuickTextDocument* m_textDocument = nullptr;
    bool m_isLightMode = true;

    QTextCharFormat m_commentFormat;
    QTextCharFormat m_keyFormat;
    QTextCharFormat m_stringFormat;
    QTextCharFormat m_numberFormat;
    QTextCharFormat m_boolFormat;
    QTextCharFormat m_listFormat;
    QTextCharFormat m_anchorFormat;
    QTextCharFormat m_tagFormat;
};

#endif // YMLHIGHLIGHTER_H
