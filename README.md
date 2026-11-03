# JS Compiler — المرحلة الأولى: المحلل المفرداتي (Lexer)

جامعة دمشق – كلية الهندسة المعلوماتية – السنة الرابعة (الذكاء الصنعي) – عملي مترجمات

مترجم للغة **JavaScript (ECMAScript 2025)** باستخدام **ANTLR4** و**Java**.
المشروع مجهّز للعمل على **IntelliJ IDEA + ANTLR v4 plugin**.

## الإعداد (شبه جاهز)

ملفات إعداد IntelliJ (`.iml` و`.idea/`) موجودة بالمشروع، فمكتبة `antlr4-runtime` ومجلدات `src` و`gen` و`test` معلّمة تلقائياً.

1. افتح مجلد المشروع بـ IntelliJ (`File > Open`).
2. إذا طلب SDK: `File > Project Structure > Project` واختار JDK 17 أو أحدث.
3. ولّد الـ Lexer مرة وحدة (لأن `gen/` ما بينرفع عالغيت):
   كليك يمين على `grammar/JSLexer.g4` > `Generate ANTLR Recognizer` (أو `Ctrl+Shift+G`).
   - الـ **package** معرّف جوّا الـ grammar نفسه (`@header`). بنافذة `Configure ANTLR...` **خلّي Package/namespace فاضي** حتى ما يتكرر.
   - **Output directory**: `gen`
4. `Build > Rebuild Project`.

> بعد أي `git pull` فيه تعديل على `JSLexer.g4`، أعد الخطوة 3 و4.

> إذا ظهر خطأ `Unsupported ... ATN version` فنسخة الـ runtime مختلفة عن نسخة الـ plugin. خلّيهم نفس النسخة عند كل الفريق.

## التشغيل

بأعلى IntelliJ بتلاقي 3 إعدادات تشغيل جاهزة:
- **Lexer - 01_basic**: تشغيل على `samples/01_basic.js`
- **Lexer - 02_errors**: تشغيل على `samples/02_errors.js`
- **Run Tests**: الاختبارات، ولازم يطلع `Failed: 0`

لتشغيله على ملف ثاني: `Edit Configurations` وغيّر الـ Program arguments (مثلاً `mycode.js -o output.txt`).

## تجربة سريعة بالـ plugin بدون Java
كليك يمين على أي قاعدة بالـ grammar (مثلاً `STRING`) > `Test Rule STRING`، بتكتب نص وبتشوف الـ tokens مباشرة.
مفيد جداً لتجربة القواعد قبل ما تدمجوها.

## هيكل المشروع
```
.
├── grammar/JSLexer.g4           <- قواعد الـ Lexer (القلب)
├── src/com/compilers/js/
│   ├── Main.java                <- نقطة الدخول
│   ├── LexicalAnalyzer.java     <- تشغيل الـ Lexer وفصل الـ tokens عن الأخطاء
│   ├── LexErrorListener.java    <- تجميع أخطاء ANTLR
│   ├── LexicalError.java        <- خطأ + مكانه
│   └── TokenPrinter.java        <- صيغة الخرج المطلوبة
├── test/com/compilers/js/TestRunner.java
├── samples/                     <- ملفات JS للتجربة
├── lib/                         <- antlr4-runtime-4.13.1.jar
└── docs/                        <- توزيع المهام و Git workflow
```
مجلد `gen/` (الكود المولّد) ما بيتعمله commit؛ كل واحد بيولّده عنده بالـ plugin بعد ما يعمل pull لأي تعديل على الـ `.g4`.

## صيغة الخرج
```
--- Tokens Found ---
[var] - <Type: KEYWORD> (1:1)
...
--- Lexical Errors: 1 ---
Error at 1:9  Invalid or unexpected token - unterminated string literal: "abc
```
(السطر:العمود — العمود يبدأ من 1)

## قواعد مهمة بـ ANTLR
1. **الأطول يربح**: `>>>=` أقوى من `>>`.
2. **عند التساوي، أول قاعدة بالملف تربح** ← الـ keywords قبل `IDENTIFIER`، وقواعد الأخطاء بالآخر.
3. كل واحد بيعدّل بقسمه فقط من الـ grammar (انظر `docs/TEAM_TASKS.md`).
