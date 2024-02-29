MODULE LongRealMan;

IMPORT SYSTEM, Type;
IMPORT Base := LongRealBase;

TYPE
    WORD = Type.WORD;

(** Return a `LONGREAL` with the magnitude (absolute value) of x but the sign of y. *)
PROCEDURE CopySign*(x, y : LONGREAL): LONGREAL;
    VAR hx, hy : WORD;
BEGIN
    hx := Base.GetHighWord(x);
    hy := Base.GetHighWord(y);
    Base.SetHighWord(x, (hx AND 07FFFFFFFH) OR (hy AND 080000000H));
    RETURN x
END CopySign;

END LongRealMan.