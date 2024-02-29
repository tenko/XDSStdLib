MODULE LongRealClass;

IMPORT SYSTEM, Word, Const, Type;
IMPORT Base := LongRealBase;

TYPE
    WORD = Type.WORD;

CONST
    FPZero      = Const.FPZero;
    FPNormal    = Const.FPNormal;
    FPSubnormal = Const.FPSubnormal;
    FPInfinite  = Const.FPInfinite;
    FPNaN       = Const.FPNaN;

(** Categorizes floating point value *)
PROCEDURE FPClassify*(x : LONGREAL): INTEGER;
    VAR msw, lsw : WORD;
BEGIN
    Base.GetWords(msw, lsw, x);
    msw := msw AND 07FFFFFFFH;
    IF (msw = 000000000H) & (lsw = 000000000H) THEN
        RETURN FPZero
    ELSIF (msw >= 00100000H) & (msw <= 07FEFFFFFH) THEN
        RETURN FPNormal
    ELSIF msw <= 000FFFFFH THEN (* zero is already handled above *)
        RETURN FPSubnormal
    ELSIF (msw = 07FF00000H) & (lsw = 000000000H) THEN 
        RETURN FPInfinite
    ELSE
        --OSStream.stdout.Format("FPNaN\n");
        RETURN FPNaN
    END;
END FPClassify;

(** Return `TRUE` if sign bit is set. *)
PROCEDURE SignBit*(x : LONGREAL): BOOLEAN;
    VAR high : WORD;
BEGIN
    high := Base.GetHighWord(x);
    RETURN high AND 080000000H # 00H
END SignBit;

END LongRealClass.