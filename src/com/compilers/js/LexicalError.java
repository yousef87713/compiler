package com.compilers.js;

/** One lexical error with its position (line and column are 1-based). */
public record LexicalError(int line, int column, String message) {

    @Override
    public String toString() {
        return "Error at " + line + ":" + column + "  " + message;
    }
}
