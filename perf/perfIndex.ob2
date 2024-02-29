<*  +MAIN *>
(* Test Knuth-Morris-Pratt, TwoWaySeach String Search against version in ArrayOfChar.Index *)
MODULE test;

IMPORT SYSTEM, Timing := O2Timing, Char, ShortInt, ArrayOfChar, OSStream;

CONST
    LOREM = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse quis lorem sit amet dolor " +
            "ultricies condimentum. Praesent iaculis purus elit, ac malesuada quam malesuada in. Duis sed orci " +
            "eros. Suspendisse sit amet magna mollis, mollis nunc luctus, imperdiet mi. Integer fringilla non " +
            "sem ut lacinia. Fusce varius tortor a risus porttitor hendrerit. Morbi mauris dui, ultricies nec" +
            "tempus vel, gravida nec quam. " +
            "In est dui, tincidunt sed tempus interdum, adipiscing laoreet ante. Etiam tempor, tellus quis " +
            "sagittis interdum, nulla purus mattis sem, quis auctor erat odio ac tellus. In nec nunc sit amet " +
            "diam volutpat molestie at sed ipsum. Vestibulum laoreet consequat vulputate. Integer accumsan " +
            "lorem ac dignissim placerat. Suspendisse convallis faucibus lorem. Aliquam erat volutpat. In vel " +
            "eleifend felis. Sed suscipit nulla lorem, sed mollis est sollicitudin et. Nam fermentum egestas " +
            "interdum. Curabitur ut nisi justo. " +
            "Sed sollicitudin ipsum tellus, ut condimentum leo eleifend nec. Cras ut velit ante. Phasellus nec " +
            "mollis odio. Mauris molestie erat in arcu mattis, at aliquet dolor vehicula. Quisque malesuada " +
            "lectus sit amet nisi pretium, a condimentum ipsum porta. Morbi at dapibus diam. Praesent egestas " +
            "est sed risus elementum, eu rutrum metus ultrices. Etiam fermentum consectetur magna, id rutrum " +
            "felis accumsan a. Aliquam ut pellentesque libero. Sed mi nulla, lobortis eu tortor id, suscipit " +
            "ultricies neque. Morbi iaculis sit amet risus at iaculis. Praesent eget ligula quis turpis " +
            "feugiat suscipit vel non arcu. Interdum et malesuada fames ac ante ipsum primis in faucibus. " +
            "Aliquam sit amet placerat lorem." +
            "Cras a lacus vel ante posuere elementum. Nunc est leo, bibendum ut facilisis vel, bibendum at " +
            "mauris. Nullam adipiscing diam vel odio ornare, luctus adipiscing mi luctus. Nulla facilisi." +
            "Mauris adipiscing bibendum neque, quis adipiscing lectus tempus et. Sed feugiat erat et nisl " +
            "lobortis pharetra. Donec vitae erat enim. Nullam sit amet felis et quam lacinia tincidunt. Aliquam " +
            "suscipit dapibus urna. Sed volutpat urna in magna pulvinar volutpat. Phasellus nec tellus ac diam " +
            "cursus accumsan. " +
            "Nam lectus enim, dapibus non nisi tempor, consectetur convallis massa. Maecenas eleifend dictum " +
            "feugiat. Etiam quis mauris vel risus luctus mattis a a nunc. Nullam orci quam, imperdiet id " +
            "vehicula in, porttitor ut nibh. Duis sagittis adipiscing nisl vitae congue. Donec mollis risus eu " +
            "leo suscipit, varius porttitor nulla porta. Pellentesque ut sem nec nisi euismod vehicula. Nulla " +
            "malesuada sollicitudin quam eu fermentum.";
VAR
  Pth : ARRAY 64 OF CHAR;
  Src : POINTER TO ARRAY OF CHAR;

  (* Algorithms and Data Structures by N. Wirth 1.9.2 The Knuth-Morris-Pratt String Search *)
PROCEDURE KMPIndexOf(p-, s-: ARRAY OF CHAR): LONGINT;
VAR
    ds : ARRAY 127 OF LONGINT;
    dp: POINTER TO ARRAY OF LONGINT;
    N, M: LONGINT;

    PROCEDURE IKMPIndexOf(d: ARRAY OF LONGINT): LONGINT;
        VAR
            i, j, k: LONGINT;
    BEGIN
        (* compute shifts *)
        d[0] := -1;
        IF p[0] # p[1] THEN d[1] := 0
        ELSE d[1] := -1 END;
        j := 1; k := 0;
        WHILE (j < M - 1) & (p[j] # 00C) DO
            IF (k >= 0) & (p[j] # p[k]) THEN k := d[k];
            ELSE
            INC(j); INC(k);
            IF p[j] # p[k] THEN d[j] := k
            ELSE d[j] := d[k] END;
            END;
        END;
        IF j <= M - 1 THEN M := j END;
        (* scan with shifts *)
        i := 0; j := 0;
        WHILE (j < M) & (i < N) & (s[i] # 00C) DO
            IF (j >= 0) & (s[i] # p[j]) THEN j := d[j];
            ELSE INC(i); INC(j) END;
        END;
        IF j = M THEN RETURN i - M END;
        RETURN -1
    END IKMPIndexOf;
BEGIN
    N := LEN(s);
    M := LEN(p);
    IF M < 128 THEN RETURN IKMPIndexOf(ds)
    ELSE NEW(dp, M); RETURN IKMPIndexOf(dp^) END;
END KMPIndexOf;

(** Index of pattern in str. -1 indicating pattern not found.
    TwoWaySeach:
    http://monge.univ-mlv.fr/~mac/Articles-PDF/CP-1991-jacm.pdf
    https://www-igm.univ-mlv.fr/~lecroq/string/node26.html
*)
PROCEDURE TwoWaySearch(pattern-, str-: ARRAY OF CHAR; start := 0 : LONGINT): LONGINT;
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
    m := ArrayOfChar.Length(pattern);
    IF m = 0 THEN RETURN 0 END;
    n := ArrayOfChar.Length(str);
    IF (n = 0) OR (start >= n) THEN RETURN -1 END;
    IF m > n THEN RETURN -1 END;
    IF m = 1 THEN RETURN ArrayOfChar.IndexChar(pattern[0], str, start) END;
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
END TwoWaySearch;

PROCEDURE SimpleSearch (pattern-, str-: ARRAY OF CHAR; start := 0 : LONGINT): LONGINT;
    VAR
        i, j, lp: LONGINT;
BEGIN
    lp := ArrayOfChar.Length(pattern);
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
END SimpleSearch;

PROCEDURE Test1;
VAR ret : LONGINT;
VAR
BEGIN
    ret := KMPIndexOf(Pth, Src^);
END Test1;

PROCEDURE Test2;
VAR ret : LONGINT;
BEGIN
    ret := TwoWaySearch(Pth, Src^);
END Test2;

PROCEDURE Test3;
VAR ret : LONGINT;
BEGIN
    ret := SimpleSearch(Pth, Src^);
END Test3;

CONST 
    LOOPS = 99999;
    LOOPS2 = 999999;

BEGIN
    NEW(Src, LEN(LOREM));
    COPY(LOREM, Src^);
    OSStream.stdout.Format("Length(Src) = %d\n", ArrayOfChar.Length(Src^));
    Pth := "euismod vehicula";
    OSStream.stdout.Format("Length(Pth) = %d\n\n", ArrayOfChar.Length(Pth));
    OSStream.stdout.Format("KMPIndexOf(Pth, Src^) = %d\n", KMPIndexOf(Pth, Src^));
    OSStream.stdout.Format("TwoWaySearch(Pth, Src^) = %d\n", TwoWaySearch(Pth, Src^));
    OSStream.stdout.Format("ArrayOfChar.Index(Pth, Src^) = %d\n\n", ArrayOfChar.Index(Pth, Src^));

    Timing.StartTimer();
    Timing.Timing("KMPIndexOf", Test1, LOOPS);
    Timing.Timing("TwoWaySearch", Test2, LOOPS);
    Timing.Timing("Index", Test3, LOOPS);

    COPY("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaab", Src^);
    OSStream.stdout.Format("Length(Src) = %d\n", ArrayOfChar.Length(Src^));
    Pth := "aaaaaaaaaaaaaaaaaaaaaaaab";
    OSStream.stdout.Format("Length(Pth) = %d\n\n", ArrayOfChar.Length(Pth));
    OSStream.stdout.Format("KMPIndexOf(Pth, Src^) = %d\n", KMPIndexOf(Pth, Src^));
    OSStream.stdout.Format("TwoWaySearch(Pth, Src^) = %d\n", TwoWaySearch(Pth, Src^));
    OSStream.stdout.Format("ArrayOfChar.Index(Pth, Src^) = %d\n\n", ArrayOfChar.Index(Pth, Src^));

    Timing.StartTimer();
    Timing.Timing("KMPIndexOf", Test1, LOOPS2);
    Timing.Timing("TwoWaySearch", Test2, LOOPS2);
    Timing.Timing("Index", Test3, LOOPS2);

END test.