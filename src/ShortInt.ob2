(** Module with operation on `SHORTINT` *)
MODULE ShortInt ;

IMPORT Word, LongInt, Type;

(** Return largest of x & y *)
PROCEDURE Max* (x, y : SHORTINT) : SHORTINT;
BEGIN
    IF x > y THEN RETURN x;
    ELSE RETURN y END
END Max;

(** Return smallest of x & y *)
PROCEDURE Min* (x, y : SHORTINT) : SHORTINT;
BEGIN
    IF x < y THEN RETURN x;
    ELSE RETURN y END
END Min;

(** Next psuedo random number between min and max *)
PROCEDURE Random* (min := MIN(SHORTINT), max := MAX(SHORTINT) : SHORTINT): SHORTINT;
    VAR x : Type.WORD;
BEGIN
    x := Word.Random(VAL(Type.WORD, ABS(max - min + 1)));
    RETURN VAL(SHORTINT, x) + min;
END Random;

(**
Convert string `str` to `SHORTINT` and with optional `start` and `length` into `str`.

Return `TRUE` if success.
*)
PROCEDURE FromString* (VAR result : SHORTINT; str- : ARRAY OF CHAR; start := 0 : LONGINT ; length := -1 : LONGINT): BOOLEAN;
    VAR res : LONGINT;
BEGIN
    IF ~LongInt.FromString(res, str, start, length) THEN RETURN FALSE END;
    IF (res > MAX(SHORTINT)) OR (res < MIN(SHORTINT)) THEN RETURN FALSE END;
    result := SHORT(SHORT(res));
    RETURN TRUE;
END FromString;

END ShortInt.