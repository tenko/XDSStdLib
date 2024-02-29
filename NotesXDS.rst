XDS Compiler Notes
==================

Issues
------

1. Constants are limited to 32bit.

MODULE test64BitConstant;

IMPORT SYSTEM;

CONST
    X = 0FFFFFFFFFFFFFFFFH;

PROCEDURE Test;
VAR
    x : SYSTEM.CARD64;

(* Work around 32bit limit of hex constants *)
PROCEDURE Combine*(high, low : WORD): LONGWORD;
BEGIN
    RETURN (VAL(LONGWORD, high) << 32) OR VAL(LONGWORD, low);
END Combine;

(* Work around 32bit limit of hex constants *)
PROCEDURE Split*(x : LONGWORD; VAR high, low : WORD);
VAR div : LONGWORD;
BEGIN
    div := 0FFFFFFFFH;
    div := div + 1;
    high := VAL(WORD, (x DIV div) AND 0FFFFFFFFH);
    low := VAL(WORD, x AND 0FFFFFFFFH);
END Split;

(** Bitwise shift n bits left *)
PROCEDURE LSR* (x : LONGWORD; n : INTEGER): LONGWORD;
VAR div : LONGWORD;
BEGIN
    div := VAL(LONGWORD, 2) << (VAL(LONGWORD,n) - 1);
    RETURN x DIV div
END LSR;

BEGIN
    x := X; (* expression out of bounds *)
    x := 0FFFFFFFFFFFFFFFFH; (* expression out of bounds *)
    x := MAX(SYSTEM.CARD64); (* OK *)
    x := Combine(0FFFFFFFFH, 0FFFFFFFFH); (* OK *)
END test64BitConstant.

Work around is to create a global variable
and export this as read only.

2. Inlining of procedures 
   Small procedures must be compiled with other modules in order to
   be inlined. Linking with a .lib file will not permitt inlining.

3. Option '-nooptimize+' seems to crash the compiler.

4. Right shift operator >> is wrong for 64bit and gives
   the same result as left shift operator <<. DIV can
   be used as work around. See above.

5. doreorder option sometimes creates problems.

6. XOR operation on 64bit sets seems to be wrong.

Additional SYSTEM content
-------------------------

CARD64, INT64 & SET64, LONGLONGINT, LONGLONGCARD

64bit datatypes defined, but not fully supported (ref. issue above).

BYTES(v): LONGINT;

Returns the size in bytes of v.

EVAL(p : PROC);

Evaluate p (with optional arguments) and discard results.

SUCC(x)

Function return x + 1, similar to INC, but a function.

PRED(x)

Function return x - 1, similar to DEC, but a function.

These can be used as:

<* +o2addkwd *>
FROM SYSTEM IMPORT PRED,SUCC;

FOR i := 0 TO PRED(llen) doreorder
    ....


Additional M2EXTENSIONS
-----------------------

Logical infix shift operators << and >> defined for cardinal types.
Logical operators AND, OR and NOT defined for cardinal types.