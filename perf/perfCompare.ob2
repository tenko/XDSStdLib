<*  +MAIN *>
(* Test  function Strings.Compare against  ArrayOfChar.Compare *)
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

IMPORT SYSTEM, Timing := O2Timing, Char, ShortInt, ArrayOfChar, OSStream, Strings;

VAR
  Src, Dst : ARRAY 1024 OF CHAR;
  i, j : LONGINT;

(* ISO library standard implementation *)
PROCEDURE Compare(s1-,s2-: ARRAY OF CHAR): LONGINT;
VAR
    i: LONGINT;
    c1, c2: CHAR;
BEGIN
    i := 0;
    LOOP
        IF i <= LEN(s1) THEN c1 := s1[i] ELSE c1 := 0C END;
        IF i <= LEN(s2) THEN c2 := s2[i] ELSE c2 := 0C END;
        IF c1 > c2 THEN RETURN 1
        ELSIF c1 < c2 THEN RETURN -1
        ELSIF c1 = 0C THEN
            IF c2 = 0C THEN RETURN 0 ELSE RETURN -1 END;
        END;
        INC(i)
    END;
END Compare;

PROCEDURE Test1;
VAR
    ret : INTEGER;
BEGIN
    ret := ArrayOfChar.Compare(Dst, Src);
END Test1;

PROCEDURE Test2;
VAR
    ret : Strings.CompareResults;
BEGIN
    ret := Strings.Compare(Src, Dst);
END Test2;

PROCEDURE Test3;
VAR
    ret : LONGINT;
BEGIN
    ret := Compare(Src, Dst);
END Test3;

CONST LOOPS = 999999;

BEGIN
    FOR i:= 0 TO LEN(Src) - 1 DO
        Src[i] := CHR(ShortInt.Random(ORD('a'), ORD('Z')));
        Dst[i] := Src[i];
    END;
    j := LEN(Src);
    FOR i := 0 TO 6 DO
        Src[j - 1] := Char.NUL;
        OSStream.stdout.Format('String length = %d\n', LENGTH(Src));
        Timing.StartTimer();
        Timing.Timing("ArrayOfChar.Compare(Dst, Src)", Test1, LOOPS);
        Timing.Timing("Strings.Compare(Src, Dst)", Test2, LOOPS);
        Timing.Timing("Compare(Src, Dst)", Test3, LOOPS);
        OSStream.stdout.Format('\n');
        j := j DIV 2;
    END;
END test.