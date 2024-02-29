(**
Module for basic OS functionality
*)
MODULE OS;

IMPORT SYSTEM, xosExit, ProgEnv, ProgExec,
       Char, Str := ArrayOfChar, String;

CONST
    Unknown*    = 0;
    Position*   = 1;
    Flag*       = 2;
    Parameter*  = 3;

TYPE
    Argument* =
    RECORD
        name*   : String.STRING;
        value*  : String.STRING;
        index*  : LONGINT;
        type*   : LONGINT
    END;

(**
Get program name
*)
PROCEDURE ProgramName*(VAR name : String.STRING);
BEGIN
    String.Reserve(name, ProgEnv.ProgramNameLength() + 1, FALSE);
    ProgEnv.ProgramName(name^)
END ProgramName;

(**
Get number of program arguments
*)
PROCEDURE Args*(): LONGINT;
BEGIN
    RETURN ProgEnv.ArgNumber()
END Args;

(**
Get n-th argument
*)
PROCEDURE Arg*(VAR value : String.STRING; n : LONGINT);
    VAR str : ARRAY 256 OF CHAR;
BEGIN
    ProgEnv.GetArg(n, str);
    String.Assign(value, str)
END Arg;

(**
Initialize argument parser.

The parser support a on purpose limited for unambigious
parsing. The POSIX type of arguments with space between
flag and value is ambigious and therfore not supported.

* `-f`, sets type to `Flag` and name to `f`. value is empty.
* `-fval1`, sets type to `Parameter`, name to `f` and value to `val1`

Only alpha numeric characters are supported for short arguments.

* `--flag`, sets type to `Flag` and name to `flag`. value is empty.
* `-flag=val1`, sets type to `Parameter`, name to `flag` and value to `val1`

Any character is valid after `=`.
Whitespace is supported by enclosing the value in quotes.

An invalid argument is marked with type set to `Unknown` and
with value set the argument.

Other arguments are returned as type `Position` and
with value set to the argument.
*)
PROCEDURE InitArgument*(VAR arg : Argument);
BEGIN
    arg.index := -1;
    String.Assign(arg.name, "");
    String.Assign(arg.value, "");
    arg.type := Unknown;
END InitArgument;

(**
Fetch next argument or return `FALSE` if finished
*)
PROCEDURE NextArgument*(VAR arg : Argument): BOOLEAN;
    VAR
        str : String.STRING;
        idx : LONGINT;
        c : CHAR;

        PROCEDURE Next();
        BEGIN
            IF idx < LEN(str^) THEN c := str^[idx]; INC(idx)
            ELSE c := Char.NUL END;
        END Next;
        PROCEDURE Peek() : CHAR;
        BEGIN
            IF idx < LEN(str^) THEN RETURN str^[idx]
            ELSE RETURN Char.NUL END;
        END Peek;
BEGIN
    idx := 0;
    Str.Clear(arg.name^);
    Str.Clear(arg.value^);
    arg.type := Unknown;
    
    INC(arg.index);
    IF arg.index >= Args() THEN
        arg.index := -1;
        RETURN FALSE
    END;

    Arg(str, arg.index);
    IF Peek() = '-' THEN
        Next();
        IF Peek() = '-' THEN (* Long type *)
            Next(); Next();
            LOOP
                IF (c = Char.NUL) OR (c = '=') THEN EXIT END;
                IF ~Char.IsLetter(c) AND ~Char.IsDigit(c) THEN EXIT END;
                String.AppendChar(arg.name, c);
                Next()
            END;
            IF (c = Char.NUL) AND (Str.Length(arg.name^) > 0) THEN
                arg.type := Flag;
                RETURN TRUE
            ELSIF c = '=' THEN
                Next();
                LOOP
                    IF c = Char.NUL THEN EXIT END;
                    String.AppendChar(arg.value, c);
                    Next()
                END;
                arg.type := Parameter;
                RETURN TRUE
            END;
            Str.Clear(arg.name^);
            String.Assign(arg.value, str^);
            RETURN TRUE
        ELSE (* Short type *)
            Next();
            IF Char.IsLetter(c) OR Char.IsDigit(c) THEN
                String.AppendChar(arg.name, c);
                Next();
                LOOP
                    IF c = Char.NUL THEN EXIT END;
                    IF ~Char.IsLetter(c) AND ~Char.IsDigit(c) THEN EXIT END;
                    String.AppendChar(arg.value, c);
                    Next()
                END;
                IF c = Char.NUL THEN
                    IF Str.Length(arg.value^) > 0 THEN
                        arg.type := Parameter;
                    ELSE
                        arg.type := Flag;
                    END;
                    RETURN TRUE
                END;
            END;
            Str.Clear(arg.name^);
            String.Assign(arg.value, str^);
            RETURN TRUE
        END
    ELSE
        arg.type := Position;
        String.Assign(arg.value, str^)
    END;
    RETURN TRUE
END NextArgument;

(** Check if environment variable exists *)
PROCEDURE HasEnv*(name : ARRAY OF CHAR): BOOLEAN;
BEGIN
    RETURN ProgEnv.StringLength(name) > 0
END HasEnv;

(** Get environment variable *)
PROCEDURE Env*(VAR value : String.STRING; name : ARRAY OF CHAR);
BEGIN
    String.Reserve(value, ProgEnv.StringLength(name) + 1, FALSE);
    ProgEnv.String(name, value^)
END Env;

(** Execute shell command *)
PROCEDURE Execute*(name : ARRAY OF CHAR): BOOLEAN;
    VAR ret : SYSTEM.CARD32;
BEGIN
    RETURN ProgExec.Command(name, ret)
END Execute;

(** Exit with return code *)
PROCEDURE Exit*(code : INTEGER);
BEGIN xosExit.X2C_doexit(code)
END Exit;

END OS.