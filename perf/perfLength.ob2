<*  +MAIN *>
(* Test builtin LENGTH procedure against  ArrayOfChar.Length and simple WHILE loop *)
MODULE test;
<*+NOPTRALIAS*>
<*-SPACE*>
<*-GENHISTORY*>
<*+DOREORDER*>
<* ALIGNMENT="4"*>
<*+PROCINLINE*>
<*-CHECKINDEX*>
<*-CHECKRANGE*>
<*-CHECKNIL*>
<*-IOVERFLOW*>
<*-COVERFLOW*>
<*-GENDEBUG*>
<*-LINENO*>

IMPORT SYSTEM, Timing := O2Timing, Char, ShortInt, ArrayOfChar, OSStream;

CONST
    BLOCK_SIZE = 4;
    NULLMASK1 = 01010101H;
    NULLMASK2 = 80808080H;

TYPE
    WRD = SYSTEM.CARD32;
    SET32 = SYSTEM.SET32;

VAR
  Str : ARRAY 1024 OF CHAR;
  i, j : LONGINT;

PROCEDURE FindNull(word: WRD): BOOLEAN;
BEGIN
    IF (VAL(SET32, word - 01010101H) * (-VAL(SET32, word)) * VAL(SET32, NULLMASK2)) # {} THEN
        RETURN TRUE;
    END;
    RETURN FALSE;
END FindNull;

(** Find length of C style null terminated string or length of array if not null terminated *)
PROCEDURE Length (str-: ARRAY OF CHAR) : LONGINT ;
VAR
    i, high: LONGINT ;
    word: WRD ;
BEGIN
    i := 0;
    high := LEN(str) - 1;
   (* Check block by block *)
   (* https://graphics.stanford.edu/~seander/bithacks.html#ZeroInWord *)
   LOOP
        IF (i > (high - BLOCK_SIZE)) THEN
            EXIT;
        END;
        SYSTEM.GET(SYSTEM.ADR(str[i]), word);
        IF FindNull(word) THEN
            EXIT;
        END;
        INC(i, BLOCK_SIZE);
   END;
   (* Find position in last block *)
   WHILE (i <= high) & (str[i] # Char.NUL) DO
      INC(i);
   END;
   RETURN i;
END Length ;

PROCEDURE Test1;
VAR
  res : LONGINT;
BEGIN
    res := Length(Str);
END Test1;

PROCEDURE Test2;
VAR
  res : LONGINT;
BEGIN
    res := ArrayOfChar.Length(Str);
END Test2;

PROCEDURE Test3;
VAR
  res : LONGINT;
BEGIN
    res := LENGTH(Str);
END Test3;

PROCEDURE Test4;
VAR
  i : LONGINT;
BEGIN
    i := 0;
    WHILE (i < LEN(Str)) & (Str[i] # 0C) DO
        INC(i);
    END;
END Test4;

CONST LOOPS = 999999;

BEGIN
    FOR i:= 0 TO LEN(Str) - 1 DO
        Str[i] := CHR(ShortInt.Random(ORD('a'), ORD('Z')));
    END;
    j := LEN(Str);
    FOR i := 0 TO 6 DO
        Str[j - 1] := Char.NUL;
        OSStream.stdout.Format('String length = %d\n', LENGTH(Str));
        Timing.StartTimer();
        Timing.Timing("Length(Str)", Test1, LOOPS);
        Timing.Timing("ArrayOfChar.Length(Str)", Test2, LOOPS);
        Timing.Timing("LENGTH(Str)", Test3, LOOPS);
        Timing.Timing("SimpleLoop", Test4, LOOPS);
        OSStream.stdout.Format('\n');
        j := j DIV 2;
    END;
END test.