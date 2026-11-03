package com.compilers.js;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;

/**
 * Entry point.
 *
 * Usage:  java -jar js-lexer.jar <file.js> [-o output.txt]
 */
public class Main {

    public static void main(String[] args) throws IOException {
        if (args.length < 1) {
            System.err.println("Usage: java -jar js-lexer.jar <file.js> [-o output.txt]");
            System.exit(1);
        }

        Path input = Paths.get(args[0]);
        if (!Files.exists(input)) {
            System.err.println("File not found: " + input);
            System.exit(1);
        }

        CharStream stream = CharStreams.fromPath(input, StandardCharsets.UTF_8);
        LexicalAnalyzer.Result result = LexicalAnalyzer.analyze(stream);
        String output = TokenPrinter.format(result);

        System.out.print(output);

        if (args.length >= 3 && args[1].equals("-o")) {
            Files.writeString(Paths.get(args[2]), output, StandardCharsets.UTF_8);
        }
    }
}
