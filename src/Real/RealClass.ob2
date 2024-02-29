MODULE RealClass;

IMPORT SYSTEM, Word, Const, Type;
IMPORT Base := RealBase;

TYPE
    WORD = Type.WORD;

CONST
    FPZero      = Const.FPZero;
    FPNormal    = Const.FPNormal;
    FPSubnormal = Const.FPSubnormal;
    FPInfinite  = Const.FPInfinite;
    FPNaN       = Const.FPNaN;

(** Categorizes floating point value *)
PROCEDURE FPClassify*(x : REAL): INTEGER;
    VAR w : WORD;
BEGIN
    w := Base.GetWord(x);
    w := w AND 07FFFFFFFH;
    IF w = 000000000H THEN
        RETURN FPZero
    ELSIF (w > 000800000H) & (w < 07F7FFFFFH) THEN
        RETURN FPNormal
    ELSIF w <= 0007FFFFFH THEN
        RETURN FPSubnormal
    ELSIF w = 07F800000H THEN
        RETURN FPInfinite
    ELSE
        RETURN FPNaN
    END;
END FPClassify;

(** Return `TRUE` if sign bit is set. *)
PROCEDURE SignBit*(x : REAL): BOOLEAN;
    VAR wx : WORD;
BEGIN
    wx := Base.GetWord(x);
    RETURN wx AND 080000000H # 00H
END SignBit;

END RealClass.