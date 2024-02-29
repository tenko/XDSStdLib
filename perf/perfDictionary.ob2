<*  +MAIN *>
<* +O2ADDKWD *>
(* Adapted from Ben Hoyt article about hash tables. License is MIT *)
MODULE perfDictionary;

IMPORT SYSTEM, OSStream, Dict := ADTDictionary, String, Vector := ADTVector;
IMPORT Set := ADTSet, Type, LongWord, Word, Char, Timing := O2Timing;
IMPORT RndFile, SeqFile, RawIO, ChanConsts, TextIO, IOChan, IOResult, ProgramArgs, xFilePos;

TYPE
    FilePos = RndFile.FilePos;
    File = RndFile.ChanId;

PROCEDURE ReadFile(filename : ARRAY OF CHAR; VAR content : String.STRING);
    VAR
        fh : File;
        res: RndFile.OpenResults;
        pos : FilePos;
        dat : String.STRING;
        size : LONGINT;
        ret : BOOLEAN;
BEGIN
    RndFile.OpenOld(fh, filename, RndFile.read + RndFile.raw, res);
    IF res # ChanConsts.opened THEN
        OSStream.stdout.Format("Failed to open file : '%s'\n", filename);
        RETURN;
    END;
    pos := RndFile.EndPos(fh);
    ret := xFilePos.PosToInt(size, pos);
    ASSERT(size > 0);
    NEW(dat, size);
    RawIO.Read(fh, dat^);
    IF IOChan.ReadResult(fh) # IOResult.allRight THEN
        OSStream.stdout.Format("Failed to read file\n");
        RETURN
    END;
    content := dat;
END ReadFile;

PROCEDURE PerfGet(filename : ARRAY OF CHAR);
    VAR
        content : String.STRING;
        dic : Dict.DictionaryStrInt;
        it : Dict.DictionaryStrIntIterator;
        keys : Vector.VectorOfString;
        key : String.STRING;
        ch : CHAR;
        starttime : LONGREAL;
        i, j, size, value, tv, sec, ms : LONGINT;
        ret : BOOLEAN;
BEGIN
    ReadFile(filename, content);
    size := LEN(content^);
    NEW(dic);
    dic.Init();
    String.Reserve(key, 64);
    i := 0;
    LOOP
        IF i >= size THEN EXIT END;
        WHILE (i < size) & Char.IsSpace(content^[i]) DO INC(i) END;
        j := 0;
        WHILE (i < size) & ~Char.IsSpace(content^[i]) DO
            key^[j] := content^[i];
            INC(i); INC(j);
        END;
        key^[j] := 00X;
        IF j > 0 THEN
            IF dic.Get(key^, value) THEN
                ret := dic.Set(key^, value + 1)
            ELSE
                ret := dic.Set(key^, 1)
            END;
        END;
        INC(i);
    END;
    keys := dic.Keys();
    Timing.StartTimer();
    starttime := Timing.Elapsed();
    FOR i := 0 TO 9 DO
        FOR j := 0 TO keys.Size() - 1 DO
            ret := dic.Get(keys.At(j)^, value);
        END;
    END;
    tv := VAL(LONGINT, Timing.Elapsed() - starttime);
    ms := tv MOD 1000;
    sec := (tv DIV 1000) MOD 60;
    OSStream.stdout.Format("10 runs getting %d keys: %ds %dms\n", keys.Size(), sec, ms);
END PerfGet;

PROCEDURE PerfGetAlt(filename : ARRAY OF CHAR);
    VAR
        content : String.STRING;
        dic : Dict.DictionaryStrInt;
        it : Dict.DictionaryStrIntIterator;
        entry : Dict.StringIntEntry;
        keys : Vector.VectorOfString;
        key : String.STRING;
        ch : CHAR;
        starttime : LONGREAL;
        i, j, size, value, tv, sec, ms : LONGINT;
        ret : BOOLEAN;
BEGIN
    ReadFile(filename, content);
    size := LEN(content^);
    NEW(dic);
    dic.Init();
    String.Reserve(key, 64);
    i := 0;
    LOOP
        IF i >= size THEN EXIT END;
        WHILE (i < size) & Char.IsSpace(content^[i]) DO INC(i) END;
        j := 0;
        WHILE (i < size) & ~Char.IsSpace(content^[i]) DO
            key^[j] := content^[i];
            INC(i); INC(j);
        END;
        key^[j] := 00X;
        IF j > 0 THEN
            IF dic.Get(key^, value) THEN
                ret := dic.Set(key^, value + 1)
            ELSE
                ret := dic.Set(key^, 1)
            END;
        END;
        INC(i);
    END;
    keys := dic.Keys();
    NEW(entry);
    String.Reserve(entry.key, 64);
    Timing.StartTimer();
    starttime := Timing.Elapsed();
    FOR i := 0 TO 9 DO
        FOR j := 0 TO keys.Size() - 1 DO
            String.Assign(entry.key, keys.At(j)^);
            ret := dic.GetEntry(entry);
        END;
    END;
    tv := VAL(LONGINT, Timing.Elapsed() - starttime);
    ms := tv MOD 1000;
    sec := (tv DIV 1000) MOD 60;
    OSStream.stdout.Format("10 runs getting %d keys: %ds %dms\n", keys.Size(), sec, ms);
END PerfGetAlt;

BEGIN
    PerfGet("perf/words.txt");
    PerfGetAlt("perf/words.txt");
END perfDictionary.