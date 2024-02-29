(**
Module for code testing.

For now the code Assert function must be given
sequential id numbers as the line number in files
is not available.

Reference to tests/Main.ob2 for usage.
*)
MODULE O2Testing;

IMPORT SYSTEM, Const, OSStream;

TYPE
    TEST* = 
    RECORD
        tests : LONGINT;
        failed : LONGINT;
        local : LONGINT;
        localid : LONGINT;
        localfailed : LONGINT;
    END;

(* Initialize global testing Record and output host, target, cpu and file *)
PROCEDURE Initialize* (VAR test: TEST; file: ARRAY OF CHAR);
BEGIN
    test.tests := 0;
    test.failed := 0;
    OSStream.stdout.Format("OBERON-2 Tests Host=%s  Target=%s  CPU=%s\n", Const.HOST, Const.TARGET, Const.CPU);
    OSStream.stdout.Format('BEGIN %s\n', file);
END Initialize;

(** Begin local module tests *)
PROCEDURE Begin* (VAR test: TEST; file: ARRAY OF CHAR);
BEGIN
    test.local := 0;
    test.localid := 0;
    test.localfailed := 0;
END Begin;

(** End local module tests and print out statistics *)
PROCEDURE End* (VAR test: TEST; file: ARRAY OF CHAR);
BEGIN
    INC(test.tests, test.local);
    INC(test.failed, test.localfailed);
    OSStream.stdout.Format('%-32s tests: %4d  failed: %3d\n', file, test.local, test.localfailed);
END End;

(** Finalize tests and print out total statistics *)
PROCEDURE Finalize* (VAR test: TEST; file: ARRAY OF CHAR);
BEGIN
    OSStream.stdout.Format('%-32s tests: %4d  failed: %3d\n', "SUMMARY", test.tests, test.failed);
    OSStream.stdout.Format('END %s\n\n', file);
END Finalize;

(**
Assert procedure.

id should be a sequental number starting from 1.
*)
PROCEDURE Assert* (VAR test: TEST; b: BOOLEAN; file: ARRAY OF CHAR; id: LONGINT) ;
BEGIN
    INC(test.local);
    INC(test.localid);
    IF test.localid # id THEN
        OSStream.stdout.Format("%s: WARNING id:%d does not match counter:%d\n", file, id, test.localid) ;
    END;
    IF NOT b THEN
        OSStream.stdout.Format("%s:%d:Assert failed\n", file, id) ;
        INC(test.localfailed);
    END;
END Assert ;

END O2Testing.