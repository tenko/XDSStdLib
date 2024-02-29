(* Module with operation on `LONGREAL` type. *)
<* PUSH *>
<* foverflow- *>
<* genframe+ *>
MODULE LongReal;

IMPORT Const, Type, Char, Word, LongInt, LongWord, xMath, RyuS2D;
IMPORT LongRealClass, LongRealMan, LongRealPowAbs, LongRealExpLog;

TYPE
    WORD = Type.WORD;
    LONGWORD = Type.LONGWORD;

CONST
    FPZero*     = Const.FPZero;
    FPNormal*   = Const.FPNormal;
    FPSubnormal*= Const.FPSubnormal;
    FPInfinite* = Const.FPInfinite;
    FPNaN*      = Const.FPNaN;
    PI*   = 3.1415926535897932384626433832795028841972;
    E* = 2.7182818284590452353602874713526624977572;

VAR
    INF- : LONGREAL;
    NAN- : LONGREAL;

(** Categorizes floating point value *)
PROCEDURE FPClassify*(x : LONGREAL): INTEGER;
BEGIN RETURN LongRealClass.FPClassify(x)
END FPClassify;

(** Return `TRUE` if x is a NaN (not a number), and `FALSE` otherwise. *)
PROCEDURE IsNan*(x : LONGREAL): BOOLEAN;
BEGIN RETURN FPClassify(x) = FPNaN
END IsNan;

(** Return `TRUE` if x is a positive or negative infinity, and `FALSE` otherwise. *)
PROCEDURE IsInf*(x : LONGREAL): BOOLEAN;
BEGIN RETURN FPClassify(x) = FPInfinite
END IsInf;

(** Return `TRUE` if x is neither an infinity nor a NaN, and `FALSE` otherwise.*)
PROCEDURE IsFinite*(x : LONGREAL): BOOLEAN;
BEGIN RETURN ~(IsNan(x) OR IsInf(x))
END IsFinite;

(** Return `TRUE` if x is neither an infinity nor a NaN or Zero, and `FALSE` otherwise.*)
PROCEDURE IsNormal*(x : LONGREAL): BOOLEAN;
BEGIN RETURN FPClassify(x) = FPNormal
END IsNormal;

(** Return `TRUE` if sign bit is set. *)
PROCEDURE SignBit*(x : LONGREAL): BOOLEAN;
BEGIN RETURN LongRealClass.SignBit(x)
END SignBit;

(** Return a `LONGREAL` with the magnitude (absolute value) of x but the sign of y. *)
PROCEDURE CopySign*(x, y : LONGREAL): LONGREAL;
BEGIN RETURN LongRealMan.CopySign(x, y)
END CopySign;

(** Return absolute value of x. *)
PROCEDURE Abs*(x : LONGREAL): LONGREAL;
BEGIN RETURN LongRealPowAbs.Abs(x)
END Abs;

(** Decomposes given floating point value x into a normalized fraction and an integral power of two. *)
PROCEDURE Frexp*(x : LONGREAL; VAR exp : LONGINT): LONGREAL;
BEGIN RETURN LongRealExpLog.Frexp(x, exp);
END Frexp;

(** Multiplies a floating point value x by RADIX_FLT raised to power n *)
PROCEDURE Scalbn*(x : LONGREAL; n : LONGINT): LONGREAL;
BEGIN RETURN LongRealExpLog.Scalbn(x, n);
END Scalbn;

(** Multiplies a floating point value arg by the number 2 raised to the exp power. *)
PROCEDURE Ldexp*(x : LONGREAL; exp : LONGINT): LONGREAL;
BEGIN
    IF ~IsFinite(x) OR (x = 0.0) THEN
        RETURN x + x
    END;
    RETURN Scalbn(x, exp)
END Ldexp;

(** Return largest of x & y *)
PROCEDURE Max* (x, y : LONGREAL) : LONGREAL;
BEGIN
    IF x > y THEN RETURN x;
    ELSE RETURN y END
END Max;

(** Return smallest of x & y *)
PROCEDURE Min* (x, y : LONGREAL) : LONGREAL;
BEGIN
    IF x < y THEN RETURN x;
    ELSE RETURN y END
END Min;

(** Computes the sine of the angle `LONGREAL` x in radians *)
PROCEDURE Sin* (x: LONGREAL) : LONGREAL ;
BEGIN RETURN xMath.X2C_sinl(x)
END Sin;

(** Computes the cosine of the angle `LONGREAL` x in radians *)
PROCEDURE Cos* (x: LONGREAL) : LONGREAL ;
BEGIN RETURN xMath.X2C_cosl(x)
END Cos;

(** Computes the tangent of the angle `LONGREAL` x in radians *)
PROCEDURE Tan* (x: LONGREAL) : LONGREAL ;
BEGIN RETURN xMath.X2C_tanl(x)
END Tan;

(** Computes the arc sine of the value `LONGREAL` x *)
PROCEDURE ArcSin* (x: LONGREAL) : LONGREAL ;
BEGIN RETURN xMath.X2C_arcsinl(x)
END ArcSin;

(** Computes the arc cosine of the value `LONGREAL` x *)
PROCEDURE ArcCos* (x: LONGREAL) : LONGREAL ;
BEGIN RETURN xMath.X2C_arccosl(x)
END ArcCos;

(** Computes the arc tangent of the value `LONGREAL` x *)
PROCEDURE ArcTan* (x: LONGREAL) : LONGREAL ;
BEGIN RETURN xMath.X2C_arctanl(x)
END ArcTan;

(** Computes the arc tangent of the value `LONGREAL` x/y using the sign to select the right quadrant *)
PROCEDURE ArcTan2* (x, y: LONGREAL) : LONGREAL ;
BEGIN RETURN xMath.X2C_arctan2l(x, y)
END ArcTan2;

(** Computes the square root of the `LONGREAL` x *)
PROCEDURE Sqrt* (x: LONGREAL) : LONGREAL ;
BEGIN RETURN xMath.X2C_sqrtl(x)
END Sqrt;

(** Raises the `LONGREAL` argument x to power y *)
PROCEDURE Pow* (x, y: LONGREAL) : LONGREAL ;
BEGIN RETURN xMath.X2C_powl(x, y)
END Pow;

(** Computes e raised to the power of x *)
PROCEDURE Exp* (x: LONGREAL) : LONGREAL ;
BEGIN RETURN xMath.X2C_expl(x)
END Exp;

(** Computes natural (e) logarithm of x *)
PROCEDURE Log* (x: LONGREAL) : LONGREAL ;
BEGIN RETURN xMath.X2C_lnl(x)
END Log;

(** Computes common (base-10) logarithm of x *)
PROCEDURE Log10* (x: LONGREAL) : LONGREAL ;
BEGIN RETURN xMath.X2C_lgl(x)
END Log10;

(** Computes the largest integer value not greater than x *)
PROCEDURE Floor* (x: LONGREAL) : LONGREAL ;
BEGIN RETURN xMath.X2C_floorl(x)
END Floor;

(** Computes the nearest integer value to x, rounding halfway cases away from zero *)
PROCEDURE Round *(x: LONGREAL) : LONGREAL ;
BEGIN
    IF x = 0. THEN RETURN x;
    ELSIF x < 0. THEN RETURN -xMath.X2C_floorl(-x + 0.5);
    ELSE RETURN xMath.X2C_floorl(x + 0.5) END
END Round;

(** Next psuedo random number between min and max or 0. -> 1. if both min & max = 0*)
PROCEDURE Random* (min := 0., max := 0. : LONGREAL): LONGREAL;
    VAR
        lim, x : Type.LONGWORD;
        r : LONGREAL;
BEGIN
    lim := LongWord.Combine(01FFFFFH, 0FFFFFFFFH); -- 2^53
    x := LongWord.Combine(Word.Random(), Word.Random()) AND lim;
    r := VAL(LONGREAL, x) / VAL(LONGREAL, lim);
    IF (min # 0.) OR (max # 0.) THEN RETURN (max - min) * r + min;
    ELSE RETURN r END
END Random;

(**
Convert string `str` to `LONGREAL` in either decimal or hex format and
optional `start` and `length` into `str`.

The benifit of the hex format is that the conversion is always exact.

TODO : Fix overflow/underflow (return INF/-INF) and add rounding to many digits.
       Skip trailing or leading zeros.

Return `TRUE` if success.
*)

PROCEDURE FromString* (VAR result : LONGREAL; str- : ARRAY OF CHAR; base := 10 : INTEGER; start := 0 : LONGINT ; length := -1 : LONGINT): BOOLEAN;
    VAR
        s : ARRAY 16 OF CHAR;
        res: LONGREAL;
        val, man : LONGWORD;
        exp, eval : WORD;
        i, j, k, dotidx, dig, hdig, edig: LONGINT;
        c, sign, esign : CHAR;
        ret : BOOLEAN;
BEGIN
    IF (base # 10) & (base # 16) THEN RETURN FALSE END;
    i := 0; j := length;
    IF j < 0 THEN j := LEN(str) END;
    IF j = 0 THEN RETURN FALSE END;
    IF start < 0 THEN start := 0 END;
    IF start + j > LEN(str) THEN RETURN FALSE END;
    -- Check for special reals
    k := 0;
    LOOP
        IF (k >= j) OR (k > LEN(s) - 1) THEN EXIT END;
        IF str[k + start] = 00X THEN EXIT END;
        s[k] := str[k + start];
        INC(k);
    END;
    IF str = "NAN" THEN
        result := NAN;
        RETURN TRUE
    ELSIF (str = "INF") OR (str = "+INF") THEN
        result := INF;
        RETURN TRUE
    ELSIF str = "-INF" THEN
        result := -INF;
        RETURN TRUE
    END;
    IF base = 10 THEN
        RETURN RyuS2D.S2D(result, str, start, length);
    END;
    -- Sign
    i := start; res := 0; sign := '';
    IF (str[i] = '+') OR (str[i] = '-') THEN sign := str[i]; INC(i) END;
    -- Prefix
    IF str[i] # '0' THEN RETURN FALSE END;
    INC(i);
    IF str[i] # 'x' THEN RETURN FALSE END;
    INC(i);
    -- Mantissa
    ret := TRUE; dotidx := -1;
    man := 0; dig := 0; hdig := 0;
    LOOP
        IF (i >= start + j) OR ~ret THEN EXIT END;
        c := Char.Upper(str[i]);
        IF c = 'P' THEN EXIT
        ELSIF Char.IsDigit(c) OR Char.IsLetter(c) THEN
            IF Char.IsDigit(c) THEN
                val := ORD(c) - ORD("0");
                INC(dig);
            ELSE
                val := 10 + ORD(c) - ORD("A");
                INC(hdig);
            END;
            IF val < 16 THEN
                IF man <= (MAX(LONGWORD) - val) DIV 16 THEN
                    man := man * 16 + val;
                ELSE ret := FALSE END;
            ELSE ret := FALSE
            END;
        ELSIF c = '.' THEN
            IF dotidx # -1 THEN ret := FALSE
            ELSE dotidx := dig + hdig
            END;
        ELSE ret := FALSE
        END;
        INC(i)
    END;
    -- Expect dot and P
    IF ~ret OR (dotidx = -1) OR (dig + hdig = 0) THEN RETURN FALSE END;
    IF Char.Upper(str[i]) # 'P' THEN RETURN FALSE END;
    INC(i);
    -- Exponent
    IF (str[i] = '+') OR (str[i] = '-') THEN esign := str[i]; INC(i) END;
    ret := TRUE; exp := 0; edig := 0;
    LOOP
        IF (i >= start + j) OR ~ret THEN EXIT END;
        c := Char.Upper(str[i]);
        IF c = 00X THEN EXIT;
        ELSIF Char.IsDigit(c) THEN
            INC(edig);
            eval := ORD(c) - ORD("0");
            IF exp <= (MAX(WORD) - eval) DIV 10 THEN
                exp := exp * 10 + eval;
            ELSE
                ret := FALSE;
            END;
        ELSE ret := FALSE
        END;
        INC(i);
    END;
    IF edig < 1 THEN RETURN FALSE END;
    -- Convert to REAL
    exp := LongInt.Exp(exp);
    result := man;
    i := dig + hdig;
    WHILE i > dotidx DO result := result / 16; DEC(i) END;
    IF sign = "-" THEN result := -result END;
    IF esign = "-" THEN result := result / exp;
    ELSE result := result * exp;
    END;
    RETURN ret
END FromString;

(**
Convert hi & lo 32bit numbers to `LONGREAL`.

This is neede due to a limitation in the `XDS`
compiler where 64bit hex constants is not available.
*)
PROCEDURE WordsToLongReal*(VAR dst : LONGREAL; hi, lo : Type.WORD);
    VAR tmp : Type.CARD64;

    PROCEDURE Int64Bits2Double(VAR dst : ARRAY OF Type.BYTE; src- : ARRAY OF Type.BYTE);
        VAR i: LONGINT ;
    BEGIN
        i := 0;
        WHILE i < 8 DO dst[i] := src[i]; INC(i) END;
    END Int64Bits2Double;
BEGIN
    tmp := LongWord.Combine(hi, lo);
    Int64Bits2Double(dst, tmp);
END WordsToLongReal;

BEGIN
    WordsToLongReal(INF, 07FF00000H, 0H);
    WordsToLongReal(NAN, 07FF80000H, 0H);
END LongReal.
<* POP *>