lexer grammar Js_Lexer;

// =====================================================================
//  JavaScript (ECMAScript 2025) - Lexical Analyzer
//  قاعدة ANTLR: الأطول يفوز، وعند التساوي تفوز القاعدة الأولى بالملف
//  لذلك: الكلمات المحجوزة قبل IDENTIFIER، وWS قبل قواعد الأخطاء
// =====================================================================

// ===================== 1) Reserved Keywords =====================
// كلمات محجوزة دائماً
BREAK      : 'break';      CASE       : 'case';       CATCH      : 'catch';
CLASS      : 'class';      CONST      : 'const';      CONTINUE   : 'continue';
DEBUGGER   : 'debugger';   DEFAULT    : 'default';    DELETE     : 'delete';
DO         : 'do';         ELSE       : 'else';       ENUM       : 'enum';
EXPORT     : 'export';     EXTENDS    : 'extends';    FINALLY    : 'finally';
FOR        : 'for';        FUNCTION   : 'function';   IF         : 'if';
IMPORT     : 'import';     IN         : 'in';         INSTANCEOF : 'instanceof';
NEW        : 'new';        RETURN     : 'return';     SUPER      : 'super';
SWITCH     : 'switch';     THIS       : 'this';       THROW      : 'throw';
TRY        : 'try';        TYPEOF     : 'typeof';     VAR        : 'var';
VOID       : 'void';       WHILE      : 'while';      WITH       : 'with';
NULL_LITERAL : 'null';

// محجوزة في strict mode / سياقية
LET        : 'let';        STATIC     : 'static';     YIELD      : 'yield';
AWAIT      : 'await';      ASYNC      : 'async';      OF         : 'of';
GET        : 'get';        SET        : 'set';        FROM       : 'from';
AS         : 'as';
IMPLEMENTS : 'implements'; INTERFACE  : 'interface';  PACKAGE    : 'package';
PRIVATE    : 'private';    PROTECTED  : 'protected';  PUBLIC     : 'public';

// ===================== 3) Boolean =====================
BOOLEAN : 'true' | 'false';

// ===================== 2) Numbers =====================
// الأرقام تدعم الفاصل _ مثل 1_000_000
fragment DIGITS : [0-9] ( '_'? [0-9] )* ;
fragment HEXD   : [0-9a-fA-F] ( '_'? [0-9a-fA-F] )* ;
fragment OCTD   : [0-7] ( '_'? [0-7] )* ;
fragment BIND   : [01] ( '_'? [01] )* ;
fragment EXP    : [eE] [+-]? DIGITS ;

HEX_NUMBER    : '0' [xX] HEXD ;
OCTAL_NUMBER  : '0' [oO] OCTD
              | '0' [0-7]+            // octal قديم: 0777
              ;
BINARY_NUMBER : '0' [bB] BIND ;

BIGINT : ( '0'
         | [1-9] ( '_'? [0-9] )*
         | '0' [xX] HEXD
         | '0' [oO] OCTD
         | '0' [bB] BIND
         ) 'n' ;

FLOAT : DIGITS '.' DIGITS? EXP?
      | '.' DIGITS EXP?
      | DIGITS EXP
      ;

INTEGER : DIGITS ;

// رقم ملتصق بحروف مثل 3abc أو 0x أو 1_000_  => خطأ
INVALID_NUMBER : DIGITS [a-zA-Z_$] [a-zA-Z0-9_$]* ;

// ===================== 4) String literals =====================
// \ متبوعة بأي حرف (ومنها سطر جديد = Continuation Line)
fragment ESC : '\\' ( '\r\n' | . ) ;

STRING
    : '"'  ( ESC | ~["\\\r\n] )* '"'
    | '\'' ( ESC | ~['\\\r\n] )* '\''
    ;

// Template literal بين backticks ويمتد على عدة أسطر
TEMPLATE : '`' ( '\\' . | ~[`\\] )* '`' ;

// ===================== 8) Comments =====================
LINE_COMMENT  : '//' ~[\r\n]* ;
BLOCK_COMMENT : '/*' .*? '*/' ;
HASHBANG      : '#!' ~[\r\n]* ;

// ===================== 5) Operators =====================
// أطول عامل أولاً (ANTLR أصلاً يختار الأطول)
URSHIFT_ASSIGN   : '>>>=';
ELLIPSIS         : '...';
STRICT_EQ        : '===';
STRICT_NEQ       : '!==';
POW_ASSIGN       : '**=';
LSHIFT_ASSIGN    : '<<=';
RSHIFT_ASSIGN    : '>>=';
URSHIFT          : '>>>';
AND_ASSIGN       : '&&=';
OR_ASSIGN        : '||=';
NULLISH_ASSIGN   : '??=';
ARROW            : '=>';
EQ               : '==';
NEQ              : '!=';
LTE              : '<=';
GTE              : '>=';
AND              : '&&';
OR               : '||';
NULLISH          : '??';
OPTIONAL_CHAIN   : '?.';
INC              : '++';
DEC              : '--';
PLUS_ASSIGN      : '+=';
MINUS_ASSIGN     : '-=';
MUL_ASSIGN       : '*=';
DIV_ASSIGN       : '/=';
MOD_ASSIGN       : '%=';
BIT_AND_ASSIGN   : '&=';
BIT_OR_ASSIGN    : '|=';
BIT_XOR_ASSIGN   : '^=';
LSHIFT           : '<<';
RSHIFT           : '>>';
POW              : '**';
ASSIGN           : '=';
LT               : '<';
GT               : '>';
PLUS             : '+';
MINUS            : '-';
STAR             : '*';
SLASH            : '/';
PERCENT          : '%';
NOT              : '!';
BIT_AND          : '&';
BIT_OR           : '|';
BIT_XOR          : '^';
BIT_NOT          : '~';
QUESTION         : '?';
COLON            : ':';

// ===================== Delimiters =====================
LPAREN : '(';  RPAREN : ')';
LBRACE : '{';  RBRACE : '}';
LBRACK : '[';  RBRACK : ']';
SEMI   : ';';  COMMA  : ',';  DOT : '.';

// ===================== 6,7) Identifiers / Variables =====================
// يدعم Unicode (حروف عربية وغيرها) و $ و _
fragment ID_START : [\p{L}\p{Nl}$_] ;
fragment ID_PART  : [\p{L}\p{Nl}\p{Nd}\p{Mn}\p{Mc}\p{Pc}$\u200c\u200d] ;

IDENTIFIER         : ID_START ID_PART* ;
PRIVATE_IDENTIFIER : '#' ID_START ID_PART* ;     // #field داخل الـ class

// ===================== المسافات (قبل قواعد الأخطاء!) =====================
WS : [ \t\r\n\u000B\u000C\u00A0\uFEFF]+ -> skip ;

// ===================== Lexical Errors (آخر الملف دائماً) =====================
UNTERMINATED_STRING
    : '"'  ( ESC | ~["\\\r\n] )*
    | '\'' ( ESC | ~['\\\r\n] )*
    ;
UNTERMINATED_COMMENT  : '/*' ( ~'*' | '*'+ ~[*/] )* '*'* EOF ;
UNTERMINATED_TEMPLATE : '`' ( '\\' . | ~[`\\] )* EOF ;
INVALID_CHAR          : . ;
