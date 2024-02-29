(**
Module with operations on `WORD` (machine word 32bit) for low-level routines.
*)
MODULE Word ;

IMPORT SYSTEM;
IMPORT Char, Type;

CONST
    NULLMASK1 = 01010101H;
    NULLMASK2 = 80808080H;

TYPE
    BYTE = Type.BYTE;
    WORD = Type.WORD;
    LONGWORD = Type.LONGWORD;
    SET32 = Type.SET32;

VAR
    randomSeed : WORD;

(* 1 Bit count operation *)
PROCEDURE PopCnt*(x : WORD): WORD;
BEGIN
    (* http://aggregate.org/MAGIC/#Population%20Count%20(Ones%20Count) *)
    x := x - (x >> 1) AND 55555555H;
    x := (x >> 2) AND 33333333H + x AND 33333333H;
    x := ((x >> 4) + x) AND 0F0F0F0FH;
    x := x + (x >> 8);
    x := x + (x >> 16);
    RETURN x AND 0000003FH
END PopCnt;

(* Leading 0 bit count operation *)
PROCEDURE LZCnt*(x : WORD): WORD;
BEGIN
    (* http://aggregate.org/MAGIC/#Population%20Count%20(Ones%20Count) *)
    x := x OR (x >> 1);
    x := x OR (x >> 2);
    x := x OR (x >> 4);
    x := x OR (x >> 8);
    x := x OR (x >> 16);
    RETURN SYSTEM.BITS(WORD) - PopCnt(x)
END LZCnt;

(** Swap bytes *)
PROCEDURE Swap* (x : WORD) : WORD;
BEGIN
    RETURN (x AND 0FFH) << 24 + (x AND 0FF00H) << 8 + (x AND 0FF0000H) >> 8 + (x AND 0FF000000H) >> 24; 
END Swap;

(** Fill `WORD` with `BYTE` value *)
PROCEDURE FillByte* (val : BYTE) : WORD;
BEGIN  RETURN (VAL(WORD, val) << 24) OR  (VAL(WORD, val) << 16) OR (VAL(WORD, val) << 8) OR VAL(WORD, val);
END FillByte;

(** Bit cast src to dst *)
PROCEDURE Cast*(VAR dst : ARRAY OF BYTE; src- : ARRAY OF BYTE);
    VAR i: LONGINT ;
BEGIN
    i := 0;
    WHILE i < 4 DO dst[i] := src[i]; INC(i) END;
END Cast;

(** Bit cast src value to dst *)
PROCEDURE CastConst*(VAR dst : ARRAY OF BYTE; src : WORD);
BEGIN Cast(dst, src)
END CastConst;

(** Reset random seed *)
PROCEDURE RandomSeed* (seed : WORD);
BEGIN
    randomSeed := seed;
    IF randomSeed = 0 THEN randomSeed := 1 END;
END RandomSeed;

(** Next psuedo random number : 0 -> range or 2^32 (XorShift) *)
PROCEDURE Random* (range := 0 : WORD): WORD;
    PROCEDURE Xor(x, y : WORD): WORD;
    BEGIN RETURN VAL(WORD, VAL(SET32, x) / VAL(SET32, y))
    END Xor;
BEGIN
    randomSeed := Xor(randomSeed, randomSeed << 13);
    randomSeed := Xor(randomSeed, randomSeed >> 17);
    randomSeed := Xor(randomSeed, randomSeed << 5);
    IF range = 0 THEN RETURN randomSeed;
    ELSE RETURN randomSeed MOD range END;
END Random;

(** Robert Jenkins' 32 bit integer hash function *)
PROCEDURE Hash* (value : WORD): WORD;
    PROCEDURE Xor(x, y : WORD): WORD;
    BEGIN RETURN VAL(WORD, VAL(SET32, x) / VAL(SET32, y))
    END Xor;
BEGIN
    <* PUSH *>
    <* COVERFLOW- *>
    <* CHECKRANGE- *>
    value := (value + 07ed55d16H) + (value << 12);
    value := Xor(Xor(value, 0c761c23cH), value >> 19);
    value := (value + 0165667b1H) + (value << 5);
    value := Xor(value + 0d3a2646cH, value << 9);
    value := (value + 0fd7046c5H) + (value << 3);
    value := Xor(Xor(value, 0b55a4f09H), value >> 16);
    RETURN value;
    <* POP *>
END Hash;

(**
Convert string `str` to `WORD` with optional `base` (10 by default) and
optional `start` and `length` into `str`.

Return `TRUE` if success.
*)
PROCEDURE FromString* (VAR result : WORD; str- : ARRAY OF CHAR; base := 10 : INTEGER; start := 0 : LONGINT ; length := -1 : LONGINT): BOOLEAN;
    VAR
        i, j: LONGINT;
        val, bas: WORD;
        c : CHAR;
        ret : BOOLEAN;
BEGIN
    i := 0; j := length;
    IF j < 0 THEN j := LEN(str) END;
    IF start < 0 THEN start := 0 END;
    bas := VAL(WORD, base);
    result := 0;
    ret := TRUE;
    LOOP
        IF (i >= j) OR ~ret THEN EXIT END;
        c := Char.Upper(str[i + start]);
        IF Char.IsDigit(c) OR Char.IsLetter(c) THEN
            IF Char.IsDigit(c) THEN val := ORD(c) - ORD("0");
            ELSE val := 10 + ORD(c) - ORD("A")
            END;
            IF val < bas THEN
                IF result <= (MAX(WORD) - val) DIV bas THEN
                    result := result * bas + val;
                ELSE ret := FALSE END;
            ELSE ret := FALSE END;
        ELSIF c = Char.NUL THEN
            IF length < 0 THEN ret := i > 0
            ELSE ret := i = length - 1 END;   
            EXIT;
        ELSE ret := FALSE END;
        INC(i);
    END;
    RETURN ret;
END FromString;

BEGIN randomSeed := 9;
END Word.