MODULE LongRealPowAbs;

IMPORT SYSTEM, Type;
IMPORT Base := LongRealBase;

TYPE
    WORD = Type.WORD;

(** Return absolute value of x. *)
PROCEDURE Abs*(x : LONGREAL): LONGREAL;
    VAR high : WORD;
BEGIN
    high := Base.GetHighWord(x);
    Base.SetHighWord(x, high AND 07FFFFFFFH);
    RETURN x
END Abs;

END LongRealPowAbs.