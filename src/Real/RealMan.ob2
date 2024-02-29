MODULE RealMan;

IMPORT SYSTEM, Type;
IMPORT Base := RealBase;

TYPE
    WORD = Type.WORD;

(** Return a `REAL` with the magnitude (absolute value) of x but the sign of y. *)
PROCEDURE CopySign*(x, y : REAL): REAL;
    VAR wx, wy : WORD;
BEGIN
    wx := Base.GetWord(x);
    wy := Base.GetWord(y);
    wx := wx AND 07FFFFFFFH;
    wy := wy AND 080000000H;
    wx := wx OR wy;
    RETURN Base.RealFromWord(wx)
END CopySign;

END RealMan.