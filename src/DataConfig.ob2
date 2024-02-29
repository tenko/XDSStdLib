(**
`INI` file format config parser with similar functions to Python
version except for multiline values.
*)
MODULE DataConfig;

IMPORT Object, Char, Str := ArrayOfChar, String;
IMPORT Dictionary := ADTDictionary, Vector := ADTVector, Set := ADTSet;

TYPE
    (* Config Parser Class *)
    Parser* = POINTER TO ParserDesc;
    ParserDesc* = RECORD
        sections* : Set.SetStr;
        entries* : Dictionary.DictionaryStrStr;
    END;

(** Initialize Parser *)
PROCEDURE InitParser*(parser : Parser);
BEGIN
    NEW(parser.sections);
    parser.sections.Init();
    NEW(parser.entries);
    parser.entries.Init();
END InitParser;

(** Clear data *)
PROCEDURE (this : Parser) Clear*();
BEGIN
    this.sections.Clear();
    this.entries.Clear();
END Clear;

(**
Get config value.
Return `TRUE` if success.
*)
PROCEDURE (this : Parser) Get*(VAR value : String.STRING; section- : ARRAY OF CHAR; key- : ARRAY OF CHAR) : BOOLEAN;
    VAR name, ikey: String.STRING;
BEGIN
    IF (Str.Length(section) = 0) OR (Str.Length(key) = 0) THEN RETURN FALSE END;
    String.Assign(name, key);
    Str.LowerCase(name^);
    String.Format(ikey, "%s=%s", section, name^);
    RETURN this.entries.Get(ikey^, value)
END Get;

(**
Set config value.
Return `TRUE` if success.
*)
PROCEDURE (this : Parser) Set*(section- : ARRAY OF CHAR; key- : ARRAY OF CHAR; value- : ARRAY OF CHAR) : BOOLEAN;
    VAR name, ikey : String.STRING;
BEGIN
    IF (Str.Length(section) = 0) OR (Str.Length(key) = 0) THEN RETURN FALSE END;
    IF ~this.sections.In(section) THEN RETURN FALSE END;
    String.Assign(name, key);
    Str.LowerCase(name^);
    String.Format(ikey, "%s=%s", section, name^);
    RETURN this.entries.Set(ikey^, value)
END Set;

(**
Delete config value.
Return `TRUE` if success.
*)
PROCEDURE (this : Parser) Delete*(section- : ARRAY OF CHAR; key- : ARRAY OF CHAR) : BOOLEAN;
    VAR name, ikey : String.STRING;
BEGIN
    IF (Str.Length(section) = 0) OR (Str.Length(key) = 0) THEN RETURN FALSE END;
    String.Assign(name, key);
    Str.LowerCase(name^);
    String.Format(ikey, "%s=%s", section, name^);
    RETURN this.entries.Delete(ikey^)
END Delete;

(**
Delete config section and coresponding entries.
Return `TRUE` if success.
*)
PROCEDURE (this : Parser) DeleteSection*(section- : ARRAY OF CHAR) : BOOLEAN;
    VAR
        it : Dictionary.DictionaryStrStrIterator;
        keys : Vector.VectorOfString;
        name, key : String.STRING;
        res : BOOLEAN;
BEGIN
    IF Str.Length(section) = 0  THEN RETURN FALSE END;
    IF ~this.sections.In(section) THEN RETURN FALSE END;
    NEW(keys); keys.Init();
    it := this.entries.Iterator();
    WHILE it.Next() DO
        key := it.Key();
        IF Str.StartsWith(key^, section) THEN keys.Append(key^) END;
    END;
    WHILE keys.Pop(key) DO
        res := this.entries.Delete(key^)
    END;
    res := this.sections.Remove(section);
    RETURN TRUE
END DeleteSection;

(** Return `TRUE` if section exists *)
PROCEDURE (this : Parser) HasSection*(section- : ARRAY OF CHAR): BOOLEAN;
BEGIN RETURN this.sections.In(section)
END HasSection;

(** Extract Vector of sections *)
PROCEDURE (this : Parser) Sections*(): Vector.VectorOfString;
BEGIN RETURN this.sections.Values()
END Sections;

(** Write data to Stream *)
PROCEDURE (this : Parser) Write*(fh : Object.Stream): BOOLEAN;
    VAR
        it : Dictionary.DictionaryStrStrIterator;
        name, key, section : String.STRING;
        sections : Vector.VectorOfString;
        i, len : LONGINT;
BEGIN
    IF fh.Closed() OR ~fh.Writeable() THEN RETURN FALSE END;
    sections := this.Sections();
    sections.Sort();
    i := 0;
    len := sections.Size();
    WHILE i < len DO
        section := sections.At(i);
        fh.Format("[%s]\n", section^);
        it := this.entries.Iterator();
        WHILE it.Next() DO
            key := it.Key();
            IF Str.StartsWith(key^, section^) THEN
                String.Extract(name, key^, Str.Length(section^) + 1, LEN(key^));
                fh.Format("%s=%s\n", name^, it.Value()^);
            END;
        END;
        INC(i);
    END;
    RETURN TRUE;
END Write;

(**
Read from Stream.
This operation will try to append the new data.
Clear the data before operation if this is not intended.
*)
PROCEDURE (this : Parser) Read*(fh : Object.Stream): LONGINT;
    VAR
        line, key, name, value, section : String.STRING;
        i, j, slen : LONGINT;
        ch : CHAR;
        ret : BOOLEAN;
        PROCEDURE Next;
        BEGIN IF i < LEN(line^) THEN ch := line^[i]; INC(i) ELSE ch := 00X END
        END Next;
        PROCEDURE Skip();
        BEGIN WHILE Char.IsSpace(ch) DO Next() END;
        END Skip;
BEGIN
    IF fh.Closed() OR ~fh.Readable() THEN RETURN -1 END;
    String.Assign(key, "");
    String.Assign(section, "");
    String.Assign(name, "");
    String.Assign(value, "");
    j := 1; slen := 0;
    WHILE fh.ReadLine(line) DO
        i := 0;
        Next; Skip();
        IF (ch = "#") OR (ch = ";") OR (ch = 00X) THEN
            ;
        ELSIF ch = "[" THEN
            Str.Clear(section^);
            Next;
            WHILE (ch # "]") & (ch # 00X) DO
                String.AppendChar(section, ch);
                Next
            END;
            IF ch # "]" THEN RETURN j END;
            Next; Skip();
            IF ch # 00X THEN RETURN j END;
            IF Str.Length(section^) = 0 THEN RETURN j END;
            IF this.sections.In(section^) THEN RETURN j END;
            ret := this.sections.Add(section^);
            IF ret THEN INC(slen) ELSE RETURN -1 END;
        ELSE
            IF slen = 0 THEN RETURN j END;
            Str.Clear(name^);
            WHILE (ch # "=") & (ch # 00X) DO
                String.AppendChar(name, ch);
                Next
            END;
            Str.RightTrim(name^);
            IF Str.Length(name^) = 0 THEN RETURN j END;
            IF ch = "=" THEN Next END;
            Skip();
            Str.Clear(value^);
            WHILE ch # 00X DO
                String.AppendChar(value, ch);
                Next
            END;
            Str.RightTrim(value^);
            IF Str.Length(section^) = 0 THEN RETURN j END;
            Str.Clear(key^);
            Str.LowerCase(name^);
            String.Format(key, "%s=%s", section^, name^);
            ret := this.entries.Set(key^, value^);
            IF ~ret THEN RETURN -2 END;
        END;
        INC(j);
    END;
    RETURN 0;
END Read;

END DataConfig.