(** Module with operation on `CHAR` type. *)
MODULE Char ;

CONST
    NUL* = CHR(00H);
    TAB* = CHR(09H);
    LF* = CHR(0AH);
    CR* = CHR(0DH);
    SPC* = CHR(020H);

(** Returns true of ch is a control character *)
PROCEDURE IsControl* (ch: CHAR) : BOOLEAN ;
BEGIN RETURN ch <= SPC
END IsControl;

(** Returns true of ch is a digit *)
PROCEDURE IsDigit* (ch: CHAR) : BOOLEAN ;
BEGIN RETURN (ch >= '0') & (ch <= '9')
END IsDigit;

(** Returns true of ch is a letter *)
PROCEDURE IsLetter* (ch: CHAR) : BOOLEAN ;
BEGIN RETURN ((ch >= 'a') & (ch <= 'z')) OR ((ch >= 'A') & (ch <= 'Z')) 
END IsLetter;

(** Returns true of ch is a white space character *)
PROCEDURE IsSpace* (ch: CHAR) : BOOLEAN ;
BEGIN RETURN (ch = TAB) OR (ch = LF) OR (ch = CR) OR (ch = SPC)
END IsSpace;

(** Returns true of ch is a lower case letter *)
PROCEDURE IsLower* (ch: CHAR) : BOOLEAN ;
BEGIN RETURN (ch >= 'a') & (ch <= 'z')
END IsLower;

(** Returns true of ch is a upper case letter *)
PROCEDURE IsUpper* (ch: CHAR) : BOOLEAN ;
BEGIN RETURN (ch >= 'A') & (ch <= 'Z')
END IsUpper;

(** Returns lower case letter or unmodified char *)
PROCEDURE Lower* (ch: CHAR) : CHAR ;
BEGIN
    IF IsUpper(ch) THEN RETURN CHR(ORD(ch) - (ORD('A') - ORD('a'))) END;
    RETURN ch;
END Lower;

(** Returns upper case letter or unmodified char *)
PROCEDURE Upper* (ch: CHAR) : CHAR ;
BEGIN
    IF IsLower(ch) THEN RETURN CHR(ORD(ch) + (ORD('A') - ORD('a'))) END;
    RETURN ch;
END Upper;

END Char.