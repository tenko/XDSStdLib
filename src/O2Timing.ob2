(**
Module for timing of procedure execution.

Reference files the perf directory for usage examples.
*)
MODULE O2Timing;

IMPORT SYSTEM, OSStream;

<* IF (env_target = "x86nt") THEN *> 
IMPORT Windows;
<* ELSE *>
IMPORT SysClock;
<* END *>

TYPE
    Proc* = PROCEDURE;

<* IF (env_target = "x86nt") THEN *>
VAR
    PCFreq : LONGREAL;
    CounterStart : LONGREAL;
<* END *>


(** Setup timer *)
PROCEDURE StartTimer*;
<* IF (env_target = "x86nt") THEN *>
    VAR res : Windows.LARGE_INTEGER;
BEGIN
    IF ~Windows.QueryPerformanceFrequency(res) THEN HALT(1) END;
    PCFreq := VAL(LONGREAL, res.QuadPart) / 1000.;
    Windows.QueryPerformanceCounter(res);
	CounterStart := VAL(LONGREAL, res.QuadPart);
<* ELSE *>
BEGIN
<* END *> 
END StartTimer;

(** Elapsed time *)
PROCEDURE Elapsed* (): LONGREAL;
<* IF (env_target = "x86nt") THEN *>
    VAR
        res : Windows.LARGE_INTEGER;
        t : LONGREAL;
BEGIN
    Windows.QueryPerformanceCounter(res);
    t := VAL(LONGREAL, res.QuadPart);
	RETURN (t - CounterStart) / PCFreq;
<* ELSE *>
    VAR t: SysClock.DateTime;
BEGIN
    SysClock.GetClock(t);
    RETURN 1000. * VAL(LONGREAL, (t.hour * 60 + t.minute) * 60 + t.second);
<* END *>
END Elapsed;

(** Run testproc and report statistics *)
PROCEDURE Timing* (name : ARRAY OF CHAR; testproc : Proc; loops := 1000000 : LONGINT; outer := 10 : LONGINT);
    VAR 
        totaltime, t : LONGREAL;
        tv, hour, min, sec, msec : LONGINT;
        i : INTEGER;
    
    PROCEDURE Run(loops : LONGINT; testproc : Proc): LONGREAL;
        VAR 
            starttime, nulltime : LONGREAL;
            i : LONGINT;
    BEGIN
        starttime := Elapsed();
        FOR i := 1 TO loops DO END;
        nulltime := Elapsed() - starttime;
        
        starttime := Elapsed();
        FOR i := 1 TO loops DO testproc END;
        RETURN Elapsed() - starttime - nulltime;
    END Run;
BEGIN
    totaltime := 1.0E100;
    FOR i := 0 TO outer - 1 DO
        t := Run(loops, testproc);
        IF t < totaltime THEN totaltime := t END;
    END;
    tv := VAL(LONGINT, totaltime);
    hour := (tv DIV 3600000) MOD 24;
    min := (tv DIV 60000) MOD 60;
    sec := (tv DIV 1000) MOD 60;
    msec := tv MOD 1000;
    OSStream.stdout.Format("%s : %02dh:%02dm:%02ds:%03dms\n", name, hour, min, sec, msec);
END Timing;

END O2Timing.