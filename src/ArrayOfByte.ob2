<* IF ~ DEFINED(OPTIMIZE_SIZE) THEN *> <* NEW OPTIMIZE_SIZE- *>  <* END *>
(** Operations on ARRAY OF BYTE. *)
MODULE ArrayOfByte ;

IMPORT Const, Integer, LongInt, Word, Type, SYSTEM;

CONST
    NULLMASK1 = 01010101H;
    NULLMASK2 = 80808080H;
    HSTART = 0811C9DC5H;
    HFACTOR = 01000193H;

TYPE
    BYTE = Type.BYTE;
    WORD = Type.WORD;
    SET32 = Type.SET32;

(** Fill array with WORD value *)
PROCEDURE FillWord* (VAR dst : ARRAY OF BYTE; val := {0,0,0,0} : ARRAY 4 OF BYTE; cnt := -1 : LONGINT);
    VAR
        i, high: LONGINT ;
        word: WORD ;
    
    PROCEDURE FWord;
    BEGIN
        SYSTEM.PUT(SYSTEM.ADR(dst[i]), word);
        INC(i, Const.WORDSIZE);
    END FWord;
BEGIN
    i := 0;
    IF cnt = 0 THEN RETURN;
    ELSIF cnt > 0 THEN high := LongInt.Min(SYSTEM.BYTES(dst), 4*cnt);
    ELSE high := LEN(dst) END;
    ASSERT(high MOD 4 = 0);
<* IF ((alignment = "4") OR (alignment = "8")) AND ~OPTIMIZE_SIZE THEN *>
    (* Loop unrolling 4x *)
    word := VAL(WORD, val[3])*16777216 + VAL(WORD, val[2])*65536 + VAL(WORD, val[1])*256 + VAL(WORD, val[0]);
    LOOP
        IF i > (high - 4*Const.WORDSIZE) THEN EXIT END;
        FWord;
        FWord;
        FWord;
        FWord;
    END;
    (* Set block by block *)
    LOOP
        IF i > (high - Const.WORDSIZE) THEN EXIT END;
        FWord;
    END;
<* ELSE *>
    WHILE i < high DO
        dst[i] := val[i MOD 4];
        INC(i);
    END;
<* END *>
END FillWord;

(** Fill array with byte value *)
PROCEDURE Fill* (VAR dst : ARRAY OF BYTE; val := 0 : BYTE; cnt := -1 : LONGINT);
    VAR
        i, high: LONGINT ;
        word: WORD ;
        PROCEDURE FWord;
    BEGIN
        SYSTEM.PUT(SYSTEM.ADR(dst[i]), word);
        INC(i, Const.WORDSIZE);
    END FWord;
BEGIN
    i := 0;
    IF cnt = 0 THEN
        RETURN;
    ELSIF cnt > 0 THEN
        high := LongInt.Min(SYSTEM.BYTES(dst), cnt);
    ELSE
        high := SYSTEM.BYTES(dst);
    END;
<* IF ((alignment = "4") OR (alignment = "8")) AND ~OPTIMIZE_SIZE THEN *>
    (* Loop unrolling 4x *)
    word := Word.FillByte(val);
    LOOP
        IF i > (high - 4*Const.WORDSIZE) THEN EXIT END;
        FWord;
        FWord;
        FWord;
        FWord;
    END;
    (* Set block by block *)
    LOOP
        IF i > (high - Const.WORDSIZE) THEN EXIT END;
        FWord;
    END;
<* END *>
    WHILE i < high DO
        dst[i] := val;
        INC(i);
    END;
END Fill;

(** Fill array with zeros *)
PROCEDURE Zero* (VAR dst : ARRAY OF BYTE);
BEGIN Fill(dst, 0)
END Zero;

(** Copy from src to dst with optional cnt bytes, otherwise smallest size *)
PROCEDURE Copy* (VAR dst : ARRAY OF BYTE; src- : ARRAY OF BYTE; cnt := -1 : LONGINT);
    VAR
        i: LONGINT ;
        word: WORD ;
    
    PROCEDURE CopyWord;
    BEGIN
        SYSTEM.GET(SYSTEM.ADR(src[i]), word);
        SYSTEM.PUT(SYSTEM.ADR(dst[i]), word);
        INC(i, Const.WORDSIZE);
    END CopyWord;
BEGIN
    IF cnt = 0 THEN RETURN;
    ELSIF cnt < 0 THEN
        cnt := LongInt.Min(SYSTEM.BYTES(dst), SYSTEM.BYTES(src));
    ELSE
        cnt := LongInt.Min(cnt, LongInt.Min(SYSTEM.BYTES(dst), SYSTEM.BYTES(src)));
    END;
    i := 0;
<* IF ((alignment = "4") OR (alignment = "8")) AND ~OPTIMIZE_SIZE THEN *>
    (* Loop unrolling 4x *)
    LOOP
        IF i > (cnt - 4*Const.WORDSIZE) THEN EXIT END;
        CopyWord;
        CopyWord;
        CopyWord;
        CopyWord;
    END;
    (* Set block by block *)
    LOOP
        IF i > (cnt - Const.WORDSIZE) THEN EXIT END;
        CopyWord;
    END;
<* END *>
    WHILE i < cnt DO dst[i] := src[i]; INC(i) END;
END Copy;

(**
Compare byte arrays returns

* 0: if left = right
* -1: if left < right
* +1: if left > right
*)
PROCEDURE Compare* (left-, right- : ARRAY OF BYTE): INTEGER;
    VAR
        i, high, hleft, hright: LONGINT ;
        lword, rword: WORD ;
BEGIN
    i := 0;
    hleft := SYSTEM.BYTES(left);
    hright := SYSTEM.BYTES(right);
    high := hleft;
    IF high > hright THEN high := hright END;
<* IF ((alignment = "4") OR (alignment = "8")) AND ~OPTIMIZE_SIZE THEN *>
    (* Check block by block *)
    LOOP
        IF i > (high - Const.WORDSIZE) THEN EXIT END;
        SYSTEM.GET(SYSTEM.ADR(left[i]), lword);
        SYSTEM.GET(SYSTEM.ADR(right[i]), rword);
        IF lword # rword THEN
            EXIT;
        END;
        INC(i, Const.WORDSIZE);
    END;
<* END *>
    WHILE (i < high) & (left[i] = right[i]) DO INC(i) END;
    IF i >= high THEN
        IF hleft < hright THEN RETURN -1 END;
        IF hleft > hright THEN RETURN 1 END;
        RETURN 0;
    END;
    lword := VAL(INTEGER, left[i]); rword := VAL(INTEGER, right[i]);
    IF lword> rword THEN RETURN 1
    ELSIF lword < rword THEN RETURN -1 END;
    RETURN 0;
END Compare;

(** Index of byte in array. Return -1 if not found *)
PROCEDURE Find* (val : BYTE; arr- : ARRAY OF BYTE): LONGINT;
    VAR
        i, high: LONGINT ;
        word, mask: WORD ;
    PROCEDURE Xor(x, y : WORD): WORD;
    BEGIN RETURN VAL(WORD, VAL(SET32, x) / VAL(SET32, y))
    END Xor;
BEGIN
    i := 0;
    high := SYSTEM.BYTES(arr);
<* IF ((alignment = "4") OR (alignment = "8")) AND ~OPTIMIZE_SIZE THEN *>
   (* Check block by block *)
   mask := Word.FillByte(val);
   LOOP
        IF i > (high - Const.WORDSIZE) THEN EXIT END;
        SYSTEM.GET(SYSTEM.ADR(arr[i]), word);
        word := Xor(word, mask);
        <* PUSH *>
        <* COVERFLOW - *>
        IF (VAL(SET32, word - NULLMASK1) * (-VAL(SET32, word)) * VAL(SET32, NULLMASK2)) # {} THEN
            EXIT;
        END;
        <* POP *>
        INC(i, Const.WORDSIZE);
   END;
   (* Find position in last block *)
<* END *>
    WHILE i < high DO
        IF arr[i] = val THEN RETURN i END;
        INC(i);
    END;
    RETURN -1;
END Find;

(**  Hash value of array (32bit FNV-1a) *)
<* PUSH *>
<* COVERFLOW - *>
PROCEDURE Hash* (src- : ARRAY OF BYTE; cnt := -1 : LONGINT; hash :=  HSTART : Type.CARD32): Type.CARD32;
    VAR
        i, j : LONGINT;
        word: Type.WORD ;
    PROCEDURE Xor(x, y : WORD): WORD;
    BEGIN RETURN VAL(WORD, VAL(SET32, x) / VAL(SET32, y))
    END Xor;
    (* Helper to index word *)
    PROCEDURE Get(word: ARRAY OF BYTE ; idx : LONGINT): WORD;
    BEGIN RETURN VAL(WORD, word[idx]) END Get;
    (* Hash word *)
    PROCEDURE HashWord;
    VAR j : LONGINT;
    BEGIN
        SYSTEM.GET(SYSTEM.ADR(src[i]), word);
        FOR j := 0 TO Const.WORDSIZE - 1 DO
            hash := Xor(Get(word, j), hash);
            hash := hash * HFACTOR;
        END;
        INC(i, Const.WORDSIZE);
    END HashWord;
BEGIN
    IF cnt = 0 THEN
        RETURN hash;
    ELSIF cnt < 0 THEN
        cnt := SYSTEM.BYTES(src);
    ELSE
        cnt := LongInt.Min(cnt, SYSTEM.BYTES(src));
    END;
    i := 0;
<* IF ((alignment = "4") OR (alignment = "8")) AND ~OPTIMIZE_SIZE THEN *>
    (* Loop unrolling 4x *)
    LOOP
        IF i > (cnt - 4*Const.WORDSIZE) THEN EXIT END;
        HashWord;
        HashWord;
        HashWord;
        HashWord;
    END;
    (* Check block by block *)
    LOOP
        IF i > (cnt - Const.WORDSIZE) THEN EXIT END;
        HashWord;
    END;
<* END *>
    WHILE i < cnt DO
        hash := Xor(VAL(WORD, src[i]), hash);
        hash := hash * HFACTOR;
        INC(i);
    END;
    RETURN hash;
END Hash;
<* POP *>

END ArrayOfByte.