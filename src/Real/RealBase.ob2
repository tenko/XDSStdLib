MODULE RealBase;

IMPORT SYSTEM, Type;

TYPE
    WORD = Type.WORD;

(** Bitcast REAL to 32bit WORD *)
PROCEDURE GetWord*(real : REAL): WORD;
    VAR ret : WORD;
BEGIN
    SYSTEM.GET(SYSTEM.ADR(real), ret);
    RETURN ret
END GetWord;

(** Bitcast 32bit WORD to REAL *)
PROCEDURE RealFromWord*(word : WORD): REAL;
    VAR ret : REAL;
BEGIN
    SYSTEM.PUT(SYSTEM.ADR(ret), word);
    RETURN ret
END RealFromWord;

(** Return TRUE if a positive float with bitmask x is finite. *)
PROCEDURE WordIsFinite*(x : WORD): BOOLEAN;
BEGIN RETURN x < 07F800000H
END WordIsFinite;

(** TRUE if a positive float with bitmask x is +0. *)
PROCEDURE WordIsZero*(x : WORD): BOOLEAN;
BEGIN RETURN x = 0
END WordIsZero;

(** TRUE if a non-zero positive float with bitmask x is subnormal.*)
PROCEDURE WordIsSubnormal*(x : WORD): BOOLEAN;
BEGIN RETURN x < 0800000H
END WordIsSubnormal;

END RealBase.