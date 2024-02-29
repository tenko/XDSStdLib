(* Module for OS path operations.*)
MODULE OSPath;

IMPORT SYSTEM, Char, ArrayOfChar, String, OSDir;

CONST
<* IF env_target = "x86nt" THEN *>
    SEP* = "\";
<* ELSE *>
    SEP* = "/";
<* END *>

(** join left and right path, ensuring only single separators *)
PROCEDURE Join*(VAR dst : String.STRING; left-, right- : ARRAY OF CHAR);
VAR
    str : String.STRING;
    i, len : LONGINT;
BEGIN
    String.Assign(dst, left);
    i := ArrayOfChar.Length(dst^);
    WHILE (i > 0) & (dst^[i - 1] = SEP) DO
        dst^[i - 1] := 00X;
        DEC(i)
    END;
    String.AppendChar(dst, SEP);
    i := 0; len := ArrayOfChar.Length(right);
    WHILE (i < len) AND (right[i] = SEP) DO INC(i) END;
    IF len - i > 0 THEN
        String.Extract(str, right, i, len - i);
        String.Append(dst, str^);
    END;
END Join;

(** Create absolute version of path *)
PROCEDURE Absolute*(VAR dst : String.STRING; path- : ARRAY OF CHAR);
    VAR cwd : String.STRING;
BEGIN
    IF ArrayOfChar.Length(path) > 0 THEN
        <* IF env_target = "x86nt" THEN *>
        IF (Char.IsLetter(path[0]) & (path[1] = ":") & (path[2] = SEP)) OR
           ((path[0] = SEP) & (path[1] = SEP) & Char.IsLetter(path[2])) THEN
            String.Assign(dst, path);
            RETURN
        END
        <* ELSE *>
        IF path[0] = SEP THEN
            String.Assign(dst, path);
            RETURN
        END
        <* END *>
    END;
    OSDir.Current(cwd);
    Join(dst, cwd^, path);
END Absolute;

(** Extract filename part of path *)
PROCEDURE FileName*(VAR dst : String.STRING; path- : ARRAY OF CHAR);
    VAR
        i, len, cnt : LONGINT;
BEGIN
    len := ArrayOfChar.Length(path);
    IF len = 0 THEN String.Assign(dst, ""); RETURN END;
    i := len;
    WHILE (i > 0) & Char.IsSpace(path[i - 1]) DO DEC(i) END;
    cnt := 0;
    WHILE (i > 0) & (path[i - 1] # SEP) DO DEC(i); INC(cnt) END;
    String.Extract(dst, path, i, cnt);
END FileName;

(** Extract directory part of path *)
PROCEDURE DirName*(VAR dst : String.STRING; path- : ARRAY OF CHAR);
    VAR
        i : LONGINT;
BEGIN
    i := ArrayOfChar.Length(path) - 1;
    IF i < 0 THEN i := 0 END;
    WHILE (i > 0) & Char.IsSpace(path[i]) DO DEC(i) END;
    WHILE (i > 0) & (path[i] = SEP) DO DEC(i) END;
    WHILE (i > 0) & (path[i] # SEP) DO DEC(i) END;
    IF path[i] = SEP THEN
        IF i = 0 THEN String.Assign(dst, SEP); RETURN END;
        DEC(i)
    ELSIF i = 0 THEN 
        String.Assign(dst, '.');
        RETURN
    END;
    String.Extract(dst, path, 0, i + 1)
END DirName;

(** Extract filename extension. *)
PROCEDURE Extension*(VAR dst : String.STRING; path- : ARRAY OF CHAR);
    VAR
        i, cnt : LONGINT;
BEGIN
    i := ArrayOfChar.Length(path);
    WHILE (i > 0) & Char.IsSpace(path[i - 1]) DO DEC(i) END;
    cnt := 0;
    WHILE (i > 0) & (path[i - 1] # '.') DO DEC(i); INC(cnt) END;
    IF (i > 0) & (cnt > 0) & (path[i - 1] = '.') THEN
        String.Extract(dst, path, i - 1, cnt + 1);
    ELSE
        String.Assign(dst, "");
    END
END Extension;

(**
Match `str` against ``pattern`` similar to the unix shell.

- `"*"` - match any string including empty string except for path separator
- `"?"` - match any single character except for path separator
- Character classes are defined with brackets `"[abc]"`
- Ranges are defined with `"-"` : `"[a-Z]"`
- Range and character classes can be negated with `"!"` : `"[!a-Z]"`
 *)
PROCEDURE Match*(str-, pattern- : ARRAY OF CHAR) : BOOLEAN;
    VAR
        pidx, sidx, patback, strback : LONGINT;
        p, s  : CHAR;
        pmatch : BOOLEAN;
        PROCEDURE NextP(); BEGIN p := pattern[pidx]; INC(pidx) END NextP;
        PROCEDURE PeekP() : CHAR; BEGIN RETURN pattern[pidx] END PeekP;
        PROCEDURE NextS(); BEGIN s := str[sidx]; INC(sidx) END NextS;
        PROCEDURE Range(VAR match : BOOLEAN): BOOLEAN;
            VAR
                i : LONGINT;
                c : CHAR;
                neg : BOOLEAN;
        BEGIN
            IF (p # '[') OR  (PeekP() = ']') THEN RETURN FALSE END;
            i := pidx; neg := FALSE;
            IF PeekP() = '!' THEN neg := TRUE; NextP() END;
            LOOP
                NextP();
                IF ~Char.IsLetter(p) AND ~Char.IsDigit(p) THEN EXIT END;
                IF PeekP() = '-' THEN
                    c := p;
                    NextP(); NextP();
                    IF ~Char.IsLetter(p) AND ~Char.IsDigit(p) THEN EXIT END;
                    IF neg THEN match := match OR ~((s >= c) AND (s <= p))
                    ELSE match := match OR ((s >= c) AND (s <= p)) END;
                ELSE
                    IF neg THEN match := match OR ~(p = s)
                    ELSE match := match OR (p = s) END;
                END;
            END;
            IF p # ']' THEN pidx := i END;
            RETURN p = ']'
        END Range;
BEGIN
    pidx := 0; sidx := 0;
    patback := 0; strback := 0;
    LOOP
        NextP(); NextS();
        CASE p OF
            '?' :   IF s = Char.NUL THEN RETURN FALSE END;
                    IF s = SEP THEN RETURN FALSE END |
            '*' :   IF PeekP() = Char.NUL THEN RETURN TRUE END; (* Escape tail '*' *)
                    patback := pidx;
                    strback := sidx - 1; |
        ELSE
            pmatch := FALSE;
            IF (p = '[') AND Range(pmatch) THEN
                ;
            ELSE
                pmatch := s = p; (* normal char *)
            END;
            IF pmatch THEN
                IF p = Char.NUL THEN RETURN TRUE END;
            ELSE
                IF (s = Char.NUL) OR (patback = 0) THEN RETURN FALSE END; (* Reach end or no restart pattern *)
                IF s = SEP THEN RETURN FALSE END;
                pidx := patback;
                sidx := strback;
                INC(strback);
            END
        END
    END;
    RETURN FALSE
END Match;

END OSPath.