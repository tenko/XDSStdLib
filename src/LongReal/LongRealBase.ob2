MODULE LongRealBase;

IMPORT SYSTEM, Type;

TYPE
    WORD = Type.WORD;

(** Bitcast high and flow 32bit WORD to LONGREAL *)
PROCEDURE LongRealFromWords*(high, low : WORD): LONGREAL;
    VAR ret : LONGREAL;
BEGIN
    SYSTEM.PUT(SYSTEM.ADR(ret) + SYSTEM.BYTES(WORD), high);
    SYSTEM.PUT(SYSTEM.ADR(ret), low);
    RETURN ret
END LongRealFromWords;

(** Extract lower and upper 32bit WORDs from LONGREAL *)
PROCEDURE GetWords*(VAR high : WORD; VAR low : WORD; real : LONGREAL);
BEGIN
    SYSTEM.GET(SYSTEM.ADR(real) + SYSTEM.BYTES(WORD), high);
    SYSTEM.GET(SYSTEM.ADR(real), low);
END GetWords;

(** Extract higher 32bit WORD from LONGREAL *)
PROCEDURE GetHighWord*(real : LONGREAL): WORD;
    VAR ret : WORD;
BEGIN
    SYSTEM.GET(SYSTEM.ADR(real) + SYSTEM.BYTES(WORD), ret);
    RETURN ret
END GetHighWord;

(** Set higher 32bit WORD of LONGREAL *)
PROCEDURE SetHighWord*(VAR real : LONGREAL; high : WORD);
BEGIN SYSTEM.PUT(SYSTEM.ADR(real) + SYSTEM.BYTES(WORD), high);
END SetHighWord;

END LongRealBase.