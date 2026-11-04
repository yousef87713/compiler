import org.antlr.v4.runtime.*;
import java.util.*;

public class Main {
    private static final Map<String, String> ERRORS = Map.of(
            "UNTERMINATED_STRING", "Unterminated string literal",
            "UNTERMINATED_COMMENT", "Unterminated multi-line comment",
            "UNTERMINATED_TEMPLATE", "Unterminated template literal",
            "INVALID_NUMBER", "Invalid number literal",
            "INVALID_CHAR", "Invalid or unexpected token");

    public static void main(String[] args) throws Exception {
        String path = args.length > 0 ? args[0] : "tests/lexer/test_all.js";
        Js_Lexer lexer = new Js_Lexer(CharStreams.fromFileName(path));
        lexer.removeErrorListeners();
        Vocabulary v = lexer.getVocabulary();
        List<String> toks = new ArrayList<>(), errs = new ArrayList<>();
        for (Token t = lexer.nextToken(); t.getType() != Token.EOF; t = lexer.nextToken()) {
            String name = v.getSymbolicName(t.getType());
            String pos = t.getLine() + ":" + (t.getCharPositionInLine() + 1);
            String text = t.getText().replace("\r", "\\r").replace("\n", "\\n");
            if (ERRORS.containsKey(name))
                errs.add("Error at " + pos + " : " + ERRORS.get(name) + " -> [" + text + "]");
            else
                toks.add("[" + text + "] -> <" + name + "> (" + pos + ")");
        }
        System.out.println("--- Tokens Found ---");
        toks.forEach(System.out::println);
        System.out.println("\n--- Lexical Errors: " + errs.size() + " ---");
        errs.forEach(System.out::println);
    }
}