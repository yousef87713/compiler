/*
 * JSLexer.g4  --  Phase 1: Lexical analyzer for JavaScript (ECMAScript 2025)
 * Damascus University - Faculty of Informatics Engineering - Compilers Lab
 *
 * The file is split into clearly marked sections. Each team member owns one
 * section (see docs/TEAM_TASKS.md) so merge conflicts stay small.
 *
 * IMPORTANT RULES (ANTLR lexer):
 *   1) The longest match wins.
 *   2) On a tie, the rule that appears FIRST in this file wins.
 *      => keywords must come BEFORE IDENTIFIER, error rules must come LAST.
 */
lexer grammar JSLexer;

// The package is declared here (not in the IntelliJ plugin settings) so it is shared
// through git. In the plugin's "Configure ANTLR" dialog leave Package/namespace EMPTY.
@header {
package com.compilers.js;
}

// ============================================================================
// SECTION 1 - COMMENTS                                           (owner: #5)
// ============================================================================
SINGLE_LINE_COMMENT
    : '//' ~[\r\n\u2028\u2029]*
    ;

MULTI_LINE_COMMENT
    : '/*' .*? '*/'
    ;

// ============================================================================
// SECTION 2 - KEYWORDS                                           (owner: #2)
// Each keyword is its own token so the parser (phase 2) can use it directly.
// ============================================================================
BREAK      : 'break';
CASE       : 'case';
CATCH      : 'catch';
CLASS      : 'class';
CONST      : 'const';
CONTINUE   : 'continue';
DEBUGGER   : 'debugger';
DEFAULT    : 'default';
DELETE     : 'delete';
DO         : 'do';
ELSE       : 'else';
ENUM       : 'enum';
EXPORT     : 'export';
EXTENDS    : 'extends';
FINALLY    : 'finally';
FOR        : 'for';
FUNCTION   : 'function';
IF         : 'if';
IMPORT     : 'import';
IN         : 'in';
INSTANCEOF : 'instanceof';
NEW        : 'new';
RETURN     : 'return';
SUPER      : 'super';
SWITCH     : 'switch';
THIS       : 'this';
THROW      : 'throw';
TRY        : 'try';
TYPEOF     : 'typeof';
VAR        : 'var';
VOID       : 'void';
WHILE      : 'while';
WITH       : 'with';

// Contextual / strict-mode keywords
LET        : 'let';
STATIC     : 'static';
YIELD      : 'yield';
AWAIT      : 'await';
ASYNC      : 'async';
OF         : 'of';

// ============================================================================
// SECTION 3 - BOOLEAN / NULL                                     (owner: #2)
// ============================================================================
BOOLEAN_LITERAL : 'true' | 'false';
NULL_LITERAL    : 'null';

// ============================================================================
// SECTION 4 - NUMBERS                                            (owner: #3)
// Order matters: BIGINT / HEX / OCTAL / BINARY / FLOAT before INTEGER.
// ============================================================================
BIGINT
    : ( HexInt | OctInt | BinInt | DecInt ) 'n'
    ;

HEX_NUMBER    : HexInt;
OCTAL_NUMBER  : OctInt | LegacyOctInt;
BINARY_NUMBER : BinInt;

FLOAT
    : DecInt '.' DecDigits? ExponentPart?     // 1.5   1.   1.5e3
    | '.' DecDigits ExponentPart?             // .5    .5e-2
    | DecInt ExponentPart                     // 1e10
    ;

INTEGER : DecInt;

fragment DecDigits      : [0-9] ( '_'? [0-9] )*;
fragment DecInt         : '0' | [1-9] ( '_'? [0-9] )*;
fragment HexInt         : '0' [xX] HexDigit ( '_'? HexDigit )*;
fragment OctInt         : '0' [oO] [0-7] ( '_'? [0-7] )*;
fragment LegacyOctInt   : '0' [0-7]+;
fragment BinInt         : '0' [bB] [01] ( '_'? [01] )*;
fragment ExponentPart   : [eE] [+\-]? DecDigits;
fragment HexDigit       : [0-9a-fA-F];

// ============================================================================
// SECTION 5 - STRINGS & TEMPLATE LITERALS                        (owner: #4)
// ============================================================================
STRING
    : '"'  DoubleStringChar* '"'
    | '\'' SingleStringChar* '\''
    ;

// Template literal (basic version: everything between two backticks).
// TODO(owner #4): support nested ${ ... } using lexer modes.
TEMPLATE_LITERAL
    : '`' TemplateChar* '`'
    ;

fragment DoubleStringChar : ~["\\\r\n\u2028\u2029] | EscapeSequence | LineContinuation;
fragment SingleStringChar : ~['\\\r\n\u2028\u2029] | EscapeSequence | LineContinuation;
fragment EscapeSequence   : '\\' ~[\r\n\u2028\u2029];
fragment LineContinuation : '\\' ( '\r\n' | '\r' | '\n' | '\u2028' | '\u2029' );
fragment TemplateChar     : ~[`\\] | '\\' . ;

// ============================================================================
// SECTION 6 - OPERATORS & PUNCTUATION                            (owner: #2)
// ANTLR picks the longest match, so '>>>=' beats '>>' automatically.
// ============================================================================
LBRACE : '{';   RBRACE : '}';
LPAREN : '(';   RPAREN : ')';
LBRACK : '[';   RBRACK : ']';
SEMI   : ';';   COMMA  : ',';   COLON  : ':';

DOT       : '.';
ELLIPSIS  : '...';
ARROW     : '=>';
QUESTION  : '?';
OPT_CHAIN : '?.';
NULLISH   : '??';

PLUS : '+';  MINUS : '-';  STAR : '*';  SLASH : '/';  PERCENT : '%';  POWER : '**';
INC  : '++'; DEC   : '--';

EQ        : '==';   NEQ        : '!=';
STRICT_EQ : '===';  STRICT_NEQ : '!==';
LT : '<';  GT : '>';  LE : '<=';  GE : '>=';

AND : '&&';  OR : '||';  NOT : '!';

BIT_AND : '&';  BIT_OR : '|';  BIT_XOR : '^';  BIT_NOT : '~';
LSHIFT  : '<<'; RSHIFT : '>>'; URSHIFT : '>>>';

ASSIGN        : '=';
PLUS_ASSIGN   : '+=';   MINUS_ASSIGN : '-=';   STAR_ASSIGN : '*=';
SLASH_ASSIGN  : '/=';   PERCENT_ASSIGN : '%='; POWER_ASSIGN : '**=';
LSHIFT_ASSIGN : '<<=';  RSHIFT_ASSIGN : '>>='; URSHIFT_ASSIGN : '>>>=';
AND_ASSIGN    : '&=';   OR_ASSIGN : '|=';      XOR_ASSIGN : '^=';
LAND_ASSIGN   : '&&=';  LOR_ASSIGN : '||=';    NULLISH_ASSIGN : '??=';

// ============================================================================
// SECTION 7 - IDENTIFIERS / VARIABLES                            (owner: #2)
// Must stay AFTER keywords and BOOLEAN/NULL.
// ============================================================================
IDENTIFIER         : IdentStart IdentPart*;
PRIVATE_IDENTIFIER : '#' IdentStart IdentPart*;

fragment IdentStart : [\p{L}\p{Nl}$_];
fragment IdentPart  : IdentStart | [\p{Mn}\p{Mc}\p{Nd}\p{Pc}];

// ============================================================================
// SECTION 8 - WHITESPACE                                         (owner: #1)
// Skipped, but ANTLR still tracks line / column numbers correctly.
// ============================================================================
WS : [ \t\f\u000B\u00A0\uFEFF\r\n\u2028\u2029]+ -> skip;

// ============================================================================
// SECTION 9 - LEXICAL ERRORS                                     (owner: #5)
// These rules produce tokens that LexicalAnalyzer reports as errors
// (they are NOT printed in the "Tokens Found" list). Keep them LAST.
// ============================================================================

// "abc   or   'abc   (closing quote missing before end of line)
UNTERMINATED_STRING
    : '"'  DoubleStringChar*
    | '\'' SingleStringChar*
    ;

// `abc  (closing backtick missing before end of file)
UNTERMINATED_TEMPLATE
    : '`' TemplateChar*
    ;

// /* abc  (closing */ missing). Matches any text that does NOT contain '*/'.
UNTERMINATED_COMMENT
    : '/*' ( ~'*' | '*'+ ~[*/] )* '*'*
    ;

// 123abc   0x1G   (a number glued to identifier characters)
INVALID_NUMBER
    : ( FloatLike | DecInt | HexInt | OctInt | BinInt ) IdentStart IdentPart*
    ;
fragment FloatLike
    : DecInt '.' DecDigits? ExponentPart?
    | '.' DecDigits ExponentPart?
    ;

// Any character that does not start a valid token (e.g.  @  \  or a stray char)
ERROR_CHAR : . ;
