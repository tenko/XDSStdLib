<*  +MAIN *>
(* Test builtin COPY procedure against  ArrayOfChar.Assign *)
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

VAR
  Src, Dst : ARRAY 1024 OF CHAR;
  i, j : LONGINT;

PROCEDURE Test1;
VAR
BEGIN
    ArrayOfChar.Assign(Dst, Src);
END Test1;

PROCEDURE Test2;
BEGIN
    COPY(Src, Dst);
END Test2;

PROCEDURE Test3;
VAR
  i : LONGINT;
BEGIN
    i := 0;
    WHILE (i < LEN(Src)) & (Src[i] # 0C) DO
        Dst[i] := Src[i];
        INC(i);
    END;
END Test3;

CONST LOOPS = 999999;

BEGIN
    FOR i:= 0 TO LEN(Src) - 1 DO
        Src[i] := CHR(ShortInt.Random(ORD('a'), ORD('Z')));
    END;
    j := LEN(Src);
    FOR i := 0 TO 6 DO
        Src[j - 1] := Char.NUL;
        OSStream.stdout.Format('String length = %d\n', LENGTH(Src));
        Timing.StartTimer();
        Timing.Timing("ArrayOfChar.Assign(Dst, Src)", Test1, LOOPS);
        Timing.Timing("COPY(Src, Dst)", Test2, LOOPS);
        Timing.Timing("SimpleLoop", Test3, LOOPS);
        OSStream.stdout.Format('\n');
        j := j DIV 2;
    END;
END test.