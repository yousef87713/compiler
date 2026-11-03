package com.compilers.js;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import org.antlr.v4.runtime.CharStreams;

/**
 * Simple test runner (no external libraries needed).
 * Run with:  test.sh  /  test.bat
 * Every team member adds tests for their own grammar section.
 */
public class TestRunner {

    private static int passed = 0;
    private static final List<String> failures = new ArrayList<>();

    public static void main(String[] args) {
        keywordsAreNotIdentifiers();
        numbers();
        booleansAndNull();
        stringWithOtherQuoteInside();
        stringLineContinuationIsOneToken();
        unterminatedStringIsReportedWithPosition();
        multiLineComment();
        unterminatedCommentIsAnError();
        templateLiteralSpansLines();
        longestOperatorWins();
        unknownCharacterIsAnError();

        System.out.println("Passed: " + passed + "   Failed: " + failures.size());
        failures.forEach(f -> System.out.println("  FAILED: " + f));
        System.exit(failures.isEmpty() ? 0 : 1);
    }

    // ---------------------------------------------------------------- helpers
    private static LexicalAnalyzer.Result run(String src) {
        return LexicalAnalyzer.analyze(CharStreams.fromString(src));
    }

    /** "TYPE:text" for every token, e.g. KEYWORD:var */
    private static List<String> tokens(String src) {
        LexicalAnalyzer.Result r = run(src);
        return r.tokens().stream()
                .map(t -> TokenPrinter.displayType(t.getType(), r.vocabulary()) + ":" + t.getText())
                .collect(Collectors.toList());
    }

    private static void check(String name, Object expected, Object actual) {
        if (expected.equals(actual)) {
            passed++;
        } else {
            failures.add(name + "\n      expected: " + expected + "\n      actual:   " + actual);
        }
    }

    // ------------------------------------------------------------------ tests
    static void keywordsAreNotIdentifiers() {
        check("keywordsAreNotIdentifiers", List.of("KEYWORD:var", "IDENTIFIER:variable"), tokens("var variable"));
    }

    static void numbers() {
        check("numbers", List.of("INTEGER:10", "FLOAT:1.5e-3", "FLOAT:.5", "HEX_NUMBER:0xFF",
                "OCTAL_NUMBER:0o17", "BINARY_NUMBER:0b101", "BIGINT:123n"),
                tokens("10 1.5e-3 .5 0xFF 0o17 0b101 123n"));
    }

    static void booleansAndNull() {
        check("booleansAndNull", List.of("BOOLEAN_LITERAL:true", "BOOLEAN_LITERAL:false", "NULL_LITERAL:null"),
                tokens("true false null"));
    }

    static void stringWithOtherQuoteInside() {
        check("stringWithOtherQuoteInside", List.of("STRING:'It\\'s a \"beautiful\" day'"),
                tokens("'It\\'s a \"beautiful\" day'"));
    }

    static void stringLineContinuationIsOneToken() {
        LexicalAnalyzer.Result r = run("\"abc\\\ndef\"");
        check("stringLineContinuation tokens", 1, r.tokens().size());
        check("stringLineContinuation errors", 0, r.errors().size());
    }

    static void unterminatedStringIsReportedWithPosition() {
        LexicalAnalyzer.Result r = run("var s = \"abc\nvar t = 5;");
        check("unterminatedString count", 1, r.errors().size());
        check("unterminatedString line", 1, r.errors().get(0).line());
        check("unterminatedString column", 9, r.errors().get(0).column());
        check("lexing continues after error", true,
                r.tokens().stream().anyMatch(t -> t.getText().equals("5")));
    }

    static void multiLineComment() {
        check("multiLineComment", List.of("MULTI_LINE_COMMENT:/* a\n b */"), tokens("/* a\n b */"));
    }

    static void unterminatedCommentIsAnError() {
        check("unterminatedComment", 1, run("/* never closed").errors().size());
    }

    static void templateLiteralSpansLines() {
        check("templateLiteralSpansLines", 1, tokens("`a\nb`").size());
    }

    static void longestOperatorWins() {
        check("longestOperatorWins", List.of("OPERATOR:>>>=", "OPERATOR:===", "OPERATOR:??="),
                tokens(">>>= === ??="));
    }

    static void unknownCharacterIsAnError() {
        check("unknownCharacter", 1, run("let a = @;").errors().size());
    }
}
