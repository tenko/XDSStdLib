(** Module with operations on `LONGWORD` (double machine word 64bit) for low-level routines *)
MODULE LongWord ;

IMPORT SYSTEM;
IMPORT Char, Word, Type;

TYPE
    BYTE = Type.BYTE;
    WORD = Type.WORD;
    LONGWORD = Type.LONGWORD;
    SET32 = Type.SET32;
    SET64 = Type.SET64;

(** Bitwise shift n bits left (NOTE : Workaround for bug) *)
PROCEDURE LSR* (x : LONGWORD; n : INTEGER): LONGWORD;
VAR div : LONGWORD;
BEGIN
    div := VAL(LONGWORD, 2) << (VAL(LONGWORD,n) - 1);
    IF div = 0 THEN RETURN x END;
    RETURN x DIV div
END LSR;

(** Work around 32bit limit of hex constants *)
PROCEDURE Combine*(high, low : WORD): LONGWORD;
BEGIN
    RETURN (VAL(LONGWORD, high) << 32) OR VAL(LONGWORD, low);
END Combine;

(** Work around 32bit limit of hex constants *)
PROCEDURE Split*(x : LONGWORD; VAR high, low : WORD);
BEGIN
    high := VAL(WORD, LSR(x, 32) AND 0FFFFFFFFH);
    low := VAL(WORD, x AND 0FFFFFFFFH);
END Split;

(** Bit cast src to dst *)
PROCEDURE Cast*(VAR dst : ARRAY OF BYTE; src- : ARRAY OF BYTE);
    VAR i: LONGINT ;
BEGIN
    i := 0;
    WHILE i < 8 DO dst[i] := src[i]; INC(i) END;
END Cast;

(** Bit cast src value to dst *)
PROCEDURE CastConst*(VAR dst : ARRAY OF BYTE; src : LONGWORD);
BEGIN Cast(dst, src)
END CastConst;

(** 1 Bit count operation *)
PROCEDURE PopCnt*(x : LONGWORD): WORD;
    VAR lo, hi : WORD;
    PROCEDURE WordPopCnt(x : WORD): WORD;
    BEGIN
        (* http://aggregate.org/MAGIC/#Population%20Count%20(Ones%20Count) *)
        x := x - (x >> 1) AND 55555555H;
        x := (x >> 2) AND 33333333H + x AND 33333333H;
        x := ((x >> 4) + x) AND 0F0F0F0FH;
        x := x + (x >> 8);
        x := x + (x >> 16);
        RETURN x AND 0000003FH
    END WordPopCnt;
BEGIN
    Split(x, hi, lo);
    RETURN WordPopCnt(lo) + WordPopCnt(hi);
END PopCnt;

(** Leading 0 bit count operation *)
PROCEDURE LZCnt*(x : LONGWORD): WORD;
    VAR lo, hi, res : WORD;
    PROCEDURE WordLZCnt(x : WORD): WORD;
    BEGIN
        (* http://aggregate.org/MAGIC/#Population%20Count%20(Ones%20Count) *)
        x := x OR (x >> 1);
        x := x OR (x >> 2);
        x := x OR (x >> 4);
        x := x OR (x >> 8);
        x := x OR (x >> 16);
        RETURN SYSTEM.BITS(WORD) - PopCnt(x)
    END WordLZCnt;
BEGIN
    Split(x, hi, lo);
    res := WordLZCnt(hi);
    IF res = SYSTEM.BITS(WORD) THEN
        res := res + WordLZCnt(lo);
    END;
    RETURN res;
END LZCnt;

(** Next psuedo random number : 0 -> range or 2^64 (XorShift) *)
PROCEDURE Random* (range := 0 : LONGWORD): LONGWORD;
    VAR ret : LONGWORD;
BEGIN
    ret := Combine(Word.Random(), Word.Random());
    IF range = 0 THEN RETURN ret;
    ELSE RETURN ret MOD range END;
END Random;

(**
Convert string `str` to `LONGWORD` with optional `base` (10 by default) and
optional `start` and `length` into `str`.

Return `TRUE` if success.
*)
PROCEDURE FromString* (VAR result : LONGWORD; str- : ARRAY OF CHAR; base := 10 : INTEGER; start := 0 : LONGINT ; length := -1 : LONGINT): BOOLEAN;
    VAR
        i, j: LONGINT;
        val, bas: WORD;
        c : CHAR;
        ret : BOOLEAN;
BEGIN
    i := 0; j := length;
    IF j < 0 THEN j := LEN(str) END;
    IF start < 0 THEN start := 0 END;
    bas := VAL(WORD, base);
    result := 0;
    ret := TRUE;
    LOOP
        IF (i >= j) OR ~ret THEN EXIT END;
        c := Char.Upper(str[i + start]);
        IF Char.IsDigit(c) OR Char.IsLetter(c) THEN
            IF Char.IsDigit(c) THEN val := ORD(c) - ORD("0");
            ELSE val := 10 + ORD(c) - ORD("A")
            END;
            IF val < bas THEN
                IF result <= (MAX(LONGWORD) - val) DIV bas THEN
                    result := result * bas + val;
                ELSE ret := FALSE END;
            ELSE ret := FALSE END;
        ELSIF c = Char.NUL THEN
            IF length < 0 THEN ret := i > 0
            ELSE ret := i = length - 1 END;   
            EXIT;
        ELSE ret := FALSE END;
        INC(i);
    END;
    RETURN ret;
END FromString;

END LongWord.