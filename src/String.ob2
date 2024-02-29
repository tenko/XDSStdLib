(**
Dynamic `STRING` type.
Strings are always `NUL` terminated and possible
resized to accomodate content.

For further operations on `STRING` type check :ref:`ArrayOfChar`.
*)
MODULE String ;

IMPORT SYSTEM, Char, ArrayOfChar, ArrayOfByte, Object, Fmt := Format, DateTime, Type;

TYPE
    STRING* = Type.STRING;
    Writer* = POINTER TO WriterDesc;
    WriterDesc* = RECORD (Object.StreamDesc)
        str* : STRING;
        pos* : LONGINT;
    END;

(** Reserve capacity.
If Copy is `TRUE` then the existing content is copied when resizing. *)
PROCEDURE Reserve* (VAR dst :STRING; capacity : LONGINT; Copy := TRUE : BOOLEAN);
    VAR tmp : STRING;
BEGIN
    IF capacity < 1 THEN capacity := 1 END;
    IF dst = NIL THEN
        NEW(dst, capacity + 1);
        dst^[0] := Char.NUL;
    ELSIF LEN(dst^) <= capacity THEN
        NEW(tmp, capacity + 1);
        IF Copy THEN ArrayOfByte.Copy(tmp^, dst^, LEN(dst^))
        ELSE tmp^[capacity] := Char.NUL END;
        dst := tmp;
    END;
END Reserve;

(** Assign `src` to `dst`. *)
PROCEDURE Assign* (VAR dst :STRING; src- : ARRAY OF CHAR);
    VAR len : LONGINT;
BEGIN
    len := ArrayOfChar.Length(src);
    Reserve(dst, len, FALSE);
    ArrayOfByte.Copy(dst^, src, len);
    dst^[len] := Char.NUL;
END Assign;

(** Append `ch` to `dst`. *)
PROCEDURE AppendChar* (VAR dst : STRING; ch : CHAR);
    VAR
        n: LONGINT ;
BEGIN
    IF dst = NIL THEN n := 0
    ELSE n := ArrayOfChar.Length(dst^)
    END;
    Reserve(dst, n + 1);
    dst^[n + 0] := ch;
    dst^[n + 1] := Char.NUL;
END AppendChar ;

(** Append `src` to `dst`. *)
PROCEDURE Append* (VAR dst : STRING; src- : ARRAY OF CHAR);
    VAR
        i, n, m: LONGINT ;
        ch : CHAR;
BEGIN
    IF dst = NIL THEN n := 0
    ELSE n := ArrayOfChar.Length(dst^)
    END;
    m := ArrayOfChar.Length(src);
    Reserve(dst, n + m);
    FOR i := 0 TO m - 1 DO
        dst^[n + i] := src[i];
    END;
    dst^[n + m] := Char.NUL;
END Append ;

(** Extract substring from `src` starting at `start` and `count` length. *)
PROCEDURE Extract* (VAR dst : STRING; src- : ARRAY OF CHAR; start, count: LONGINT);
    VAR i: LONGINT ;
BEGIN
    Reserve(dst, count, FALSE);
    ArrayOfChar.Extract(dst^, src, start, count);
END Extract;

(** Insert `src` into `dst` at `start` *)
PROCEDURE Insert* (VAR dst : STRING; src : ARRAY OF CHAR; start: LONGINT);
    VAR i, n, m: LONGINT ;
BEGIN
    IF dst = NIL THEN n := 0
    ELSE n := ArrayOfChar.Length(dst^)
    END;
    m := ArrayOfChar.Length(src);
    IF start < 0 THEN start := 0 END;
    IF ((start > n) OR (m = 0 )) THEN
        RETURN;
    END;
    Reserve(dst, n + m);
    i := n;
    WHILE i > start DO
        dst^[i + m - 1] := dst^[i - 1];
        DEC(i);
    END;
    i := 0;
    WHILE (i < m) DO
        dst^[start + i] := src[i];
        INC(i);
    END;
    dst^[n + m] := Char.NUL;
END Insert;

(** Replace `old` string with `new` string starting at index `start` (default to 0) *)
PROCEDURE Replace* (VAR dst: STRING; old-, new-: ARRAY OF CHAR; start := 0 : LONGINT);
    VAR i, ll : LONGINT;
BEGIN
    IF dst = NIL THEN RETURN END;
    ll := ArrayOfChar.Length(old);
    IF ll = 0 THEN RETURN END;
    i := ArrayOfChar.Index(old, dst^, start);
    IF i # -1 THEN
        ArrayOfChar.Delete(dst^, i, ll);
        Insert(dst, new, i);
    END;
END Replace;

(** WriteChar method for Writer *)
PROCEDURE (s : Writer) WriteChar*(ch : CHAR);
BEGIN
    Reserve(s.str, s.pos + 2);
    s.str^[s.pos + 0] := ch;
    s.str^[s.pos + 1] := Char.NUL;
    INC(s.pos, 1);
END WriteChar;

(** WriteString method for Writer *)
PROCEDURE (s : Writer) WriteString*(value- : ARRAY OF CHAR);
    VAR i, len : LONGINT;
BEGIN
    i := 0;
    len := ArrayOfChar.Length(value);
    Reserve(s.str, s.pos + len + 1);
    WHILE i < len DO
        s.str^[s.pos + i] := value[i];
        INC(i);
    END;
    s.pos := s.pos + len;
    s.str^[s.pos] := Char.NUL;
END WriteString;

(** Format method for Writer *)
PROCEDURE (s : Writer) Format*(fmt- : ARRAY OF CHAR; SEQ seq: SYSTEM.BYTE);
BEGIN
    Fmt.StreamFmt(s, fmt, seq);
END Format;

(**
Append formatted string to end of `dst` according to `fmt` definition and arguments.

Reference :ref:`Format` module for further details.
*)
PROCEDURE Format*(VAR dst: STRING; fmt- : ARRAY OF CHAR; SEQ seq: SYSTEM.BYTE);
    VAR writer : Writer;
BEGIN
    NEW(writer);
    writer.str := dst;
    IF dst # NIL THEN writer.pos := ArrayOfChar.Length(dst^)
    ELSE writer.pos := 0;
    END;
    Fmt.StreamFmt(writer, fmt, seq);
    dst := writer.str;
END Format;

(**
Format `DateTime` according to `fmt` specification and append to `dst`.

Reference :ref:`Format` module for further details.
*)
PROCEDURE FormatDateTime*(VAR dst: STRING; datetime : DateTime.DATETIME; fmt- : ARRAY OF CHAR);
    VAR writer : Writer;
BEGIN
    NEW(writer);
    writer.str := dst;
    IF dst # NIL THEN writer.pos := ArrayOfChar.Length(dst^)
    ELSE writer.pos := 0;
    END;
    Fmt.DateTime(writer, datetime, fmt);
    dst := writer.str;
END FormatDateTime;

END String.