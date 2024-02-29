(** Module with operation on `LONGINT` *)
MODULE LongInt ;

IMPORT Char, Word, SYSTEM, Type;

(** Return largest of x & y *)
PROCEDURE Max* (x, y : LONGINT) : LONGINT;
BEGIN
    IF x > y THEN RETURN x;
    ELSE RETURN y END;
END Max;

(** Return smallest of x & y *)
PROCEDURE Min* (x, y : LONGINT) : LONGINT;
BEGIN
    IF x < y THEN RETURN x;
    ELSE RETURN y END;
END Min;

(** Integer power function *)
PROCEDURE Exp*(exp : LONGINT; base := 2 : LONGINT): LONGINT;
    VAR ret : LONGINT;
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
PROCEDURE Random* (min := MIN(LONGINT), max := MAX(LONGINT) : LONGINT): LONGINT;
    VAR x : Type.WORD;
BEGIN
    x := Word.Random(VAL(Type.WORD, ABS(max - min + 1)));
    RETURN VAL(LONGINT, x) + min;
END Random;

(**
Convert string `str` to `LONGINT` and with optional `start` and `length` into `str`.

Return `TRUE` if success.
*)
PROCEDURE FromString* (VAR result : LONGINT; str- : ARRAY OF CHAR; start := 0 : LONGINT ; length := -1 : LONGINT): BOOLEAN;
    VAR
        val, res, max : Type.CARD32;
        i, j: LONGINT;
        c, sign : CHAR;
        ret : BOOLEAN;
BEGIN
    i := 0; j := length;
    IF j < 0 THEN j := LEN(str) END;
    IF start < 0 THEN start := 0 END;
    res := 0;
    max := VAL(Type.CARD32, MAX(LONGINT)) + 1;
    sign := '';
    ret := TRUE;
    LOOP
        IF (i >= j) OR ~ret THEN EXIT END;
        c := str[i + start];
        IF Char.IsDigit(c) THEN
            val := ORD(c) - ORD("0");
            IF res <= (max - val) DIV 10 THEN
                res := res * 10 + val;
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
        IF res = MAX(LONGINT) + 1 THEN result := -2147483648
        ELSE result := -VAL(LONGINT, res) END;
    ELSE
        IF res < max THEN result := VAL(LONGINT, res)
        ELSE ret := FALSE END;
    END;
    RETURN ret;
END FromString;

END LongInt.