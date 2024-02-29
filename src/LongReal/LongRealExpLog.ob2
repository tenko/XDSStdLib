MODULE LongRealExpLog;

IMPORT SYSTEM, Word, Const, Type;
IMPORT Base := LongRealBase;

TYPE
    WORD = Type.WORD;

CONST
    TWO54HW = 043500000H; (* 1.80143985094819840000e+16 *)
    TWO54LW = 000000000H;
    TWOM54HW = 03C900000H; (* 5.55111512312578270212e-17 *)
    TWOM54LW = 000000000H;
    INFHW = 07FF00000H; (* +Inf *)
    INFLW = 000000000H;
    NANHW = 07FF80000H; (* NaN *)
    NANLW = 0000D067DH;

(** Decomposes given floating point value x into a normalized fraction and an integral power of two. *)
PROCEDURE Frexp*(x : LONGREAL; VAR exp : LONGINT): LONGREAL;
    VAR hx, ix, lx : WORD;
BEGIN
    Base.GetWords(hx, lx, x);
    ix := hx AND 07FFFFFFFH;
    exp := 0;

    IF (ix >= 07FF00000H) OR ((ix OR lx) = 00H) THEN
        RETURN x + x; (* 0,inf,nan *)
    END;

    IF ix < 000100000H THEN (* subnormal *)
        x := x * Base.LongRealFromWords(TWO54HW, TWO54LW);
        hx := Base.GetHighWord(x);
        ix := hx AND 07FFFFFFFH;
        exp := -54;
    END;
    
    exp := exp + VAL(LONGINT, ix >> 20) - 1022;
    hx := hx AND 0800FFFFFH;
    hx := hx OR 03FE00000H;
    Base.SetHighWord(x, hx);
    RETURN x;
END Frexp;

(** Multiplies a floating point value x by RADIX_FLT raised to power n *)
PROCEDURE Scalbn*(x : LONGREAL; n : LONGINT): LONGREAL;
    VAR
        hx, lx : WORD;
        k : LONGINT;
BEGIN
    Base.GetWords(hx, lx, x);
    k := VAL(LONGINT, (hx AND 07FF00000H) >> 20); (* extract exponent *)

    IF k = 0 THEN (* 0 or subnormal x *)
        IF (lx OR (hx AND 07FFFFFFFH)) = 0 THEN
            RETURN x; (* +-0 *)
        END;
        x := x * Base.LongRealFromWords(TWO54HW, TWO54LW);
        hx := Base.GetHighWord(x);
        k := VAL(LONGINT, (hx AND 07FF00000H) >> 20 - 54);
        IF n < -50000 THEN
            RETURN -Base.LongRealFromWords(INFHW, INFLW) (* underflow *)
        END
    END;

    IF k = 07FFH THEN RETURN x + x END; (* NaN or Inf *)
    IF n > 5000 THEN RETURN Base.LongRealFromWords(INFHW, INFLW) END; (* overflow *)
    
    k := k + n;

    IF k > 07FEH THEN RETURN Base.LongRealFromWords(INFHW, INFLW) END; (* overflow *)

    IF k > 0 THEN (* normal result *)
    Base.SetHighWord(x, (hx AND 0800FFFFFH) OR (VAL(WORD, k) << 20));
        RETURN x;
    END;

    IF k < -54 THEN
        RETURN -Base.LongRealFromWords(INFHW, INFLW) (* underflow *)
    END;

    k := k + 54; (* subnormal result *)
    Base.SetHighWord(x, (hx AND 0800FFFFFH) OR (VAL(WORD, k) << 20));
    RETURN x * Base.LongRealFromWords(TWOM54HW, TWOM54LW)
END Scalbn;

END LongRealExpLog.