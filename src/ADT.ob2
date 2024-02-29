(** 
Common ADT objects
*)
MODULE ADT;

IMPORT String, ArrayOfChar, Const;

CONST
    EQUAL       = Const.EQUAL;
    GREATER     = Const.GREATER;
    LESS        = Const.LESS;
    NONCOMPARED = Const.NONCOMPARED;

TYPE
    Element* = POINTER TO ElementDesc;
    ElementDesc* = RECORD END;
    StringElement* = POINTER TO StringElementDesc;
    StringElementDesc* = RECORD(ElementDesc)
        str- : String.STRING;
    END;

(** Compare elements. Abstract method, to be reimplemneted.*)
PROCEDURE (this: Element) Compare* (e: Element): LONGINT;
BEGIN RETURN NONCOMPARED
END Compare;

(** Comapre StringElement *)
PROCEDURE (this: StringElement) Compare* (e: Element): LONGINT;
BEGIN RETURN ArrayOfChar.Compare(this.str^, e(StringElement).str^)
END Compare;

(** Allocate new StringElement from str *)
PROCEDURE NewStringElement* (str- : ARRAY OF CHAR) : StringElement;
    VAR ret : StringElement;
BEGIN
    NEW(ret);
    String.Assign(ret.str, str);
    RETURN ret
END NewStringElement;

END ADT.