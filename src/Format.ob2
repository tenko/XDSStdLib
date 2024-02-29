(**
String formatting operating on Stream object.
*)
<* PUSH *>
<* doreorder- *>
<* foverflow- *>
MODULE Format;

IMPORT SYSTEM, Chr := Char, Const, Object, ArrayOfByte, ArrayOfChar;
IMPORT LongWord, FormStr, LongReal, DT := DateTime;

CONST
    (** Format flags *)
    Left* = Const.FmtLeft;      Right* = Const.FmtRight;    Center* = Const.FmtCenter;
    Sign* = Const.FmtSign;      Zero* = Const.FmtZero;      Spc* = Const.FmtSpc;
    Alt* = Const.FmtAlt;        Upper* = Const.FmtUpper;
    (** Date formats *)
    YYYYMMDD*       = '%y-%m-%d';
    HHMMSS*         = '%H:%M:%S';
    DATEANDTIME*    = '%y-%m-%dT%H:%M:%S';
    DATE*           = '%A %d, %B, %y';
    DATEABBR*       = '%a %d, %b, %y';

TYPE
    Arg = RECORD ["Modula"]
        CASE : INTEGER OF
        |0: card: SYSTEM.CARD32;
        |1: int : SYSTEM.INT32;
        |2: adr : SYSTEM.ADDRESS;
        |3: set : SYSTEM.SET32;
        END;
    END;
    Args = POINTER ["Modula"] TO ARRAY 2000 OF Arg;
    StrPtr = POINTER ["Modula"] TO ARRAY 2000 OF CHAR;
    LineSep = ARRAY 2 OF CHAR;
    Stream = Object.Stream;

VAR
    defaultNL : LineSep;

(**
Format `DATETIME` according to format string arguments:

* `%a` : Weekday abbreviated name : Mon .. Sun
* `%A` : Weekday full name : Monday .. Sunday
* `%w` : Weekday as number : 0 .. 6
* `%b` : Month abbreviated name : Jan .. Des
* `%B` : Month full name : Januar .. Desember
* `%Y` : Year without century : 00 - 99
* `%y` : Year with century : 0000 - 9999
* `%m` : Month zero-padded : 00 - 12
* `%d` : Day of the month zero-padded : 01 - XX
* `%W` : Week of the year zero-padded : 01 - 53
* `%H` : Hour (24-hour clock) zero-padded : 00 - 23
* `%I` : Hour (12-hour clock) zero-padded : 1 - 12
* `%p` : AM or PM
* `%M` : Minute zero-padded : 00 - 59
* `%S` : Second zero-padded : 00 - 59
* `%f` : Milliseconds zero-padded : 000 - 999
* `%Z` : Timezone : UTC+/-
* `%%` : Literal `%` char

Other characters are copied to output.
*)
PROCEDURE DateTime* (writer : Stream; datetime : DT.DATETIME; fmt- : ARRAY OF CHAR);
    TYPE
        TDayAbbr = ARRAY 7, 4 OF CHAR;
        TDay = ARRAY 7, 10 OF CHAR;
        TMonthAbbr = ARRAY 12, 4 OF CHAR;
        TMonth = ARRAY 12, 10 OF CHAR;
    CONST
        DayAbbr = TDayAbbr{"Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"};
        Day = TDay{"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"};
        MonthAbbr = TMonthAbbr{"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep",
                               "Oct", "Nov", "Dec"};
        Month = TMonth{"January", "February", "March", "April", "May", "June", "July", "August",
                       "September", "October", "November", "December"};
    VAR
        year, month, day: LONGINT;
        hour, min, sec, msec: LONGINT;
        i : LONGINT;
        ch : CHAR;
    PROCEDURE Next();
    BEGIN
        IF i < LEN(fmt) THEN ch := fmt[i]; INC(i)
        ELSE ch := 00X END;
    END Next;
    PROCEDURE Peek() : CHAR;
    BEGIN
        IF i < LEN(fmt) THEN RETURN fmt[i]
        ELSE RETURN 00X END;
    END Peek;
BEGIN
    i := 0;
    DT.DecodeDate(datetime, year, month, day);
    DT.DecodeTime(datetime, hour, min, sec, msec);
    LOOP
        Next();
        IF ch = '%' THEN
            CASE Peek() OF
                  'a' : (* Weekday abbreviated name : Mon .. Sun *)
                        writer.WriteString(DayAbbr[DT.Extract(datetime, DT.Weekday)]);
                        Next();
                | 'A' : (* Weekday full name : Monday .. Sunday *)
                        writer.WriteString(Day[DT.Extract(datetime, DT.Weekday)]);
                        Next();
                | 'w' : (* Weekday as number : 0 .. 6 *)
                        writer.Format("%d", DT.Extract(datetime, DT.Weekday));
                        Next();
                | 'b' : (* Month abbreviated name : Jan .. Des *)
                        writer.WriteString(MonthAbbr[month - 1]);
                        Next();
                | 'B' : (* Month full name : Januar .. Desember *)
                        writer.WriteString(Month[month - 1]);
                        Next();
                | 'Y' : (* Year without century : 00 - 99 *)
                        writer.Format("%02d", year MOD 100);
                        Next();
                | 'y' : (* Year with century : 0000 - 9999 *)
                        writer.Format("%04d", year);
                        Next();
                | 'm' : (* Month zero-padded : 00 - 12 *)
                        writer.Format("%02d", month);
                        Next();
                | 'd' : (* Day of the month zero-padded : 00 - XX *)
                        writer.Format("%02d", day);
                        Next();
                | 'W' : (* Week of the year zero-padded : 01 - 53 *)
                        writer.Format("%02d", DT.Extract(datetime, DT.Week));
                        Next();
                | 'H' : (* Hour (24-hour clock) zero-padded : 00 - 23 *)
                        writer.Format("%02d", hour);
                        Next();
                | 'I' : (* Hour (12-hour clock) zero-padded : 1 - 12 *)
                        IF (hour = 0) OR (hour = 12) THEN
                            writer.WriteString('12')
                        ELSE writer.Format("%02d", hour MOD 12)
                        END;
                        Next();
                | 'p' : (* AM or PM *)
                        IF hour >= 12 THEN writer.WriteString('PM')
                        ELSE writer.WriteString('AM')
                        END;
                        Next();
                | 'M' : (* Minute zero-padded : 00 - 59 *)
                        writer.Format("%02d", min);
                        Next();
                | 'S' : (* Second zero-padded : 00 - 59 *)
                        writer.Format("%02d", sec);
                        Next();
                | 'f' : (* Milliseconds zero-padded : 000 - 999 *)
                        writer.Format("%03d", msec);
                        Next();
                | 'Z' : (* Timezone : UTC *)
                        writer.Format("UTC%+d", DT.UTCOffset);
                        Next();
                | '%' :   (* Literal '%' char *)
                        writer.WriteChar('%');
                        Next();
            ELSE
                writer.WriteChar('%'); writer.WriteChar(ch);
            END;
        ELSIF ch = 00X THEN EXIT
        ELSE writer.WriteChar(ch)
        END
    END
END DateTime;

(**
Format Real to hex format.

TODO : Add rounding
*)
PROCEDURE RealHex*(writer : Stream; value : LONGREAL; UpperCase := FALSE : BOOLEAN);
    CONST
        DigitsLower = "0123456789abcdef";
        DigitsUpper = "0123456789ABCDEF";
        DBL_MIN_EXP = -1021;
    VAR
        m : LONGREAL;
        e, d : LONGINT;
BEGIN
    IF LongReal.IsNan(value) THEN writer.WriteString("NAN"); RETURN
    ELSIF LongReal.IsInf(value) THEN
        IF LongReal.SignBit(value) THEN
            writer.WriteString("-INF")
        ELSE
            writer.WriteString("INF")
        END;
        RETURN
    END;
    IF value = 0.0 THEN
        IF LongReal.SignBit(value) THEN writer.WriteChar('+') END;
        writer.WriteString("0x0.0");
        IF UpperCase THEN writer.WriteChar('P')
        ELSE writer.WriteChar('p') END;
        writer.WriteString("+0");
        RETURN
    END;
    IF LongReal.SignBit(value) THEN writer.WriteString("-0x") 
    ELSE writer.WriteString("0x")
    END;
    m := LongReal.Frexp(LongReal.Abs(value), e);
    IF e >= DBL_MIN_EXP THEN  m := LongReal.Ldexp(m, 1) END;
    e := e - 1;
    d := VAL(LONGINT, m);
    IF UpperCase THEN writer.WriteChar(DigitsUpper[d])
    ELSE writer.WriteChar(DigitsLower[d]) END;
    writer.WriteChar('.');
    m := m - VAL(LONGREAL, d);
    REPEAT
        m := m * 16.0;
        d := VAL(LONGINT, m);
        IF UpperCase THEN writer.WriteChar(DigitsUpper[d])
        ELSE writer.WriteChar(DigitsLower[d]) END;
        m := m - VAL(LONGREAL, d);
    UNTIL m = 0.0;
    IF UpperCase THEN writer.WriteChar('P')
    ELSE writer.WriteChar('p') END;
    writer.Format("%-d", e);
END RealHex;

(**
Format `LONGREAL`.

The `width` argument specifies the total field width to fill.
This can overflow depending on the `prec` argument and space
for exponent etc.

`ch` argument

* `e` : Scientific notation. The `prec` argument specifies the
  number of digits after the leading digit.
* `E` : Similar to scientific notation, but with upper case `E` for the exponent.
* `f` : Fixed-point notation. The `prec` argument specifies the
  number of digits after decimal point.
* `g` : General format. Rounds the number to `prec` significant digits.
  Then selects the format givind the most compact representation.
* `a` or `a` : Hex format.

  TODO : Add padding. Add rounding for hex format.
*)
PROCEDURE Real(writer : Stream; ch : CHAR; value : LONGREAL; width := 0 : LONGINT; prec := 6 : LONGINT; flags := {} : SET);
    CONST
        DigitsLower = "0123456789abcdef";
        DigitsUpper = "0123456789ABCDEF";
        DBL_MIN_EXP = -1021;
    VAR
        str : ARRAY 32 OF CHAR;
        fmt : ARRAY 6 OF CHAR;
        m : LONGREAL;
        i, e, d : LONGINT;

        PROCEDURE Char(ch : CHAR);
        BEGIN writer.WriteChar(ch)
        END Char;
BEGIN
    IF LongReal.IsInf(value) THEN
        IF LongReal.SignBit(value) THEN
            writer.WriteString("-INF")
        ELSE
            writer.WriteString("INF")
        END;
        RETURN
    ELSIF LongReal.IsNan(value) THEN
        writer.WriteString("NAN");
        RETURN
    END;
    IF (ch = 'a') OR (ch = 'A') THEN
        RealHex(writer, value, ch = 'A');
    ELSE
        IF (width > 0) AND (prec > 0) THEN
            fmt := "%*.*";
            ArrayOfChar.AppendChar(fmt, ch);
            FormStr.print(str, fmt, width, prec, value);
        ELSIF width > 0 THEN
            fmt := "%*";
            ArrayOfChar.AppendChar(fmt, ch);
            FormStr.print(str, fmt, width, value);
        ELSIF prec > 0 THEN
            fmt := "%.*";
            ArrayOfChar.AppendChar(fmt, ch);
            FormStr.print(str, fmt, prec, value);
        ELSE
            fmt := "%";
            ArrayOfChar.AppendChar(fmt, ch);
            FormStr.print(str, fmt, value);
        END;
        i := 0;
        WHILE (i < LEN(str)) & (str[i] # 00X) DO Char(str[i]); INC(i) END;
    END
END Real;

(**
Format `CARD64`. This is a separate method due to a limit in the `XDS`
compiler where `CARD64` is not supported by `SEQ` parameters.

* `base` : Number base. Defalts to 10.
* `width` : Total field with. Can overflow if number is bigger.

The formatting flags defaults to `Right` alignment.
The `Zero` flag fills with 0 of the formatting is right aligned.
The `Upper` flag the hex decimal letters are upper case.

The `Alt` flags prefix binary (base 2) numbers with `0b`,
octal numbers (base 8) with `0o` and hex decimal numbers
with either `0x` or `0X` depending on the `Upper` flag.
*)
PROCEDURE Cardinal*(writer : Stream; value : SYSTEM.CARD64; base := 10 : INTEGER; width := 0 : LONGINT; flags := {} : SET);
    CONST
        DigitsLower = "0123456789abcdef";
        DigitsUpper = "0123456789ABCDEF";
    VAR
        x, bas: SYSTEM.CARD64;
        i, digits, len, left, right : LONGINT;
        str : ARRAY 32 OF CHAR;

        PROCEDURE Char(ch : CHAR);
        BEGIN writer.WriteChar(ch)
        END Char;
BEGIN
    (* Check if base is valid *)
    bas := LONG(base);
    IF (bas < 2) OR (bas > 16) THEN RETURN END;
    (* Number of digits*)
    len := 0; x := value;
    REPEAT INC(len); x := x DIV bas UNTIL x = 0;
    digits := len;
    (* alternative representation *)
    IF ((flags * Alt) # {}) & ((bas = 2) OR (bas = 8) OR (bas = 16)) THEN
        INC(len, 2)
    END;
    (* Alignment *)
    left := 0; right := 0;
    IF width > len THEN
        IF (flags * Left) # {} THEN
            right := width - len
        ELSIF (flags * Center) # {} THEN
            left := (width - len) DIV 2;
            right := (width - len) - left;
        ELSE (* Default to Right *)
            left := width - len
        END
    END;
    IF (flags * Zero) = {} THEN
        WHILE left > 0 DO Char(' '); DEC(left) END;
    END;
    IF (flags * Alt) # {} THEN
        IF bas = 2 THEN Char('0'); Char('b')
        ELSIF bas = 8 THEN Char('0'); Char('o')
        ELSIF bas = 16  THEN
            Char('0');
            IF (flags * Upper) # {} THEN Char('X'); 
            ELSE Char('x');
            END;
        END;
    END;
    IF (flags * Zero) # {} THEN
        WHILE left > 0 DO Char('0'); DEC(left) END
    END;
    i := digits;
    REPEAT
        DEC(i);
        IF (flags * Upper) # {} THEN
            str[i] := DigitsUpper[SHORT(value MOD bas)];
        ELSE
            str[i] := DigitsLower[SHORT(value MOD bas)];
        END;
        value := value DIV bas;
    UNTIL value = 0;
    i := 0;
    WHILE (i < digits) DO Char(str[i]); INC(i) END;
    IF (flags * Zero) = {} THEN
        WHILE right > 0 DO Char(' '); DEC(right) END
    END;
END Cardinal;

(**
Format `LONGLONGINT`. This is a separate method due to a limit in the `XDS`
compiler where `LONGLONGINT` is not supported by `SEQ` parameters.

* `width` : Total field with. Can overflow if number is bigger.

The formatting flags defaults to `Right` alignment.
The `Zero` flag fills with 0 of the formatting is right aligned.
The `Spc` flag fills in a blank character if the number is positive.
The `Sign` flag fills in a `+` character if the number is positive.
If both `Spc` and `Sign` are given then `Sign` precedes.
*)
PROCEDURE Integer*(writer : Stream; value : LONGLONGINT; width := 0 : LONGINT; flags := {} : SET);
    VAR
        val, x : SYSTEM.CARD64;
        min : LONGLONGINT;
        i, len, left, right : LONGINT;

        PROCEDURE Char(ch : CHAR);
        BEGIN writer.WriteChar(ch)
        END Char;
BEGIN
    (* -MIN(LONGLONGINT) does not exists *)
    val := LongWord.Combine(080000000H, 000000000H); (* 64bit constants not supported *)
    ArrayOfByte.Copy(min, val);
    IF value = min THEN
        val := LongWord.Combine(080000000H, 000000000H) (* 64bit constants not supported *)
    ELSE
        (* ABS does currently not work for 64bit *)
        IF value < 0 THEN
            ArrayOfByte.Copy(val, -value)
        ELSE
            ArrayOfByte.Copy(val, value)
        END;
    END;
    (* Number of digits*)
    len := 0; x := val;
    REPEAT INC(len); x := x DIV 10 UNTIL x = 0;
    IF value < 0 THEN INC(len);
    ELSIF (flags * Sign) # {} THEN INC(len)
    ELSIF (flags * Spc) # {} THEN INC(len)
    END;
    (* Alignment *)
    left := 0; right := 0;
    IF width > len THEN
        IF (flags * Left) # {} THEN
            right := width - len
        ELSIF (flags * Center) # {} THEN
            left := (width - len) DIV 2;
            right := (width - len) - left;
        ELSE (* Default to Right *)
            left := width - len
        END
    END;
    IF (flags * Zero) = {} THEN
        WHILE left > 0 DO Char(' '); DEC(left) END;
    END;
    (* Sign *)
    IF value < 0 THEN Char('-');
    ELSIF (flags * Sign) # {} THEN Char('+')
    ELSIF (flags * Spc) # {} THEN Char(' ')
    END;
    IF (flags * Zero) # {} THEN
        WHILE left > 0 DO Char('0'); DEC(left) END
    END;
    Cardinal(writer, val, 10, 0);
    IF (flags * Zero) = {} THEN
        WHILE right > 0 DO Char(' '); DEC(right) END
    END;
END Integer;

(**
Format `ARRAY OF CHAR`. 

* `width` : Total field with. Can overflow if string is bigger.
* `prec` : The number of characters in string to add.

The formatting flags defaults to `Left` alignment.
*)
PROCEDURE String*(writer : Stream; str- : ARRAY OF CHAR; width := 0 : LONGINT; prec := 0 : LONGINT; flags := {} : SET);
    VAR
        i, strlen, left, right : LONGINT;
        PROCEDURE Char(ch : CHAR);
        BEGIN writer.WriteChar(ch)
        END Char;
BEGIN
    strlen := LENGTH(str);

    left := 0; right := 0;
    IF width > strlen THEN
        IF (flags * Right) # {} THEN
            left := width - strlen 
        ELSIF (flags * Center) # {} THEN
            left := (width - strlen) DIV 2;
            right := (width - strlen) - left;
        ELSE (* Default to Left *)
            right := width - strlen
        END
    END;
    WHILE left > 0 DO Char(' '); DEC(left) END;
    i := 0;
    IF (flags * Upper) # {} THEN
        WHILE (i < strlen) DO Char(Chr.Upper(str[i])); INC(i) END;
    ELSE
        WHILE (i < strlen) DO Char(str[i]); INC(i) END;
    END;
    WHILE right > 0 DO Char(' '); DEC(right) END
END String;

(**
Format arguments according to fmt argument string.

Syntax : ``%[align][sign]["0"]["#"][width]["." prec][type]``

Where :

* `align` : ``"<" |  ">" |  "^"``
* `sign` : ``"+" |  "-" |  " "``
* `width` : ``digit+``
* `prec` : ``digit+``
* `type` :  ``"b" |  "c" |  "d" |  "e" |  "E" |  "f" |  "g" | "o" |  "s" |  "S" |  "u" |  "x" | "X"``            

Unless the `width` argument is specified the formatting will use the
minimum needed space. Alignment has only meaning with the `width`
argument specified. The `prec` argument has different meaning depending
on the formatting `type`.

Align options :

* ``"<"`` - Left alignment. This is default for strings.
* ``">"`` - Right alignment. This is default for numbers.
* ``"^"`` - Center alignment.

Sign options (Numbers only) :

* ``"+"`` - Include sign for both positive and negative numbers.
* ``"-"`` - Include sign for negative numbers. (default)
* ``" "`` - Insert space character for positive number and negative sign for negative numbers.

Other options :

* ``"0"`` - With a right aligned number fill zeros to the left.
* ``"#"`` - Alternative representation valid for some types.

Types :

* ``"b"`` - Binary base 2 number. Alternative form add prefix of ``"0b"``
* ``"c"`` - Character argument.
* ``"d"`` - Signed decimal base 10 number.
* ``"u"`` - Unsigned decimal base 10 number.
* ``"o"`` - Octal base 8 number. Alternative form add prefix of ``"0o"``
* ``"x"`` - Hex base 16 number. Lower case version. Alternative form add prefix of ``"0x"``
* ``"X"`` - Hex base 16 number. Upper case version. Alternative form add prefix of ``"0X"``
* ``"e"`` - Real with scientific notation. The `prec` argument specifies the number of digits after the leading digit.
* ``"E"`` - Similar to scientific notation, but with upper case `E` for the exponent.
* ``"f"`` - Real with fixed-point notation. The `prec` argument specifies the number of digits after decimal point.
* ``"g"`` - Real general format. Rounds the number to `prec` significant digits. Then selects the format givind the most compact representation.
* ``"s"`` - String argument. The `prec` argument shortens the string if less than length.
* ``"S"`` - String argument. Upper case version. The `prec` argument shortens the string if less than length.

*)
PROCEDURE StreamFmt*(writer : Stream; fmt- : ARRAY OF CHAR; seq: ARRAY OF SYSTEM.BYTE);
    VAR
        args : Args;
        flags : SET;
        i, j, len, width, prec, start : LONGINT;
        ch : CHAR;

        PROCEDURE Char(ch : CHAR);
        BEGIN writer.WriteChar(ch)
        END Char;

        PROCEDURE Next;
        BEGIN IF i < LEN(fmt) THEN ch := fmt[i]; INC(i) ELSE ch := 0C END
        END Next;

        PROCEDURE NextArg;   
        BEGIN IF j < len THEN INC(j) END;
        END NextArg;

        PROCEDURE Width():LONGINT;
            VAR width : LONGINT;
        BEGIN
            width := 0;
            IF ch = '*' THEN
                width := args^[j].int;
                Next; NextArg;
            ELSE
                LOOP
                    IF (ch < '0') OR (ch > '9') THEN EXIT END;
                    width := (width * 10) + ORD(ch) - ORD("0");
                    Next
                END
            END;
            RETURN width;
        END Width;
        PROCEDURE M2String(writer : Stream; ptr : StrPtr; len : LONGINT; width := 0 : LONGINT; prec := 0 : LONGINT; flags := {} : SET);
            VAR
                i, strlen, left, right : LONGINT;
                PROCEDURE Char(ch : CHAR);
                BEGIN writer.WriteChar(ch)
                END Char;
        BEGIN
            IF (len <= 0) OR (ptr = NIL) THEN RETURN END;
            strlen := 0;
            WHILE (strlen < len) & (ptr^[strlen] # 00X) DO INC(strlen) END;
            IF (prec > 0) & (prec < strlen) THEN strlen := prec END;

            left := 0; right := 0;
            IF width > strlen THEN
                IF (flags * Right) # {} THEN
                    left := width - strlen 
                ELSIF (flags * Center) # {} THEN
                    left := (width - strlen) DIV 2;
                    right := (width - strlen) - left;
                ELSE (* Default to Left *)
                    right := width - strlen
                END
            END;
            WHILE left > 0 DO Char(' '); DEC(left) END;
            i := 0;
            IF (flags * Upper) # {} THEN
                WHILE (i < strlen) DO Char(Chr.Upper(ptr^[i])); INC(i) END;
            ELSE
                WHILE (i < strlen) DO Char(ptr^[i]); INC(i) END;
            END;
            WHILE right > 0 DO Char(' '); DEC(right) END
        END M2String;

        PROCEDURE WriteNL;
        BEGIN
            IF defaultNL[0] # 00C THEN Char(defaultNL[0]) END;
            IF defaultNL[1] # 00C THEN Char(defaultNL[1]) END;
        END WriteNL;

        PROCEDURE WriteFmt;
        BEGIN WHILE start < i DO Char(fmt[start]); INC(start) END
        END WriteFmt;

        PROCEDURE WriteM2String():BOOLEAN;
        BEGIN
            NextArg;
            IF (args^[j].int = 0) &  (j < len) THEN
                NextArg;
                M2String(writer, SYSTEM.VAL(StrPtr, args^[j - 2].adr), args^[j].int, width, prec, flags);
            ELSE RETURN FALSE
            END;
            RETURN TRUE;
        END WriteM2String;

        PROCEDURE WriteReal():BOOLEAN;
            VAR val : LONGREAL;
        BEGIN
            NextArg;
            IF j < len THEN
                NextArg;
                --Printf.printf("j = %d\n", j);
                LongReal.WordsToLongReal(val, args^[j - 1].card, args^[j - 2].card);
                Real(writer, ch, val, width, prec, flags);
            ELSE RETURN FALSE
            END;
            RETURN TRUE;
        END WriteReal;
BEGIN
    args := SYSTEM.VAL(Args, SYSTEM.ADR(seq));
    len := LEN(seq) DIV SYSTEM.BYTES(Arg);
    i := 0; j := 0;
    LOOP
        Next;
        IF ch = 00X THEN EXIT END;
        IF (ch = "%") & ((j = 0) OR (j < len)) THEN
            start := i - 1;
            Next;
            flags := {};
            LOOP
                CASE ch OF
                | '<': flags := flags + Left;
                | '^': flags := flags + Center;
                | '>': flags := flags + Right;
                | '0': flags := flags + Zero;
                | '+': flags := flags + Sign;
                | '-': ; (* Default *)
                | ' ': flags := flags + Spc;
                | '#': flags := flags + Alt;
                ELSE EXIT
                END;
                Next;
            END;
            width := Width();
            prec := 0;
            IF ch = "." THEN
                Next;
                prec := Width();
            END;
            IF prec # 0 THEN
                CASE ch OF
                | 's': IF ~WriteM2String() THEN WriteFmt ELSE NextArg END;
                | 'S': flags := flags + Upper; IF ~WriteM2String() THEN WriteFmt ELSE NextArg END;
                | 'f', 'e', 'g', 'a', 'A': IF ~WriteReal() THEN WriteFmt ELSE NextArg END;
                ELSE WriteFmt
                END;
            ELSE
                CASE ch OF
                | '%': IF (width = 0) & (prec = 0) & (flags = {}) THEN Char('%') ELSE WriteFmt END;
                | 'c': IF (width = 0) & (prec = 0) & (flags = {}) THEN Char(CHR(args^[j].card)) ELSE WriteFmt END;
                | 'd': Integer(writer, args^[j].int, width, flags); NextArg;
                | 'u': Cardinal(writer, args^[j].card, 10, width, flags); NextArg;
                | 'b': Cardinal(writer, args^[j].card, 2, width, flags); NextArg;
                | 'o': Cardinal(writer, args^[j].card, 8, width, flags); NextArg;
                | 'x': Cardinal(writer, args^[j].card, 16, width, flags); NextArg;
                | 'X': Cardinal(writer, args^[j].card, 16, width, flags + Upper); NextArg;
                | 's': IF ~WriteM2String() THEN WriteFmt ELSE NextArg END;
                | 'S': flags := flags + Upper; IF ~WriteM2String() THEN WriteFmt ELSE NextArg END;
                | 'f', 'e', 'g', 'a', 'A': IF ~WriteReal() THEN WriteFmt ELSE NextArg END;
                ELSE WriteFmt
                END;
            END;
        ELSIF ch = "\" THEN
            Next;
            CASE ch OF
            | 'n': WriteNL;
            | 'r': Char(15C);
            | 'l': Char(12C);
            | 'f': Char(14C);
            | 't': Char(11C);
            | 'e': Char(33C);
            | 'g': Char(07C);
            | '\': Char('\');
            ELSE Char('\'); Char(ch);
            END;
        ELSE Char(ch)
        END;
    END;
END StreamFmt;

(** Sets the line separator *)
PROCEDURE LineSeparator*(nl-: ARRAY OF CHAR);
BEGIN COPY(nl, defaultNL);
END LineSeparator;

BEGIN
    <* IF (env_target = "x86nt") THEN *> 
    defaultNL[0] := 0DX;
    defaultNL[1] := 0AX;
    <* ELSE *>
    defaultNL[0] := 0AX;
    defaultNL[1] := 00X;
    <* END *>
END Format.
<* POP *>