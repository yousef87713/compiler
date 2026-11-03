package com.compilers.js;

import java.util.Set;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.Vocabulary;

/**
 * Formats the analyzer result in the output format required by the lab:
 *
 * --- Tokens Found ---
 * [Text] - <Type: X> (Line:Column)
 * ...
 * --- Lexical Errors: N ---
 * Error at Line:Column  Message
 *
 * If the doctors confirm a different layout, only this file needs to change.
 */
public final class TokenPrinter {

    private static final Set<String> PUNCTUATION = Set.of("(", ")", "[", "]", "{", "}", ";", ",", ":");

    private TokenPrinter() { }

    public static String format(LexicalAnalyzer.Result result) {
        StringBuilder sb = new StringBuilder();
        sb.append("--- Tokens Found ---\n");
        for (Token t : result.tokens()) {
            sb.append('[').append(escape(t.getText())).append("] - <Type: ")
              .append(displayType(t.getType(), result.vocabulary()))
              .append("> (").append(t.getLine()).append(':').append(t.getCharPositionInLine() + 1).append(")\n");
        }
        sb.append("--- Lexical Errors: ").append(result.errors().size()).append(" ---\n");
        for (LexicalError e : result.errors()) {
            sb.append(e).append('\n');
        }
        return sb.toString();
    }

    /**
     * Groups the many token types into readable categories:
     * keywords -> KEYWORD, fixed symbols -> PUNCTUATION / OPERATOR,
     * everything else keeps its own name (IDENTIFIER, INTEGER, STRING, ...).
     * No manual list to maintain: it is derived from the literal name in the grammar.
     */
    static String displayType(int type, Vocabulary vocab) {
        String literal = vocab.getLiteralName(type);          // e.g. 'if'  or  '+='
        if (literal != null && !"NULL_LITERAL".equals(vocab.getSymbolicName(type))) {
            String raw = literal.substring(1, literal.length() - 1);
            if (raw.matches("[a-z]+")) return "KEYWORD";
            return PUNCTUATION.contains(raw) ? "PUNCTUATION" : "OPERATOR";
        }
        return vocab.getSymbolicName(type);
    }

    /** Makes line breaks / tabs visible so every token stays on one output line. */
    static String escape(String s) {
        return s.replace("\n", "\\n").replace("\r", "\\r").replace("\t", "\\t");
    }
}
