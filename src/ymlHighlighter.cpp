#include "include/ymlHighlighter.h"

YmlHighlighter::YmlHighlighter(QObject* parent)
    : QSyntaxHighlighter(parent)
{
    updateFormats();
}

QQuickTextDocument* YmlHighlighter::textDocument() const
{
    return m_textDocument;
}

void YmlHighlighter::setTextDocument(QQuickTextDocument* doc)
{
    if (m_textDocument == doc)
        return;
    m_textDocument = doc;
    if (doc)
        setDocument(doc->textDocument());
    emit textDocumentChanged();
}

bool YmlHighlighter::isLightMode() const
{
    return m_isLightMode;
}

void YmlHighlighter::setIsLightMode(bool light)
{
    if (m_isLightMode == light)
        return;
    m_isLightMode = light;
    updateFormats();
    rehighlight();
    emit isLightModeChanged();
}

void YmlHighlighter::updateFormats()
{
    m_rules.clear();

    if (m_isLightMode) {
        m_commentFormat.setForeground(QColor("#8b8b8b"));
        m_commentFormat.setFontItalic(true);

        m_keyFormat.setForeground(QColor("#0550ae"));
        m_keyFormat.setFontWeight(QFont::Bold);

        m_stringFormat.setForeground(QColor("#0a6e4a"));

        m_numberFormat.setForeground(QColor("#b35900"));

        m_boolFormat.setForeground(QColor("#8250df"));
        m_boolFormat.setFontWeight(QFont::Bold);

        m_listFormat.setForeground(QColor("#0550ae"));

        m_anchorFormat.setForeground(QColor("#b35900"));
        m_anchorFormat.setFontWeight(QFont::Bold);

        m_tagFormat.setForeground(QColor("#096767"));
        m_tagFormat.setFontWeight(QFont::Bold);
    } else {
        m_commentFormat.setForeground(QColor("#6a737d"));
        m_commentFormat.setFontItalic(true);

        m_keyFormat.setForeground(QColor("#79c0ff"));
        m_keyFormat.setFontWeight(QFont::Bold);

        m_stringFormat.setForeground(QColor("#7ee787"));

        m_numberFormat.setForeground(QColor("#ffa657"));

        m_boolFormat.setForeground(QColor("#d2a8ff"));
        m_boolFormat.setFontWeight(QFont::Bold);

        m_listFormat.setForeground(QColor("#79c0ff"));

        m_anchorFormat.setForeground(QColor("#ffa657"));
        m_anchorFormat.setFontWeight(QFont::Bold);

        m_tagFormat.setForeground(QColor("#39c5cf"));
        m_tagFormat.setFontWeight(QFont::Bold);
    }

    m_rules.append({QRegularExpression("^\\s*#[^\n]*"), m_commentFormat});

    m_rules.append({QRegularExpression("\"[^\"]*\""), m_stringFormat});

    m_rules.append({QRegularExpression("'[^']*'"), m_stringFormat});

    m_rules.append({QRegularExpression("^\\s*(?:-\\s)?[\\w\\-\\.]+(?=\\s*:)"), m_keyFormat});

    m_rules.append({QRegularExpression("^\\s*-\\s"), m_listFormat});

    m_rules.append({QRegularExpression("\\b(?:true|false|yes|no|on|off|null|~)\\b"), m_boolFormat});

    m_rules.append({QRegularExpression("(?<!\\w)[0-9]+(?:\\.[0-9]+)?(?=\\s|$|,)"), m_numberFormat});

    m_rules.append({QRegularExpression("[&\\*]\\w+"), m_anchorFormat});

    m_rules.append({QRegularExpression("![\\w\\-]+!?[\\w\\-]*"), m_tagFormat});
}

void YmlHighlighter::highlightBlock(const QString& text)
{
    if (text.isEmpty())
        return;

    QString trimmed = text.trimmed();
    if (!trimmed.isEmpty() && trimmed[0] == QLatin1Char('#')) {
        setFormat(0, text.length(), m_commentFormat);
        return;
    }

    for (const auto& rule : m_rules) {
        QRegularExpressionMatchIterator it = rule.pattern.globalMatch(text);
        while (it.hasNext()) {
            QRegularExpressionMatch match = it.next();
            setFormat(match.capturedStart(), match.capturedLength(), rule.format);
        }
    }
}
