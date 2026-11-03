// basic program
var a = 'It\'s a "beautiful" day';
var b = "abc\
def";
let x = 0x1F + 0o17 + 0b101 + 123n + 1.5e-3 + .5 + 10;
const ok = true, nothing = null;
if (x >= 10 && ok) { x **= 2; } else { x ??= 1; }
const f = (p, ...rest) => p?.value ?? 0;
class A { #secret = 1; static get() { return this.#secret; } }
/* multi
   line comment */
const t = `hello
  world`;
