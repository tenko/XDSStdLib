(**
Date and Time module.

Adapted from `Julia`. License is MIT: https://julialang.org/license

A Date value is encoded as an `LONGLONGINT`, counting milliseconds
from an epoch. The epoch is 0000-12-31T00:00:00.

Days are adjusted accoring to `Rata Die` approch to simplify date calculations.

* Wikipedia: `Link <https://en.wikipedia.org/wiki/Rata_Die>`_
* Report: `Link <http://web.archive.org/web/20140910060704/http://mysite.verizon.net/aesir_research/date/date0.htm>`_
**)
MODULE DateTime ;

IMPORT Const, Type, LongInt, Char, String := ArrayOfChar;
IMPORT xlibOS, SYSTEM;

TYPE
    DATETIME* = LONGLONGINT;
    TType* = (Year, Quarter, Month, Week, Day, Weekday, Hour, Min, Sec, MSec);
    TMonthDays = ARRAY 2, 12 OF LONGINT;
    TShiftedMonthDays = ARRAY 12 OF LONGINT;

CONST
    MONTHDAYS = TMonthDays{
        {31,28,31,30,31,30,31,31,30,31,30,31},
        {31,29,31,30,31,30,31,31,30,31,30,31}
    };
    SHIFTEDMONTHDAYS = TShiftedMonthDays{
        306,337,0,31,61,92,122,153,184,214,245,275
    };

    ERROR* = -1;

VAR
    UTCOffset- : LONGINT;

(* Return TRUE if the Year is a leap year *)
PROCEDURE IsLeapYear (year : LONGINT) : BOOLEAN;
BEGIN RETURN (year MOD 4 = 0) AND ((year MOD 100 # 0) OR (year MOD 400 = 0))
END IsLeapYear;

(*
 Convert Year, Month, Day to # of Rata Die days
 Works by shifting the beginning of the year to March 1,
 so a leap day is the very last day of the year.
*)
PROCEDURE RataDie (year, month, day : LONGINT): LONGLONGINT;
    VAR
        mdays : LONGINT;
BEGIN
    (* If we're in Jan/Feb, shift the given year back one *)
    IF month < 3 THEN DEC(year) END;
    mdays := SHIFTEDMONTHDAYS[month - 1];
    RETURN day + mdays + 365*year + year DIV 4 - year DIV 100 + year DIV 400 - 306;
END RataDie;

(* Convert # of Rata Die Days to proleptic Gregorian calendar Year, Month & Day. *)
PROCEDURE InverseRataDie (days : LONGLONGINT; VAR year, month, day : LONGINT);
    VAR a, b, c, h, m, y, z : LONGLONGINT;
BEGIN
    z := days + 306; h := 100*z - 25; a := h DIV 3652425; b := a - a DIV 4;
    y := (100*b + h) DIV 36525;
    c := b + z - 365*y - y DIV 4;
    m := (5*c + 456) DIV 153;
    day := VAL(LONGINT, c - (153*m - 457) DIV 5);
    month := VAL(LONGINT, m);
    year := VAL(LONGINT, y);
    IF month > 12 THEN
        year := year + 1;
        month := month - 12;
    END;
END InverseRataDie;

(** Return `TRUE` if the year, month & day is successful converted to a valid `DATETIME` *)
PROCEDURE TryEncodeDate* (VAR date : DATETIME; year,month,day : LONGINT) : BOOLEAN;
    VAR ret : BOOLEAN;
BEGIN
    ret := (year > 0) AND (year < 10000) AND (month > 0) AND (month < 13) AND (day > 0) 
           AND (day <= MONTHDAYS[ORD(IsLeapYear(year)), month - 1]);
    IF ret THEN
        date := 86400000 * RataDie(year, month, day);
    END;
    RETURN ret;
END TryEncodeDate;

(** Return Encoded date. Return `ERROR` if not valid *)
PROCEDURE EncodeDate* (year, month, day : LONGINT): DATETIME;
    VAR date : DATETIME;
BEGIN
    IF ~TryEncodeDate(date, year, month, day) THEN date := ERROR END;
    RETURN date;
END EncodeDate;

(** Return `TRUE` if Year, Month, Day, Hour, Min, Sec & MSec is successful converted to a valid `DATETIME` *)
PROCEDURE TryEncodeDateTime* (VAR datetime : DATETIME; year, month, day, hour, min, sec, msec : LONGINT) : BOOLEAN;
    VAR ret : BOOLEAN;
BEGIN
    ret := TryEncodeDate(datetime, year, month, day);
    IF ret THEN
        ret := (hour >= 0) AND (hour < 24) AND (min >= 0) AND (min < 60) AND (sec >= 0) AND (sec < 60)
               AND (msec >= 0) AND (msec < 1000);
        IF ret THEN
            datetime := datetime + VAL(LONGINT, msec + 1000*(sec + 60*min + 3600*hour));
        END;
    END;
    RETURN ret;
END TryEncodeDateTime;

(** Return encoded `DATETIME`. Return `ERROR` if not valid *)
PROCEDURE EncodeDateTime* (year, month, day, hour, min, sec : LONGINT; msec := 0 : LONGINT): DATETIME;
    VAR datetime : DATETIME;
BEGIN
    IF ~TryEncodeDateTime(datetime, year, month, day, hour, min, sec, msec) THEN
        datetime := ERROR;
    END;
    RETURN datetime;
END EncodeDateTime;

(** Decode `DATETIME` to Year, Month & Day *)
PROCEDURE DecodeDate* (datetime: DATETIME; VAR year, month, day: LONGINT);
BEGIN InverseRataDie(datetime DIV 86400000, year, month, day);
END DecodeDate;

(** Decode `DATETIME` to  Hour, Min, Sec & MSec *)
PROCEDURE DecodeTime* (datetime: DATETIME; VAR hour, min, sec, msec: LONGINT);
BEGIN
    hour := VAL(LONGINT, (datetime DIV 3600000) MOD 24);
    min := VAL(LONGINT, (datetime DIV 60000) MOD 60);
    sec := VAL(LONGINT, (datetime DIV 1000) MOD 60);
    msec := VAL(LONGINT, datetime MOD 1000);
END DecodeTime;

(** Decode `DATETIME` to Year, Month, Day, Hour, Min, Sec & MSec *)
PROCEDURE DecodeDateTime* (VAR year, month, day, hour, min, sec, msec: LONGINT; datetime: DATETIME);
BEGIN
    InverseRataDie(datetime DIV 86400000, year, month, day);
    DecodeTime(datetime, hour, min, sec, msec);
END DecodeDateTime;

(** Remove time part of `DATETIME` *)
PROCEDURE DateTimeToDate* (datetime: DATETIME) : DATETIME;
    VAR year, month, day : LONGINT;
BEGIN
    DecodeDate(datetime, year, month, day);
    RETURN EncodeDate(year, month, day);
END DateTimeToDate;

(** Current `DATETIME` *)
PROCEDURE Now* (): DATETIME;
    VAR
        res: xlibOS.X2C_TimeStruct;
        dt : DATETIME;
BEGIN
    xlibOS.X2C_GetTime(res);
    RETURN EncodeDateTime(res.year, res.month, res.day, res.hour, res.min, res.sec, (res.fracs * xlibOS.X2C_FracsPerSec()) DIV 1000);
END Now;

(** Current Date *)
PROCEDURE Today* (): DATETIME;
BEGIN RETURN DateTimeToDate(Now())
END Today;

(** Increment Year of `DATETIME` and return modified value *)
PROCEDURE IncYear* (datetime: DATETIME; years : LONGINT) : DATETIME;
    VAR year, month, day, hour, min, sec, msec: LONGINT;
BEGIN
    DecodeDateTime(year, month, day, hour, min, sec, msec, datetime);
    INC(year, years);
    IF day > MONTHDAYS[ORD(IsLeapYear(year)), month - 1] THEN
        day := MONTHDAYS[ORD(IsLeapYear(year)), month - 1];
    END;
    RETURN EncodeDateTime(year, month, day, hour, min, sec, msec);
END IncYear;

(** Decrement Year of `DATETIME` and return modified value *)
PROCEDURE DecYear* (datetime: DATETIME; years : LONGINT) : DATETIME;
    VAR year, month, day, hour, min, sec, msec: LONGINT;
BEGIN
    DecodeDateTime(year, month, day, hour, min, sec, msec, datetime);
    DEC(year, years);
    IF day > MONTHDAYS[ORD(IsLeapYear(year)), month - 1] THEN
        day := MONTHDAYS[ORD(IsLeapYear(year)), month - 1];
    END;
    RETURN EncodeDateTime(year, month, day, hour, min, sec, msec);
END DecYear;

(** Increment Month of `DATETIME` and return modified value *)
PROCEDURE IncMonth* (datetime: DATETIME; months : LONGINT) : DATETIME;
    VAR tmp, year, month, day, hour, min, sec, msec: LONGINT;
BEGIN
    DecodeDateTime(year, month, day, hour, min, sec, msec, datetime);
    INC(year, months DIV 12);
    tmp := month + (months MOD 12) - 1;
    IF tmp > 11 THEN DEC(tmp, 12); INC(year) END;
    month := tmp + 1; (* months from 1 to 12 *)
    tmp := MONTHDAYS[ORD(IsLeapYear(year)), month - 1];
    IF day > tmp THEN day := tmp END;
    RETURN EncodeDateTime(year, month, day, hour, min, sec, msec);
END IncMonth;

(* Deccrement Month of `DATETIME` and return modified value *)
PROCEDURE DecMonth*(datetime: DATETIME; months : LONGINT) : DATETIME;
    VAR year, month, day, hour, min, sec, msec, tmp: LONGINT;
BEGIN
    DecodeDateTime(year, month, day, hour, min, sec, msec, datetime);
    DEC(year, months DIV 12);
    tmp := month - (months MOD 12) - 1;
    IF tmp < 0 THEN INC(tmp, 12); DEC(year) END;
    month := ABS(tmp) + 1; (* months from 1 to 12 *)
    tmp := MONTHDAYS[ORD(IsLeapYear(year)), month - 1];
    IF day > tmp THEN day := tmp END;
    RETURN EncodeDateTime(year, month, day, hour, min, sec, msec);
END DecMonth;

(** Increment `DATETIME` with Value according to Type.*)
PROCEDURE Inc* (VAR datetime : DATETIME; typ : TType; value : LONGLONGINT);
BEGIN
    CASE typ OF
        Year : 
            datetime := IncYear(datetime, VAL(LONGINT, value));
      | Quarter :
            datetime := IncMonth(datetime, VAL(LONGINT, 4*value));
      | Month :
            datetime := IncMonth(datetime, VAL(LONGINT, value));
      | Week :
            datetime := datetime +  7 * VAL(DATETIME, value) * 86400000;
      | Day :
            datetime := datetime +  VAL(DATETIME, value) * 86400000;
      | Hour :
            datetime := datetime +  VAL(DATETIME, value) * 3600000;
      | Min :
            datetime := datetime +  VAL(DATETIME, value) * 60000;
      | Sec :
            datetime := datetime +  VAL(DATETIME, value) * 1000;
      | MSec :
           datetime := datetime +  VAL(DATETIME, value);
    ELSE
        ASSERT(FALSE);
    END;
END Inc;

(** Decrement `DATETIME` with Value according to Type.*)
PROCEDURE Dec* (VAR datetime : DATETIME; typ : TType; value : LONGLONGINT);
BEGIN
    CASE typ OF
        Year : 
            datetime := DecYear(datetime, VAL(LONGINT, value));
      | Quarter :
            datetime := DecMonth(datetime, VAL(LONGINT, 4*value));
      | Month :
            datetime := DecMonth(datetime, VAL(LONGINT, value));
      | Week :
            datetime := datetime - 7 * VAL(DATETIME, value) * 86400000;
      | Day :
            datetime := datetime - VAL(DATETIME, value) * 86400000;
      | Hour :
            datetime := datetime - VAL(DATETIME, value) * 3600000;
      | Min :
            datetime := datetime - VAL(DATETIME, value) * 60000;
      | Sec :
            datetime := datetime - VAL(DATETIME, value) * 1000;
      | MSec :
           datetime := datetime - VAL(DATETIME, value);
    ELSE
        ASSERT(FALSE);
    END;
END Dec;

(* Extract Week of `DATETIME` 
   # https://en.wikipedia.org/wiki/Talk:ISO_week_date#Algorithms
*)
PROCEDURE WeekOf(datetime : DATETIME): LONGINT;
    VAR days, w, c, f, s : LONGINT;
BEGIN
    days := VAL(LONGINT, datetime DIV 86400000);
    w := (ABS(days - 1) DIV 7) MOD 20871;
    s := ORD(w >= 10435);
    c := (w + s) DIV 5218;
    w := (w + s) MOD 5218;
    CASE c OF
        0 : f := 15;
      | 1 : f := 23;
      | 2 : f := 3;
    ELSE f := 11 END;
    w := (w * 28 + f) MOD 1461;
    RETURN w DIV 28 + 1
END WeekOf;

(** Extract component of `DATETIME` *)
PROCEDURE Extract* (datetime : DATETIME; typ : TType) : LONGINT;
    VAR year, month, day, ret : LONGINT;
BEGIN
    CASE typ OF
        Year : 
            DecodeDate(datetime, year, month, day);
            ret := year;
      | Quarter :
            DecodeDate(datetime, year, month, day);
            ret := 4;
            IF month < 4 THEN ret := 1;
            ELSIF month < 7 THEN ret := 2;
            ELSIF month < 10 THEN ret := 3 END
      | Month :
            DecodeDate(datetime, year, month, day);
            ret := month;
      | Week :
            ret := WeekOf(datetime);
      | Day :
            DecodeDate(datetime, year, month, day);
            ret := day;
      | Weekday :
            ret := VAL(LONGINT, (datetime DIV 86400000) MOD 7);
      | Hour :
            ret := VAL(LONGINT, (datetime DIV 3600000) MOD 24);
      | Min :
            ret := VAL(LONGINT, (datetime DIV 60000) MOD 60);
      | Sec :
            ret := VAL(LONGINT, (datetime DIV 1000) MOD 60);
      | MSec :
            ret := VAL(LONGINT, (datetime MOD 1000));
    ELSE
        ASSERT(FALSE);
    END;
    RETURN ret;  
END Extract;

(**
  Trucate `DATETIME` value according to Type.
  Usefull for comparison, calculate spans or finding start of periods (week, month).
*)
PROCEDURE Trunc* (datetime : DATETIME; typ : TType) : DATETIME;
    VAR
        year, month, day : LONGINT;
        ret : DATETIME;
BEGIN
    CASE typ OF
        Year : 
            DecodeDate(datetime, year, month, day);
            ret := EncodeDate(year, 1, 1);
      | Quarter :
            DecodeDate(datetime, year, month, day);
            IF month < 4 THEN month := 1
            ELSIF month < 7 THEN month := 4
            ELSIF month < 10 THEN month := 7
            ELSE month := 10 END;
            ret := EncodeDate(year, month, 1);
      | Month :
            DecodeDate(datetime, year, month, day);
            ret := EncodeDate(year, month, 1);
      | Week :
            ret := datetime;
            day := 1 - Extract(datetime, Weekday);
            IF day < 0 THEN
                Dec(ret, Day, ABS(day));
            ELSE
                Inc(ret, Day, day);
            END;
      | Day :
            DecodeDate(datetime, year, month, day);
            ret := EncodeDate(year, month, day);
      | Hour :
            ret := (datetime DIV 3600000) * 3600000;
      | Min :
            ret := (datetime DIV 60000) * 60000;
      | Sec :
            ret := (datetime DIV 1000) * 1000;
    ELSE
        ASSERT(FALSE);
    END;
    RETURN ret;
END Trunc;

(** Compute difference between two dates. Extract year, month, day to get difference *)
PROCEDURE Diff* (dtstart, dtend: DATETIME; addEndDay := FALSE : BOOLEAN) : DATETIME;
    VAR ret : DATETIME;
BEGIN
    IF dtend < dtstart THEN ret := dtstart - dtend
    ELSE ret := dtend - dtstart END;
    Dec(ret, Year, 1);
    Dec(ret, Month, 1);
    Inc(ret, Day, 1 + ORD(addEndDay));
    RETURN ret;
END Diff;

(** Calculate `DATETIME` span between Start and End according to Type *)
PROCEDURE Span* (dtstart, dtend: DATETIME; typ : TType) : LONGINT;
    VAR
        tmp : DATETIME;
        ret : LONGINT;
BEGIN
    tmp := Diff(dtstart, dtend);
    CASE typ OF
        Year : 
            ret := Extract(tmp, Year);
      | Quarter :
            ret := 4*Extract(tmp, Year) + Extract(dtend - dtstart, Quarter) - 1; (* Quarter starts with 1 *)
      | Month :
            ret := 12*Extract(tmp, Year) + Extract(dtend - dtstart, Month) - 1; (* Month starts with 1 *)
      | Day :
            ret := VAL(LONGINT, dtend DIV 86400000 - dtstart DIV 86400000);
      | Hour :
            ret := VAL(LONGINT, dtend DIV 3600000 - dtstart DIV 3600000);
      | Min :
            ret := VAL(LONGINT, dtend DIV 60000 - dtstart DIV 60000);
      | Sec :
            ret := VAL(LONGINT, dtend DIV 1000 - dtstart DIV 1000);
      | MSec :
           ret := VAL(LONGINT, dtend - dtstart);
    ELSE
        ASSERT(FALSE);
    END;
    RETURN LongInt.Max(ret, 0);
END Span;

(**
Try to parse string to a `DATETIME` according to format string:

* `%y` : Year with century : 0 - 9999
* `%m` : Month : 1 - 12
* `%d` : Day of the month : 1 - XX
* `%H` : Hour (24-hour clock) : 0 - 23
* `%M` : Minute : 0 - 59
* `%S` : Second  : 0 - 59
* `%f` : Milliseconds : 0 - 999
* `%t` : One or more TAB or SPC characters
* `%%` : Literal `%` char

Numbers can be zero padded.
Other characters must match exactly.

Return -1 on failure or number of characters converted.
*)
PROCEDURE FromString* (VAR datetime : DATETIME; src- : ARRAY OF CHAR; fmt- : ARRAY OF CHAR; start := 0 : LONGINT): LONGINT;
    VAR
        year, month, day: LONGINT;
        hour, min, sec, msec: LONGINT;
        i, idx, value : LONGINT;
        ch : CHAR;

    PROCEDURE IsSpace(ch: CHAR) : BOOLEAN;
    BEGIN RETURN (ch = Char.TAB) OR (ch = Char.SPC)
    END IsSpace;

    PROCEDURE Next();
    BEGIN
        IF idx < LEN(fmt) THEN ch := fmt[idx]; INC(idx)
        ELSE ch := Char.NUL END;
    END Next;

    PROCEDURE Peek() : CHAR;
    BEGIN
        IF idx < LEN(fmt) THEN RETURN fmt[idx]
        ELSE RETURN Char.NUL END;
    END Peek;

    PROCEDURE Parse(VAR val : LONGINT; width := -1 : INTEGER) : BOOLEAN;
        VAR value : LONGINT;
    BEGIN
        IF val # -1 THEN RETURN FALSE END;
        IF width = -1 THEN
            width := 0;
            WHILE Char.IsDigit(src[i + width]) DO INC(width) END
        END;
        IF ~LongInt.FromString(value, src, i, width) THEN RETURN FALSE END;
        val := value; INC(i, width);
        RETURN TRUE;
    END Parse;
BEGIN
    i := start; idx := 0;
    datetime := ERROR;
    year := -1; month := -1; day := -1;
    hour := -1; min := -1; sec := -1; msec := -1;
    LOOP
        Next();
        IF ch = '%' THEN
            CASE Peek() OF
                'y' :   (* Year with century : 0 - 9999 *)
                        IF ~Parse(year) THEN RETURN -1 END;
                        Next(); |
                'm' :   (* Month : 1 - 12 *)
                        IF ~Parse(month) THEN RETURN -1 END;
                        Next(); |
                'd' :   (* Day of the month : 1 - XX *)
                        IF ~Parse(day) THEN RETURN -1 END;
                        Next(); |
                'H' :   (* Hour (24-hour clock) zero-padded : 00 - 23 *)
                        IF ~Parse(hour, 2) THEN RETURN -1 END;
                        Next(); |
                'M' :   (* Minute : 0 - 59 *)
                        IF ~Parse(min) THEN RETURN -1 END;
                        Next(); |
                'S' :   (* Second : 0 - 59 *)
                        IF ~Parse(sec, 2) THEN RETURN -1 END;
                        Next(); |
                'f' :   (* Milliseconds : 0 - 999 *)
                        IF ~Parse(msec) THEN RETURN -1 END;
                        Next(); |
                '%' :   (* Escaped '%' *)
                        IF ch # '%' THEN RETURN -1 END;
                        Next(); |
                't' :   (* White space *)
                        IF ~IsSpace(src[i]) THEN RETURN -1 END;
                        WHILE IsSpace(src[i]) DO INC(i) END;
                        Next(); |
            ELSE RETURN -1
            END;
        ELSIF ch = Char.NUL THEN EXIT
        ELSE
            IF ch # src[i] THEN RETURN -1 END;
            INC(i)
        END
    END;
    IF Peek() # Char.NUL THEN RETURN -1 END;
    IF (year # -1) AND (month # -1) AND (day # -1) THEN
        IF hour = -1 THEN hour := 0 END;
        IF min = -1 THEN min := 0 END;
        IF sec = -1 THEN sec := 0 END;
        IF msec = -1 THEN msec := 0 END;
        IF ~TryEncodeDateTime(datetime, year, month, day, hour, min, sec, msec) THEN
            RETURN -1;
        END;
        RETURN i - start;
    ELSE RETURN -1
    END;
END FromString;

(* Fetch system timezone and gmoffset value *)
PROCEDURE Init();
    VAR res: xlibOS.X2C_TimeStruct;
BEGIN
    xlibOS.X2C_GetTime(res);
    UTCOffset := res.zone;
END Init;

BEGIN Init(); 
END DateTime.