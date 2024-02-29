MODULE RealPowAbs;

IMPORT SYSTEM, Type;
IMPORT Base := RealBase;

TYPE
    WORD = Type.WORD;

(** Return absolute value of x. *)
PROCEDURE Abs*(x : REAL): REAL;
    VAR wx : WORD;
BEGIN
    wx := Base.GetWord(x);
    wx := wx AND 07FFFFFFFH;
    RETURN Base.RealFromWord(wx)
END Abs;

END RealPowAbs.