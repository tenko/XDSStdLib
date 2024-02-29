(** Module with operation on `INTEGER` *)
MODULE Integer ;

IMPORT Word, LongInt, Type;

(** Return largest of x & y *)
PROCEDURE Max* (x, y : INTEGER) : INTEGER;
BEGIN
    IF x > y THEN RETURN x;
    ELSE RETURN y END;
END Max;

(** Return smallest of x & y *)
PROCEDURE Min* (x, y : INTEGER) : INTEGER;
BEGIN
    IF x < y THEN RETURN x;
    ELSE RETURN y END;
END Min;

(** Next psuedo random number between min and max *)
PROCEDURE Random* (min := MIN(INTEGER), max := MAX(INTEGER) : INTEGER): INTEGER;
    VAR x : Type.WORD;
BEGIN
    x := Word.Random(VAL(Type.WORD, ABS(max - min + 1)));
    RETURN VAL(INTEGER, x) + min;
END Random;

(**
Convert string `str` to `INTEGER` and with optional `start` and `length` into `str`.

Return `TRUE` if success.
*)
PROCEDURE FromString* (VAR result : INTEGER; str- : ARRAY OF CHAR; start := 0 : LONGINT ; length := -1 : LONGINT): BOOLEAN;
    VAR res : LONGINT;
BEGIN
    IF ~LongInt.FromString(res, str, start, length) THEN RETURN FALSE END;
    IF (res > MAX(INTEGER)) OR (res < MIN(INTEGER)) THEN RETURN FALSE END;
    result := SHORT(res);
    RETURN TRUE;
END FromString;

END Integer.