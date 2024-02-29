(* Module with operation on `REAL` type. *)
MODULE Real;

IMPORT Const, Char, Word, Type, LongInt, xMath, RyuS2D;
IMPORT RealClass, RealMan, RealPowAbs, RealExpLog;

TYPE
    WORD = Type.WORD;

CONST
    FPZero*     = Const.FPZero;
    FPNormal*   = Const.FPNormal;
    FPSubnormal*= Const.FPSubnormal;
    FPInfinite* = Const.FPInfinite;
    FPNaN*      = Const.FPNaN;
    PI*   = 3.1415926535897932384626433832795028841972;
    E* = 2.7182818284590452353602874713526624977572;

VAR
    INF- : REAL;
    NAN- : REAL;

(** Categorizes floating point value *)
PROCEDURE FPClassify*(x : REAL): INTEGER;
BEGIN RETURN RealClass.FPClassify(x)
END FPClassify;

(** Return `TRUE` if x is a NaN (not a number), and `FALSE` otherwise. *)
PROCEDURE IsNan*(x : REAL): BOOLEAN;
BEGIN RETURN FPClassify(x) = FPNaN
END IsNan;

(** Return `TRUE` if x is a positive or negative infinity, and `FALSE` otherwise. *)
PROCEDURE IsInf*(x : REAL): BOOLEAN;
BEGIN RETURN FPClassify(x) = FPInfinite
END IsInf;

(** Return `TRUE` if x is neither an infinity nor a NaN, and `FALSE` otherwise.*)
PROCEDURE IsFinite*(x : REAL): BOOLEAN;
BEGIN RETURN ~(IsNan(x) OR IsInf(x))
END IsFinite;

(** Return `TRUE` if x is neither an infinity nor a NaN or Zero, and `FALSE` otherwise.*)
PROCEDURE IsNormal*(x : REAL): BOOLEAN;
BEGIN RETURN FPClassify(x) = FPNormal
END IsNormal;

(** Return `TRUE` if sign bit is set. *)
PROCEDURE SignBit*(x : REAL): BOOLEAN;
BEGIN RETURN RealClass.SignBit(x)
END SignBit;

(** Return a `LONGREAL` with the magnitude (absolute value) of x but the sign of y. *)
PROCEDURE CopySign*(x, y : REAL): REAL;
BEGIN RETURN RealMan.CopySign(x, y)
END CopySign;

(** Return absolute value of x. *)
PROCEDURE Abs*(x : REAL): REAL;
BEGIN RETURN RealPowAbs.Abs(x)
END Abs;

(** Decomposes given floating point value x into a normalized fraction and an integral power of two. *)
PROCEDURE Frexp*(x : REAL; VAR exp : LONGINT): REAL;
BEGIN RETURN RealExpLog.Frexp(x, exp);
END Frexp;

(** Multiplies a floating point value x by RADIX_FLT raised to power n *)
PROCEDURE Scalbn*(x : REAL; n : LONGINT): REAL;
BEGIN RETURN RealExpLog.Scalbn(x, n);
END Scalbn;

(** Multiplies a floating point value arg by the number 2 raised to the exp power. *)
PROCEDURE Ldexp*(x : REAL; exp : LONGINT): REAL;
BEGIN
    IF ~IsFinite(x) OR (x = 0.0) THEN
        RETURN x + x
    END;
    RETURN Scalbn(x, exp)
END Ldexp;

(** Return largest of x & y *)
PROCEDURE Max* (x, y : REAL) : REAL;
BEGIN
    IF x > y THEN RETURN x;
    ELSE RETURN y END;
END Max;

(** Return smallest of x & y *)
PROCEDURE Min* (x, y : REAL) : REAL;
BEGIN
    IF x < y THEN RETURN x;
    ELSE RETURN y END;
END Min;

(** Computes the sine of the angle `REAL` x in radians *)
PROCEDURE Sin* (x: REAL) : REAL ;
BEGIN RETURN xMath.X2C_sin(x)
END Sin;

(** Computes the cosine of the angle `REAL` x in radians *)
PROCEDURE Cos* (x: REAL) : REAL ;
BEGIN RETURN xMath.X2C_cos(x)
END Cos;

(** Computes the tangent of the angle `REAL` x in radians *)
PROCEDURE Tan* (x: REAL) : REAL ;
BEGIN RETURN xMath.X2C_tan(x)
END Tan;

(** Computes the arc sine of the value `REAL` x *)
PROCEDURE ArcSin* (x: REAL) : REAL ;
BEGIN RETURN xMath.X2C_arcsin(x)
END ArcSin;

(** Computes the arc cosine of the value `REAL` x *)
PROCEDURE ArcCos* (x: REAL) : REAL ;
BEGIN RETURN xMath.X2C_arccos(x)
END ArcCos;

(** Computes the arc tangent of the value `REAL` x *)
PROCEDURE ArcTan* (x: REAL) : REAL ;
BEGIN RETURN xMath.X2C_arctan(x)
END ArcTan;

(** Computes the arc tangent of the value `REAL` x/y using the sign to select the right quadrant *)
PROCEDURE ArcTan2* (x, y: REAL) : REAL ;
BEGIN RETURN xMath.X2C_arctan2(x, y)
END ArcTan2;

(** Computes the square root of the `REAL` x *)
PROCEDURE Sqrt* (x: REAL) : REAL ;
BEGIN RETURN xMath.X2C_sqrt(x)
END Sqrt;

(** Raises the Real argument x to power y *)
PROCEDURE Pow* (x, y: REAL) : REAL ;
BEGIN RETURN xMath.X2C_pow(x, y)
END Pow;

(** Computes e raised to the power of x *)
PROCEDURE Exp* (x: REAL) : REAL ;
BEGIN RETURN xMath.X2C_exp(x)
END Exp;

(** Computes natural (e) logarithm of x *)
PROCEDURE Log* (x: REAL) : REAL ;
BEGIN RETURN xMath.X2C_ln(x)
END Log;

(** Computes common (base-10) logarithm of x *)
PROCEDURE Log10* (x: REAL) : REAL ;
BEGIN RETURN xMath.X2C_lg(x)
END Log10;

(** Computes the largest integer value not greater than x *)
PROCEDURE Floor* (x: REAL) : REAL ;
BEGIN RETURN xMath.X2C_floor(x)
END Floor;

(** Computes the nearest integer value to x, rounding halfway cases away from zero *)
PROCEDURE Round *(x: REAL) : REAL ;
BEGIN
    IF x = 0. THEN RETURN x;
    ELSIF x < 0. THEN RETURN -xMath.X2C_floor(-x + 0.5);
    ELSE RETURN xMath.X2C_floor(x + 0.5) END
END Round;

(** Next psuedo random number between min and max or 0. -> 1. if both min & max = 0*)
PROCEDURE Random* (min := 0., max := 0. : REAL): REAL;
    VAR
        x : Type.WORD;
        r : REAL;
BEGIN
    x := Word.Random() AND 0FFFFFFH; -- 2^24
    r := VAL(REAL, x) / VAL(REAL, 0FFFFFFH);
    IF (min # 0.) OR (max # 0.) THEN RETURN (max - min) * r + min;
    ELSE RETURN r END
END Random;

(**
Convert string `str` to `REAL` in either decimal or hex format and
optional `start` and `length` into `str`.

The benifit of the hex format is that the conversion is always exact.

TODO : Fix overflow/underflow (return INF/-INF) and add rounding to many digits.
       Skip trailing or leading zeros.

Return `TRUE` if success.
*)

PROCEDURE FromString* (VAR result : REAL; str- : ARRAY OF CHAR; base := 10 : INTEGER; start := 0 : LONGINT ; length := -1 : LONGINT): BOOLEAN;
    VAR
        s : ARRAY 16 OF CHAR;
        r : LONGREAL;
        res: REAL;
        val, man : WORD;
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
        ret := RyuS2D.S2D(r, str, start, length);
        result := SHORT(r);
        RETURN ret;
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
                IF man <= (MAX(WORD) - val) DIV 16 THEN
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

BEGIN
    INF := VAL(REAL, 07FF00000H);
    NAN := VAL(REAL, 07FF80000H);
END Real.