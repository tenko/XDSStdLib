<*  +MAIN *>
MODULE perfLongRealToString; 
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

IMPORT SYSTEM, Timing := O2Timing, LongStr, ConvTypes, RyuS2D, OSStream;

VAR
  Src : ARRAY 32 OF CHAR;

PROCEDURE Test1;
    VAR 
        res :ConvTypes.ConvResults;
        result : LONGREAL;
BEGIN
    LongStr.StrToReal (Src, result, res);
END Test1;

PROCEDURE Test2;
    VAR
        result : LONGREAL;
        res : BOOLEAN;
BEGIN
    res := RyuS2D.S2D(result, Src);
END Test2;

CONST LOOPS = 999999;

BEGIN
    Src := "1.7976931348623157e308";
    Timing.StartTimer();
    Timing.Timing("LongStr.StrToReal (Src, result, res)", Test1, LOOPS);
    Timing.Timing("res := RyuS2D.S2D(result, Src)", Test2, LOOPS);
END perfLongRealToString.