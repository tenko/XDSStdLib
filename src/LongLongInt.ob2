(** Module with operation on `LONGLONGINT` (64bit) *)
<* PUSH *>
<* doreorder- *>
MODULE LongLongInt;

IMPORT Char, LongWord, Word, SYSTEM, Type;

(** Return largest of x & y *)
PROCEDURE Max* (x, y : LONGLONGINT) : LONGLONGINT;
BEGIN
    IF x > y THEN RETURN x;
    ELSE RETURN y END;
END Max;

(** Return smallest of x & y *)
PROCEDURE Min* (x, y : LONGLONGINT) : LONGLONGINT;
BEGIN
    IF x < y THEN RETURN x;
    ELSE RETURN y END;
END Min;

(** Integer power function *)
PROCEDURE Exp(exp : LONGLONGINT; base := 2 : LONGINT): LONGLONGINT;
    VAR ret : LONGLONGINT;
BEGIN
    ASSERT((exp > 0) & (base > 1));
    IF exp = 0 THEN RETURN 1 END;
    ret := 1;
    WHILE exp > 0 DO
        IF exp MOD 2 = 1 THEN
            ret := ret * base;
        END;
        exp := exp DIV 2;
        base := base * base;
    END;
    RETURN ret;
END Exp;

(** Next psuedo random number between min and max *)
PROCEDURE Random* (min := MIN(LONGLONGINT), max := MAX(LONGLONGINT) : LONGLONGINT): LONGLONGINT;
    VAR x : Type.LONGWORD;
BEGIN
    x := LongWord.Random(VAL(Type.LONGWORD, max - min + 1));
    RETURN VAL(LONGLONGINT, x) + min;
END Random;

(**
Convert string `str` to `LONGLONGINT` and with optional `start` and `length` into `str`.

Return `TRUE` if success.
*)
PROCEDURE FromString* (VAR result : LONGLONGINT; str- : ARRAY OF CHAR; start := 0 : LONGINT ; length := -1 : LONGINT): BOOLEAN;
    VAR
        res, max : Type.CARD64;
        i, j, val: LONGINT;
        c, sign : CHAR;
        ret : BOOLEAN;
BEGIN
    i := 0; j := length;
    IF j < 0 THEN j := LEN(str) END;
    IF start < 0 THEN start := 0 END;
    res := 0;
    max := VAL(Type.CARD64, MAX(LONGLONGINT));
    max := max + 1;
    sign := '';
    ret := TRUE;
    LOOP
        IF (i >= j) OR ~ret THEN EXIT END;
        c := str[i + start];
        IF Char.IsDigit(c) THEN
            val := ORD(c) - ORD("0");
            IF res <= (max - VAL(Type.CARD64, val)) DIV 10 THEN
                res := res * 10 + VAL(Type.CARD64, val);
            ELSE
                ret := FALSE;
            END;
        ELSIF (i = 0) AND ((c = '+') OR (c = '-')) THEN
            sign := c;
        ELSIF c = Char.NUL THEN
            IF length < 0 THEN
                ret := i > ORD((sign = '+') OR (sign = '-'))
            ELSE
                ret := i = length - 1;
            END;
            EXIT;
        ELSE
            ret := FALSE;
        END;
        INC(i);
    END;
    IF sign = '-' THEN
        IF res = max THEN result := -9223372036854775808
        ELSE result := -VAL(LONGLONGINT, res) END;
    ELSE
        IF res < max THEN result := VAL(LONGLONGINT, res)
        ELSE ret := FALSE END;
    END;
    RETURN ret;
END FromString;

END LongLongInt.
<* POP *>