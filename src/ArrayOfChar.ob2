<* IF ~ DEFINED(OPTIMIZE_SIZE) THEN *> <* NEW OPTIMIZE_SIZE- *>  <* END *>
(* Operations on `ARRAY OF CHAR`. All operations sets the `NUL` termination if possible *)
MODULE ArrayOfChar ;

IMPORT ArrayOfByte, Const, Char, Integer, Word, Type, xmRTS, SYSTEM;

CONST
    NULLMASK1 = 01010101H;
    NULLMASK2 = 80808080H;

TYPE
    BYTE = Type.BYTE;
    WORD = Type.WORD; 
    SET32 = SYSTEM.SET32;
    
(* 
    Helper procedure to find zero byte in word fast .
    Must be kept in same module in order to be inlined.
    Ref.: https://graphics.stanford.edu/~seander/bithacks.html#ZeroInWord
*)
PROCEDURE FindNullInWord(word: WORD): BOOLEAN;
BEGIN
    <* PUSH *>
    <* COVERFLOW - *>
    IF (VAL(SET32, word - 01010101H) * (-VAL(SET32, word)) * VAL(SET32, NULLMASK2)) # {} THEN
        RETURN TRUE;
    END;
    <* POP *>
    RETURN FALSE;
END FindNullInWord;

(** Set length of string to 0 *)
PROCEDURE Clear* (VAR str : ARRAY OF CHAR);
BEGIN str[0] := Char.NUL;
END Clear;

(** Ensure string is `NUL` terminated *)
PROCEDURE NulTerminate* (VAR str : ARRAY OF CHAR);
BEGIN str[LEN(str) - 1] := Char.NUL;
END NulTerminate;

(** Return capacity of the array *)
PROCEDURE Capacity* (str- : ARRAY OF CHAR): LONGINT;
BEGIN RETURN LEN(str);
END Capacity;

(** Find length of C style `NUL` terminated string or length of array if not `NUL` terminated *)
PROCEDURE Length* (str-: ARRAY OF CHAR) : LONGINT ;
    VAR
        i: LONGINT ;
        word: WORD ;
BEGIN
    i := 0;
<* IF ((alignment = "4") OR (alignment = "8")) AND ~OPTIMIZE_SIZE THEN *>
   (* Check block by block *)
   LOOP
        IF (i > (LEN(str) - Const.WORDSIZE)) THEN EXIT END;
        SYSTEM.GET(SYSTEM.ADR(str[i]), word);
        IF FindNullInWord(word) THEN EXIT END;
        INC(i, Const.WORDSIZE);
   END;
   (* Find position in last block *)
<* END *>
   WHILE (i < LEN(str)) & (str[i] # Char.NUL) DO INC(i) END;
   RETURN i;
END Length ;

(** Assign `src` to `dst` *)
PROCEDURE Assign* (VAR dst : ARRAY OF CHAR; src- : ARRAY OF CHAR);
    VAR
        i: LONGINT ;
        word: WORD ;
BEGIN
    i := 0;
<* IF ((alignment = "4") OR (alignment = "8")) AND ~OPTIMIZE_SIZE THEN *>
   (* Check block by block *)
   LOOP
        IF (i > (LEN(dst) - Const.WORDSIZE)) OR  (i > (LEN(src) - Const.WORDSIZE)) THEN
            EXIT;
        END;
        SYSTEM.GET(SYSTEM.ADR(src[i]), word);
        SYSTEM.PUT(SYSTEM.ADR(dst[i]), word);
        IF FindNullInWord(word) THEN EXIT END;
        INC(i, Const.WORDSIZE);
   END;
<* END *>
    WHILE (i < LEN(dst)) & (i < LEN(src)) & (src[i] # Char.NUL) DO
        dst[i] := src[i];
        INC(i);
    END;
    IF i < LEN(dst) THEN dst[i] := Char.NUL END;
END Assign;

(** Fill string `dst` with char `chr` *)
PROCEDURE FillChar* (VAR dst : ARRAY OF CHAR; chr : CHAR);
BEGIN
    ArrayOfByte.Fill(dst, chr);
END FillChar;

(** Append `ch` to `dst` *)
PROCEDURE AppendChar* (VAR dst : ARRAY OF CHAR; ch : CHAR);
    VAR
    i, n: LONGINT ;
BEGIN
    n := Length(dst);
    IF LEN(dst) > n THEN dst[n] := ch END;
    IF LEN(dst) > n + 1 THEN dst[n + 1] := Char.NUL END;
END AppendChar ;

(** Append `src` to `dst` *)
PROCEDURE Append* (VAR dst : ARRAY OF CHAR; src- : ARRAY OF CHAR);
    VAR
    i, n: LONGINT ;
    ch : CHAR;
BEGIN
    n := Length(dst);
    i := 0;
    LOOP
        IF (i >= LEN(src)) OR (i + n >= LEN(dst)) THEN EXIT END;
        ch := src[i];
        IF ch = Char.NUL THEN EXIT END;
        dst[i + n] := ch;
        INC(i);
    END;
    IF i + n < LEN(dst) THEN dst[i + n] := Char.NUL END;
END Append ;

(** Extract substring to `dst` from `src` from `start` position and `count` length. *)
PROCEDURE Extract* (VAR dst : ARRAY OF CHAR; src- : ARRAY OF CHAR; start, count: LONGINT);
    VAR
        i: LONGINT ;
BEGIN
    i := 0;
    WHILE (i < LEN(dst)) & (i < count ) & (start < LEN(src)) & (src[start] # Char.NUL) DO
        dst[i] := src[start];
        INC(i);
        INC(start);
    END;
    IF i < LEN(dst) THEN dst[i] := Char.NUL END;
END Extract;

(**
Compare strings `left` and `right` with option `IgnoreCase` set to ignore case.

* 0 if left = right
* -1 if left < right
* +1 if left > right
*)
PROCEDURE Compare* (left-, right- : ARRAY OF CHAR; IgnoreCase := FALSE : BOOLEAN): INTEGER;
    VAR
        i, j, high: LONGINT ;
        lword, rword: WORD ;
        cl, cr : CHAR;
    PROCEDURE GetU(word: ARRAY OF BYTE ; i : LONGINT): CHAR;
    BEGIN RETURN Char.Upper(VAL(CHAR, word[i]))
    END GetU;
BEGIN
    high := LEN(left);
    IF LEN(right) < high THEN high := LEN(right) END;
    i := 0;
<* IF ((alignment = "4") OR (alignment = "8")) AND ~OPTIMIZE_SIZE THEN *>
    (* Check block by block for difference *)
    IF IgnoreCase THEN
        LOOP
            IF i > (high - Const.WORDSIZE) THEN EXIT END;
            SYSTEM.GET(SYSTEM.ADR(left[i]), lword);
            SYSTEM.GET(SYSTEM.ADR(right[i]), rword);
            FOR j := 0 TO Const.WORDSIZE - 1 DO
                IF GetU(lword, j) # GetU(rword, j) THEN EXIT END;
            END;
            IF FindNullInWord(lword) THEN RETURN 0 END;
            INC(i, Const.WORDSIZE);
        END;
    ELSE
        LOOP
            IF i > (high - Const.WORDSIZE) THEN EXIT END;
            SYSTEM.GET(SYSTEM.ADR(left[i]), lword);
            SYSTEM.GET(SYSTEM.ADR(right[i]), rword); 
            IF lword # rword THEN
                EXIT
            END;
            IF FindNullInWord(lword) THEN RETURN 0 END;
            INC(i, Const.WORDSIZE);
        END;
    END;
<* END *>
    IF IgnoreCase THEN
        LOOP
            IF i < LEN(left) THEN cl := Char.Upper(left[i]) ELSE cl := Char.NUL END;
            IF i < LEN(right) THEN cr := Char.Upper(right[i]) ELSE cr := Char.NUL END;
            IF cl > cr THEN RETURN 1
            ELSIF cl < cr THEN RETURN -1
            ELSIF cl = Char.NUL THEN
                IF cr = Char.NUL THEN RETURN 0 ELSE RETURN -1 END;
            END;
            INC(i)
        END;
    END;
    LOOP
        IF i < LEN(left) THEN cl := left[i] ELSE cl := Char.NUL END;
        IF i < LEN(right) THEN cr := right[i] ELSE cr := Char.NUL END;
        IF cl > cr THEN RETURN 1
        ELSIF cl < cr THEN RETURN -1
        ELSIF cl = Char.NUL THEN
            IF cr = Char.NUL THEN RETURN 0 ELSE RETURN -1 END;
        END;
        INC(i)
    END;
END Compare;

(** Index of `char` in `str`. One based index with zero indicating `char` not found *)
PROCEDURE IndexChar* (chr : CHAR; str- : ARRAY OF CHAR; start := 0 : LONGINT): LONGINT;
    VAR
        i: LONGINT ;
        word, mask: WORD ;
BEGIN
    i := start;
<* IF ((alignment = "4") OR (alignment = "8")) AND ~OPTIMIZE_SIZE THEN *>
    (* Ensure we are aligned *)
    WHILE (i < LEN(str)) & (i MOD Const.WORDSIZE # 0) DO
        IF str[i] = chr THEN RETURN i END;
        INC(i);
    END;
    (* Check block by block *)
    mask := Word.FillByte(chr);
    LOOP
        IF i > (LEN(str) - Const.WORDSIZE) THEN EXIT END;
        SYSTEM.GET(SYSTEM.ADR(str[i]), word);
        IF FindNullInWord(word) THEN EXIT END;
        word := VAL(WORD, VAL(SET32, word) / VAL(SET32, mask)); (* XOR *)
        IF FindNullInWord(word) THEN EXIT END;
        INC(i, Const.WORDSIZE);
    END;
    (* Find position in last block *)
<* END *>
    WHILE i < LEN(str) DO
        IF str[i] = chr THEN RETURN i END;
        INC(i);
    END;
    RETURN -1;
END IndexChar;

<* IF OPTIMIZE_SIZE THEN *>
(**
Index of `pattern` in `str`. -1 indicating pattern not found.
Note : This is a very simple implementation.
*)
PROCEDURE Index* (pattern-, str-: ARRAY OF CHAR; start := 0 : LONGINT): LONGINT;
    VAR
        i, j, lp: LONGINT;
BEGIN
    lp := Length(pattern);
    IF lp = 0 THEN RETURN 0 END;
    i := start;
    IF lp <= LEN(str) - start THEN
        WHILE (i <= (LEN(str) - lp)) & (str[i] # Char.NUL) DO
            j := 0;
            WHILE (j < lp) & (pattern[j] = str[i + j]) DO
                INC(j);
                IF j = lp THEN RETURN i END;
            END;
            INC(i);
        END;
    END;
    RETURN -1;
END Index;

<* ELSE *>
(**
Index of `pattern` in str. -1 indicating `pattern` not found.

This is the TwoWay algorithm
 * http://monge.univ-mlv.fr/~mac/Articles-PDF/CP-1991-jacm.pdf
 * https://www-igm.univ-mlv.fr/~lecroq/string/node26.html
*)
PROCEDURE Index* (pattern-, str-: ARRAY OF CHAR; start := 0 : LONGINT): LONGINT;
    VAR
        i, j, m, n: LONGINT;
        ell, memory, p, per, q: LONGINT;

    (* Computing of the maximal suffix for <= *)
    PROCEDURE MaxSuffixGEQ(VAR period : LONGINT; VAR max : LONGINT);
        VAR
            j, k : LONGINT;
            a, b : CHAR;
    BEGIN
        max := -1; j := 0;
        k := 1; period := 1;
        WHILE j + k < m DO
            a := pattern[j + k];
            b := pattern[max + k];
            IF a < b THEN
                j := j + k; k := 1;
                period := j - max;
            ELSE
                IF a = b THEN
                    IF k # period THEN INC(k)
                    ELSE j := j + period; k := 1 END;
                ELSE
                    max := j; j := max + 1;
                    k := 1; period := 1;
                END;
            END;
        END;
    END MaxSuffixGEQ;

    (* Computing of the maximal suffix for >= *)
    PROCEDURE MaxSuffixLEQ(VAR period : LONGINT; VAR max : LONGINT);
        VAR
            j, k : LONGINT;
            a, b : CHAR;
    BEGIN
        max := -1; j := 0;
        k := 1; period := 1;
        WHILE j + k < m DO
            a := pattern[j + k];
            b := pattern[max + k];
            IF a > b THEN
                j := j + k; k := 1;
                period := j - max;
            ELSE
                IF a = b THEN
                    IF k # period THEN INC(k)
                    ELSE j := j + period; k := 1 END;
                ELSE
                    max := j; j := max + 1;
                    k := 1; period := 1;
                END;
            END;
        END;
    END MaxSuffixLEQ;

    PROCEDURE Cmp(j, len : LONGINT): BOOLEAN;
        VAR i : LONGINT;
    BEGIN
        i := 0;
        WHILE (pattern[i] = pattern[i + j]) & (len > 0) DO
            INC(i); DEC(len)
        END;
        RETURN len = 1
    END Cmp;

BEGIN
    m := Length(pattern);
    IF m = 0 THEN RETURN 0 END;
    n := Length(str);
    IF (n = 0) OR (start >= n) THEN RETURN -1 END;
    IF m > n - start THEN RETURN -1 END;
    IF m = 1 THEN RETURN IndexChar(pattern[0], str, start) END;
    -- TODO : Special case with pattern length 2, 3 & 4;
    MaxSuffixGEQ(p, i);
    MaxSuffixLEQ(q, j);
    IF i > j THEN
        ell := i; per := p
    ELSE
        ell := j; per := q
    END;
    (* Searching *)
    IF Cmp(per, ell + 1) THEN
        j := 0; memory := -1;
        WHILE (j <= n - m) DO
            IF ell > memory THEN i := ell + 1
            ELSE i := memory + 1 END;
            WHILE (i < m) & (pattern[i] = str[start + i + j]) DO INC(i) END;
            IF i >= m THEN
                i := ell;
                WHILE (i > memory) & (pattern[i] = str[start + i + j]) DO DEC(i) END;
                IF i <= memory THEN RETURN j + start END;
                j := j + per;
                memory := m - per - 1;
            ELSE
                j := j + (i - ell);
                memory := -1;
            END
        END
    ELSE
        IF ell + 1 > m - ell - 1 THEN per := ell + 2
        ELSE per := m - ell END;
        j := 0;
        WHILE j <= n - m DO
            i := ell + 1;
            WHILE (i < m) & (pattern[i] = str[start + i + j]) DO INC(i) END;
            IF i >= m THEN
                i := ell;
                WHILE (i >= 0) & (pattern[i] = str[start + i + j]) DO DEC(i) END;
                IF i < 0 THEN RETURN j + start END;
                j := j + per
            ELSE
                j := j + (i - ell)
            END;
        END;
    END;
    RETURN -1;
END Index;
<* END *>

(** Delete `count` characters from `dst` starting from `start`. *)
PROCEDURE Delete* (VAR dst: ARRAY OF CHAR; start, count: LONGINT);
    VAR
        len : LONGINT;
BEGIN
    len := Length(dst);
    WHILE start + count < len DO
        dst[start] := dst[start + count];
        INC(start)
    END;
    IF start < LEN(dst) THEN dst[start] := Char.NUL END
END Delete;

(** Insert `src` into `dst` at `start`. *)
PROCEDURE Insert* (VAR dst : ARRAY OF CHAR; src- : ARRAY OF CHAR; start: LONGINT);
    VAR
        i, n, m: LONGINT ;
BEGIN
    n := Length(dst);
    m := Length(src);
    IF start < 0 THEN start := 0 END;
    IF ((start > n) OR (m = 0 )) OR (n + m > LEN(dst)) THEN RETURN END;
    i := n;
    WHILE i > start DO
        dst[i + m - 1] := dst[i - 1];
        DEC(i);
    END;
    i := 0;
    WHILE (i < m) DO
        dst[start + i] := src[i];
        INC(i);
    END;
    IF n + m < LEN(dst) THEN dst[n + m] := Char.NUL END;
END Insert;

(** Replace `old` string with `new` string starting at index `start` (defaults to 0). *)
PROCEDURE Replace* (VAR dst: ARRAY OF CHAR; old-, new-: ARRAY OF CHAR; start := 0 : LONGINT);
    VAR
        i, ll : LONGINT;
BEGIN
    ll := Length(old);
    i := Index(old, dst, start);
    IF i # -1 THEN
        Delete(dst, i, ll);
        Insert(dst, new, i);
    END;
END Replace;

(** Remove white space & control characters from left side of string. *)
PROCEDURE LeftTrim* (VAR dst: ARRAY OF CHAR);
    VAR
        i, cnt, len : LONGINT;
BEGIN
    i := 0;
    len := Length(dst);
    WHILE (i < len) & Char.IsControl(dst[i]) DO INC(i) END;
    IF i > 0 THEN
        cnt := i;
        i := 0;
        WHILE i + cnt < len DO
            dst[i] := dst[i + cnt];
            INC(i)
        END;
        IF i <= LEN(dst) - 1 THEN dst[i] := Char.NUL END;
    END;
END LeftTrim;

(* Remove white space & special characters from right side of string. *)
PROCEDURE RightTrim* (VAR dst: ARRAY OF CHAR);
    VAR
        i, len : LONGINT;
BEGIN
    len := Length(dst);
    i := len;
    WHILE (i > 0) AND Char.IsControl(dst[i - 1]) DO DEC(i) END;
    IF i < len THEN dst[i] := Char.NUL END;
END RightTrim;

(** Remove white space & special characters from right & left side of string. *)
PROCEDURE Trim* (VAR dst: ARRAY OF CHAR);
BEGIN RightTrim(dst); LeftTrim(dst);
END Trim;

(** Left justified of length `width` with `ch` (defaults to SPC). *)
PROCEDURE LeftPad* (VAR dst: ARRAY OF CHAR; width : LONGINT; ch := ' ' : CHAR);
    VAR
        cnt: LONGINT;
BEGIN
    cnt := width - Length(dst);
    WHILE cnt > 0 DO Insert(dst, ch, 0); DEC(cnt) END;
END LeftPad;

(** Right justified of length `width` with `ch` (defaults to SPC). *)
PROCEDURE RightPad* (VAR dst: ARRAY OF CHAR; width : LONGINT; ch := ' ' : CHAR);
    VAR
        cnt: LONGINT;
BEGIN
    cnt := width - Length(dst);
    WHILE cnt > 0 DO Append(dst, ch); DEC(cnt) END;
END RightPad;

(** Transform string inplace to lower case (Only takes into account the ASCII characters). *)
PROCEDURE LowerCase* (VAR dst: ARRAY OF CHAR);
    VAR
        i : LONGINT;
BEGIN
    i := 0;
    WHILE (i < LEN(dst)) & (dst[i] # Char.NUL) DO dst[i]:=Char.Lower(dst[i]); INC(i) END;
END LowerCase;

(** Transform string inplace to upper case (Only takes into account the ASCII characters).*)
PROCEDURE UpperCase* (VAR dst: ARRAY OF CHAR);
    VAR
        i : LONGINT;
BEGIN
    i := 0;
    WHILE (i < LEN(dst)) & (dst[i] # Char.NUL) DO dst[i]:=Char.Upper(dst[i]); INC(i) END;
END UpperCase;

(** Capitalize string inplace. (Only takes into account the ASCII characters). *)
PROCEDURE Capitalize* (VAR dst: ARRAY OF CHAR);
    VAR
        i : LONGINT;
        ch : CHAR;
BEGIN
    i := 0;
    LOOP
        IF i >= LEN(dst) THEN EXIT END;
        ch := dst[i];
        IF ch = Char.NUL THEN EXIT END;
        IF ~Char.IsControl(ch) THEN
            dst[i] := Char.Upper(ch);
            EXIT;
        END;
        INC(i);
    END;
END Capitalize;

(** Check if string `str` starts with `prefix`. *)
PROCEDURE StartsWith* (str-, prefix- : ARRAY OF CHAR): BOOLEAN;
    VAR
        i, ll : LONGINT;
BEGIN
    ll := Length(prefix);
    i := Length(str) - ll;
    RETURN (i >= 0 ) & ((ll = 0) OR (Index(prefix, str, 0) = 0));
END StartsWith;

(** Check if string `str` ends with `postfix`. *)
PROCEDURE EndsWith* (str-, postfix- : ARRAY OF CHAR): BOOLEAN;
    VAR
        i, ll : LONGINT;
BEGIN
    ll := Length(postfix);
    i := Length(str) - ll;
    RETURN (i >= 0 ) & ((ll = 0) OR (Index(postfix, str, i) = i))
END EndsWith;

(*
Return `TRUE` if `patter` matches `str`.

* `?` mathches a single character
*  `*` mathches any sequence of characters including zero length
*)
PROCEDURE Match* (str- : ARRAY OF CHAR; pattern- : ARRAY OF CHAR; IgnoreCase := FALSE : BOOLEAN): BOOLEAN;
    VAR
        lens, lenp : LONGINT;
    
    PROCEDURE IMatch(is, ip: LONGINT) :BOOLEAN;
    BEGIN
        WHILE ip < lenp DO
            IF pattern[ip] = '*' THEN
                WHILE is <= lens DO (* check to end of string *)
                    IF IMatch(is, ip + 1) THEN RETURN TRUE END;
                    INC(is);
                END;
                RETURN FALSE;
            ELSIF is = lens THEN (* pattern not exhausted *)
                RETURN FALSE;
            ELSIF pattern[ip] = '?' THEN
                ;
            ELSIF ~IgnoreCase & (str[is] # pattern[ip]) THEN
                RETURN FALSE;
            ELSIF IgnoreCase & (Char.Upper(str[is]) # Char.Upper(pattern[ip])) THEN
                RETURN FALSE;
            END;
            INC(is); INC(ip);
        END;
        RETURN is = lens;
    END IMatch;
BEGIN
    lens := Length(str);
    lenp := Length(pattern);
    IF lenp = 0 THEN RETURN lens = 0 END;
    RETURN IMatch(0, 0); 
END Match;

(**  Hash value of array (32bit FNV-1a) *)
PROCEDURE Hash* (src- : ARRAY OF CHAR; hash :=  0811C9DC5H : Type.CARD32): Type.CARD32;
BEGIN RETURN ArrayOfByte.Hash(src, Length(src), hash);
END Hash;

END ArrayOfChar.