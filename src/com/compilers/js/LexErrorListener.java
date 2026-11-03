package com.compilers.js;

import java.util.ArrayList;
import java.util.List;
import org.antlr.v4.runtime.BaseErrorListener;
import org.antlr.v4.runtime.RecognitionException;
import org.antlr.v4.runtime.Recognizer;

/**
 * Collects errors reported by ANTLR itself (instead of printing them to stderr)
 * so we can print them later in the required output format.
 */
public class LexErrorListener extends BaseErrorListener {

    private final List<LexicalError> errors = new ArrayList<>();

    @Override
    public void syntaxError(Recognizer<?, ?> recognizer, Object offendingSymbol,
                            int line, int charPositionInLine,
                            String msg, RecognitionException e) {
        // ANTLR columns are 0-based; we report 1-based columns.
        errors.add(new LexicalError(line, charPositionInLine + 1, "Invalid or unexpected token (" + msg + ")"));
    }

    public List<LexicalError> getErrors() {
        return errors;
    }
}
