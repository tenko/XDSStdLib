(**
Module with operation on `BYTE` type for low level routions.
`BYTE` is assignment compatible with, `CHAR`, `SHORTINT`, `SYSTEM.CARD8`
*)
MODULE Byte ;

IMPORT Const, SYSTEM, Word, Type;

TYPE
    BYTE* = Type.BYTE;
    CARD8* = Type.CARD8;

(** Return largest of x & y *)
PROCEDURE Max* (x, y : BYTE) : BYTE;
BEGIN
    IF VAL(CARD8, x) > VAL(CARD8, y) THEN RETURN x;
    ELSE RETURN y END
END Max;

(** Return smallest of x & y *)
PROCEDURE Min* (x, y : BYTE) : BYTE;
BEGIN
    IF VAL(CARD8, x) < VAL(CARD8, y) THEN RETURN x;
    ELSE RETURN y END
END Min;

(**
Convert string `str` to `BYTE` with optional `base` (10 by default) and
optional `start` and `length` into `str`.

Return `TRUE` if success.
*)
PROCEDURE FromString* (VAR result : BYTE; str- : ARRAY OF CHAR; base := 10 : INTEGER; start := 0 : LONGINT ; length := -1 : LONGINT): BOOLEAN;
    VAR
        res : Type.WORD;
BEGIN
    IF ~Word.FromString(res, str, base, start, length) THEN RETURN FALSE END;
    IF res > MAX(CARD8) THEN RETURN FALSE END;
    result := VAL(CARD8, res);
    RETURN TRUE;
END FromString;

END Byte.