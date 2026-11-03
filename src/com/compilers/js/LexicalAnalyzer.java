package com.compilers.js;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.Token;

/**
 * Runs the generated JSLexer over an input and separates the result into
 * valid tokens and lexical errors.
 *
 * Error tokens (UNTERMINATED_STRING, ERROR_CHAR, ...) are defined at the end of
 * JSLexer.g4. They are NOT returned as normal tokens; they become LexicalErrors.
 */
public final class LexicalAnalyzer {

    private LexicalAnalyzer() { }

    public record Result(List<Token> tokens, List<LexicalError> errors, org.antlr.v4.runtime.Vocabulary vocabulary) { }

    public static Result analyze(CharStream input) {
        JSLexer lexer = new JSLexer(input);
        lexer.removeErrorListeners();
        LexErrorListener listener = new LexErrorListener();
        lexer.addErrorListener(listener);

        List<Token> tokens = new ArrayList<>();
        List<LexicalError> errors = new ArrayList<>();

        for (Token t = lexer.nextToken(); t.getType() != Token.EOF; t = lexer.nextToken()) {
            String message = errorMessage(t.getType());
            if (message != null) {
                errors.add(new LexicalError(t.getLine(), t.getCharPositionInLine() + 1,
                        message + ": " + TokenPrinter.escape(preview(t.getText()))));
            } else {
                tokens.add(t);
            }
        }

        errors.addAll(listener.getErrors());
        errors.sort(Comparator.comparingInt(LexicalError::line).thenComparingInt(LexicalError::column));
        return new Result(tokens, errors, lexer.getVocabulary());
    }

    /** Returns an error message if the token type is an error token, otherwise null. */
    static String errorMessage(int type) {
        switch (type) {
            case JSLexer.UNTERMINATED_STRING:   return "Invalid or unexpected token - unterminated string literal";
            case JSLexer.UNTERMINATED_TEMPLATE: return "Invalid or unexpected token - unterminated template literal";
            case JSLexer.UNTERMINATED_COMMENT:  return "Invalid or unexpected token - unterminated multi-line comment";
            case JSLexer.INVALID_NUMBER:        return "Invalid or unexpected token - invalid numeric literal";
            case JSLexer.ERROR_CHAR:            return "Invalid or unexpected token";
            default:                            return null;
        }
    }

    private static String preview(String text) {
        return text.length() > 30 ? text.substring(0, 30) + "..." : text;
    }
}
