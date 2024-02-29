MODULE RealExpLog;

IMPORT SYSTEM, Type;
IMPORT Base := RealBase;

TYPE
    WORD = Type.WORD;

CONST
    TWO25W = 04C000000H; (* 3.3554432000e+07 *)
    TWOM25W = 033000000H; (* 2.9802322388e-08 *)
    INFW = 07F800000H;
    NANW = 07FCF067DH;

(** Decomposes given floating point value x into a normalized fraction and an integral power of two. *)
PROCEDURE Frexp*(x : REAL; VAR exp : LONGINT): REAL;
    VAR ix, hx : WORD;
BEGIN
    hx := Base.GetWord(x);
    ix := hx AND 07FFFFFFFH;
    exp := 0;
    IF ~Base.WordIsFinite(ix) OR Base.WordIsZero(ix) THEN
        RETURN x + x (* 0,inf,nan *)
    END;
    IF Base.WordIsSubnormal(ix) THEN
        x := x * VAL(REAL, TWO25W);
        hx := Base.GetWord(x);
        ix := hx AND 07FFFFFFFH;
        exp := -25;
    END;
    exp := exp + VAL(LONGINT, ix >> 23) - 126;
    hx := hx AND 0807FFFFFH;
    hx := hx OR 03F000000H;
    RETURN Base.RealFromWord(hx)
END Frexp;

(** Multiplies a floating point value x by RADIX_FLT raised to power n *)
PROCEDURE Scalbn*(x : REAL; n : LONGINT): REAL;
    VAR 
        ix : WORD;
        k : LONGINT;
BEGIN
    ix := Base.GetWord(x);
    k := VAL(LONGINT, (ix AND 07F800000H) >> 23); (* extract exponent *)
    IF k = 0 THEN (* 0 or subnormal x *)
        IF ix AND 07FFFFFFFH = 0 THEN RETURN x END; (* +-0 *)
        x := x * VAL(REAL, TWO25W);
        ix := Base.GetWord(x);
        k := VAL(LONGINT, ((ix AND 07F800000H) >> 23)) - 25;
    END;
    IF k = 0FFH THEN RETURN x + x END; (* NaN or Inf *)
    IF n > 50000 THEN RETURN Base.RealFromWord(INFW) END; (* overflow *)
    k := k + n;
    IF k > 0FEH THEN RETURN Base.RealFromWord(INFW) END; (* overflow *)
    IF n < -50000 THEN RETURN -Base.RealFromWord(INFW) END; (* underflow *)
    IF k > 0 THEN (* normal result *)
        ix := ix AND 0807FFFFFH;
        ix := ix OR (VAL(WORD, k) << 23);
        RETURN Base.RealFromWord(ix)
    END;
    IF k <= -25 THEN RETURN -Base.RealFromWord(INFW) END; (* underflow *)
    k := k + 25; (* subnormal result *)
    ix := ix AND 0807FFFFFH;
    ix := ix OR (VAL(WORD, k) << 23);
    x := Base.RealFromWord(ix);
    RETURN x * VAL(REAL, TWOM25W);
END Scalbn;

END RealExpLog.