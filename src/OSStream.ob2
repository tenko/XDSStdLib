(**
Module for Stream class with access to OS files and the standard streams.

The standard streams `stdin`, `stdout` and `stderr` are accessable as variables
exported from this module and is opened on demand.

Reference :ref:`Object` module for further details on procedures/functions.
*)
MODULE OSStream;

IMPORT SYSTEM, Type, Object, Fmt := Format, String, xlibOS, ChanConsts, xFilePos;

CONST
    -- Open Mode --
    ModeRead* = xlibOS.X2C_fAccessRead;
    ModeWrite* = xlibOS.X2C_fAccessWrite;
    ModeNew* = xlibOS.X2C_fModeNew;
    ModeText* = xlibOS.X2C_fModeText;
    ModeRaw* = xlibOS.X2C_fModeRaw;
    -- Seek --
    SeekSet* = Object.SeekSet;
    SeekCur* = Object.SeekCur;
    SeekEnd* = Object.SeekEnd;
    -- Errors --
    StreamOK*                   = Object.StreamOK;
    StreamNotImplementedError*  = Object.StreamNotImplementedError;
    StreamNotOpenError*         = Object.StreamNotOpenError;
    StreamReadError*            = Object.StreamReadError;
    StreamWriteError*           = Object.StreamWriteError;

TYPE
    BYTE = SYSTEM.BYTE;

    StreamDesc* = Object.StreamDesc;

    StreamFile* = POINTER TO StreamFileDesc;
    StreamFileDesc* = RECORD (StreamDesc)
        fh : xlibOS.X2C_OSFHANDLE;
        mode : SET;
        opened : BOOLEAN;
    END;
    StreamStdIn* = POINTER TO StreamStdInDesc;
    StreamStdInDesc* = RECORD (StreamDesc)
        fh : xlibOS.X2C_OSFHANDLE;
        opened : BOOLEAN;
    END;
    StreamStdOut* = POINTER TO StreamStdOutDesc;
    StreamStdOutDesc* = RECORD (StreamDesc)
        fh : xlibOS.X2C_OSFHANDLE;
        opened : BOOLEAN;
    END;
    StreamStdErr* = POINTER TO StreamStdErrDesc;
    StreamStdErrDesc* = RECORD (StreamDesc)
        fh : xlibOS.X2C_OSFHANDLE;
        opened : BOOLEAN;
    END;

VAR
    stdin- : StreamStdIn;
    stdout- : StreamStdOut;
    stderr- : StreamStdErr;

--
-- StreamFile
--

(**
Open a OS file with given mode (defaults to  `ModeRead` + `ModeRaw`).
Return `TRUE` on success.
*)
PROCEDURE (s : StreamFile) Open*(filename- : ARRAY OF CHAR; mode := ModeRead + ModeRaw: SET): BOOLEAN;
BEGIN
    s.mode := mode;
    s.opened := xlibOS.X2C_fOpen(s.fh, filename, s.mode) = ChanConsts.opened;
    RETURN s.opened
END Open;

(**
Writes formatted string according to fmt definition and arguments.
Reference :ref:`Format` module for further details.
Sets error to `StreamWriteError` on failure.
*)
PROCEDURE (s : StreamFile) Format*(fmt- : ARRAY OF CHAR; SEQ seq: SYSTEM.BYTE);
BEGIN
    Fmt.StreamFmt(s, fmt, seq);
END Format;

(**
Writes formatted string from `LONGLONGINT` value.
This is a separate procedure for handling `64bit` values
due to a limitation in the `XDS` compiler. 
Reference :ref:`Format` module for further details.
Sets error to `StreamWriteError` on failure.
*)
PROCEDURE (s : StreamFile) FormatInteger*(value : LONGLONGINT; width := 0 : LONGINT; flags := {} : SET);
BEGIN Fmt.Integer(s, value, width, flags)
END FormatInteger;

(**
Writes formatted string from `CARD64` value.
This is a separate procedure for handling `64bit` values
due to a limitation in the `XDS` compiler. 
Reference :ref:`Format` module for further details.
Sets error to `StreamWriteError` on failure.
*)
PROCEDURE (s : StreamFile) FormatCardinal*(value : SYSTEM.CARD64; base := 10 : INTEGER; width := 0 : LONGINT; flags := {} : SET);
BEGIN Fmt.Cardinal(s, value, base, width, flags)
END FormatCardinal;

(** Read bytes into buffer with optional start and length. *)
PROCEDURE (s : StreamFile) ReadBytes*(VAR buffer : ARRAY OF BYTE; start := 0 : LONGINT; length := - 1 : LONGINT): LONGINT;
    VAR len, ret : SYSTEM.CARD32;
BEGIN
    IF length < 0 THEN length := LEN(buffer) END;
    len := VAL(SYSTEM.CARD32, length - start);
    IF xlibOS.X2C_fRead(s.fh, SYSTEM.ADR(buffer[start]), len, ret) = 0 THEN RETURN ret END;
    RETURN -1
END ReadBytes;

(** Write bytes from buffer with optional start and length. *)
PROCEDURE (s : StreamFile) WriteBytes*(buffer- : ARRAY OF BYTE; start := 0 : LONGINT; length := - 1 : LONGINT): LONGINT;
    VAR len, ret : SYSTEM.CARD32;
BEGIN
    IF length < 0 THEN length := LEN(buffer) END;
    len := VAL(SYSTEM.CARD32, length - start);
    IF xlibOS.X2C_fWrite(s.fh, SYSTEM.ADR(buffer[start]), len, ret) = 0 THEN RETURN ret END;
    RETURN -1;
END WriteBytes;

(**
Offsets or set the current location depending on the
mode argument:

 * `SeekSet` : sets position relative to start of stream.
 * `SeekCur` : sets position relative to current position of stream.
 * `SeekEnd` : sets position relative to end position of stream (only negative offset values makes sense).

Return new position or -1 in case of failure.
*)
PROCEDURE (s : StreamFile) Seek*(offset : LONGINT; mode := SeekSet : INTEGER): LONGINT;
    VAR
        pos: xlibOS.X2C_FPOS;
        ret : LONGINT;
BEGIN
    xFilePos.IntToPos(pos, offset);
    IF xlibOS.X2C_fSeek(s.fh, pos, mode) = 0 THEN
        IF xFilePos.PosToInt(ret, pos) THEN RETURN ret END;
    END;
    RETURN -1
END Seek;

(** Return current position or -1 on failure. *)
PROCEDURE (s : StreamFile) Tell*(): LONGINT;
    VAR
        pos: xlibOS.X2C_FPOS;
        ret : LONGINT;
BEGIN
    IF xlibOS.X2C_fTell(s.fh, pos) = 0 THEN
        IF xFilePos.PosToInt(ret, pos) THEN RETURN ret END;
    END;
    RETURN -1;
END Tell;

(**
Truncates or extends stream to new size.
Return new size or -1 in case of failure.
*)
PROCEDURE (s : StreamFile) Truncate*(size : LONGINT): LONGINT;
    VAR
        pos: xlibOS.X2C_FPOS;
        ret : LONGINT;
BEGIN
    xFilePos.IntToPos(pos, size);
    IF xlibOS.X2C_fSeek(s.fh, pos, SeekSet) = 0 THEN
        IF xlibOS.X2C_fChSize(s.fh) = 0 THEN
            RETURN size
        END
    END;
    RETURN -1
END Truncate;

(** Flush buffers *)
PROCEDURE (s : StreamFile) Flush*();
    VAR ret : LONGINT;
BEGIN
    ret := xlibOS.X2C_fFlush(s.fh)
END Flush;

(** Close Stream *)
PROCEDURE (s : StreamFile) Close*();
BEGIN
    IF s.opened THEN s.opened := xlibOS.X2C_fClose(s.fh) = 0
    ELSE s.error := StreamNotOpenError
    END;
END Close;

(** Return `TRUE` if Stream is closed *)
PROCEDURE (s : StreamFile) Closed*(): BOOLEAN;
BEGIN RETURN ~s.opened END Closed;

(** Return `TRUE` if Stream is readable *)
PROCEDURE (s : StreamFile) Readable*(): BOOLEAN;
BEGIN RETURN s.mode * ModeRead # {} END Readable;

(** Return `TRUE` if Stream is writeable *)
PROCEDURE (s : StreamFile) Writeable*(): BOOLEAN;
BEGIN RETURN s.mode * ModeWrite # {} END Writeable;

(** Return `TRUE` if Stream is seekable *)
PROCEDURE (s : StreamFile) Seekable*(): BOOLEAN;
BEGIN RETURN TRUE END Seekable;

--
-- StreamStdIn
--

PROCEDURE (s : StreamStdIn) CheckOpen(): BOOLEAN;
BEGIN
    IF ~s.opened THEN s.opened := xlibOS.X2C_fGetStd(s.fh, xlibOS.X2C_fStdIn) = 0 END;
    RETURN s.opened;
END CheckOpen;

(** Read bytes into buffer with optional start and length. *)
PROCEDURE (s : StreamStdIn) ReadBytes*(VAR buffer : ARRAY OF BYTE; start := 0 : LONGINT; length := - 1 : LONGINT): LONGINT;
    VAR len, ret : SYSTEM.CARD32;
BEGIN
    IF ~s.CheckOpen() THEN RETURN -1 END;
    IF length < 0 THEN length := LEN(buffer) END;
    len := VAL(SYSTEM.CARD32, length - start);
    IF xlibOS.X2C_fRead(s.fh, SYSTEM.ADR(buffer[start]), len, ret) = 0 THEN RETURN ret END;
    RETURN -1
END ReadBytes;

(** Read `CHAR` value. Return `TRUE` if success. *)
PROCEDURE (s : StreamStdIn) ReadChar*(VAR value : CHAR): BOOLEAN;
BEGIN RETURN s.ReadBytes(value, 0, SYSTEM.BYTES(value)) = SYSTEM.BYTES(value) END ReadChar;

(** Return `TRUE` if Stream is readable *)
PROCEDURE (s : StreamStdIn) Readable*(): BOOLEAN;
BEGIN RETURN TRUE END Readable;

(** Return `TRUE` if Stream is a TTY *)
PROCEDURE (s : StreamStdIn) IsTTY*(): BOOLEAN;
BEGIN RETURN TRUE END IsTTY;

--
-- StreamStdOut
--

PROCEDURE (s : StreamStdOut) CheckOpen(): BOOLEAN;
BEGIN
    IF ~s.opened THEN s.opened := xlibOS.X2C_fGetStd(s.fh, xlibOS.X2C_fStdOut) = 0 END;
    RETURN s.opened;
END CheckOpen;

(**
Writes formatted string according to fmt definition and arguments.
Reference :ref:`Format` module for further details.
Sets error to `StreamWriteError` on failure.
*)
PROCEDURE (s : StreamStdOut) Format*(fmt- : ARRAY OF CHAR; SEQ seq: SYSTEM.BYTE);
BEGIN Fmt.StreamFmt(s, fmt, seq);
END Format;

(**
Writes formatted string from `LONGLONGINT` value.
This is a separate procedure for handling `64bit` values
due to a limitation in the `XDS` compiler. 
Reference :ref:`Format` module for further details.
Sets error to `StreamWriteError` on failure.
*)
PROCEDURE (s : StreamStdOut) FormatInteger*(value : LONGLONGINT; width := 0 : LONGINT; flags := {} : SET);
BEGIN Fmt.Integer(s, value, width, flags)
END FormatInteger;

(**
Writes formatted string from `CARD64` value.
This is a separate procedure for handling `64bit` values
due to a limitation in the `XDS` compiler. 
Reference :ref:`Format` module for further details.
Sets error to `StreamWriteError` on failure.
*)
PROCEDURE (s : StreamStdOut) FormatCardinal*(value : SYSTEM.CARD64; base := 10 : INTEGER; width := 0 : LONGINT; flags := {} : SET);
BEGIN Fmt.Cardinal(s, value, base, width, flags)
END FormatCardinal;

(** Write bytes from buffer with optional start and length. *)
PROCEDURE (s : StreamStdOut) WriteBytes*(buffer- : ARRAY OF BYTE; start := 0 : LONGINT; length := - 1 : LONGINT): LONGINT;
    VAR len, ret : SYSTEM.CARD32;
BEGIN
    IF ~s.CheckOpen() THEN RETURN -1 END;
    IF length < 0 THEN length := LEN(buffer) END;
    len := VAL(SYSTEM.CARD32, length - start);
    IF xlibOS.X2C_fWrite(s.fh, SYSTEM.ADR(buffer[start]), len, ret) = 0 THEN RETURN ret END;
    RETURN -1;
END WriteBytes;

(** Return `TRUE` if Stream is writeable *)
PROCEDURE (s : StreamStdOut) Writeable*(): BOOLEAN;
BEGIN RETURN TRUE END Writeable;

(** Return `TRUE` if Stream is a TTY *)
PROCEDURE (s : StreamStdOut) IsTTY*(): BOOLEAN;
BEGIN RETURN TRUE END IsTTY;

--
-- StreamStdErr
--

PROCEDURE (s : StreamStdErr) CheckOpen(): BOOLEAN;
BEGIN
    IF ~s.opened THEN s.opened := xlibOS.X2C_fGetStd(s.fh, xlibOS.X2C_fStdErr) = 0 END;
    RETURN s.opened;
END CheckOpen;

(**
Writes formatted string according to fmt definition and arguments.
Reference :ref:`Format` module for further details.
Sets error to `StreamWriteError` on failure.
*)
PROCEDURE (s : StreamStdErr) Format*(fmt- : ARRAY OF CHAR; SEQ seq: SYSTEM.BYTE);
BEGIN
    Fmt.StreamFmt(s, fmt, seq);
END Format;

(**
Writes formatted string from `LONGLONGINT` value.
This is a separate procedure for handling `64bit` values
due to a limitation in the `XDS` compiler. 
Reference :ref:`Format` module for further details.
Sets error to `StreamWriteError` on failure.
*)
PROCEDURE (s : StreamStdErr) FormatInteger*(value : LONGLONGINT; width := 0 : LONGINT; flags := {} : SET);
BEGIN Fmt.Integer(s, value, width, flags)
END FormatInteger;

(**
Writes formatted string from `CARD64` value.
This is a separate procedure for handling `64bit` values
due to a limitation in the `XDS` compiler. 
Reference :ref:`Format` module for further details.
Sets error to `StreamWriteError` on failure.
*)
PROCEDURE (s : StreamStdErr) FormatCardinal*(value : SYSTEM.CARD64; base := 10 : INTEGER; width := 0 : LONGINT; flags := {} : SET);
BEGIN Fmt.Cardinal(s, value, base, width, flags)
END FormatCardinal;

(** Write bytes from buffer with optional start and length. *)
PROCEDURE (s : StreamStdErr) WriteBytes*(buffer- : ARRAY OF BYTE; start := 0 : LONGINT; length := - 1 : LONGINT): LONGINT;
    VAR len, ret : SYSTEM.CARD32;
BEGIN
    IF ~s.CheckOpen() THEN RETURN -1 END;
    IF length < 0 THEN length := LEN(buffer) END;
    len := VAL(SYSTEM.CARD32, length - start);
    IF xlibOS.X2C_fWrite(s.fh, SYSTEM.ADR(buffer[start]), len, ret) = 0 THEN RETURN ret END;
    RETURN -1;
END WriteBytes;

(** Return `TRUE` if Stream is writeable *)
PROCEDURE (s : StreamStdErr) Writeable*(): BOOLEAN;
BEGIN RETURN TRUE END Writeable;

(** Return `TRUE` if Stream is a TTY *)
PROCEDURE (s : StreamStdErr) IsTTY*(): BOOLEAN;
BEGIN RETURN TRUE END IsTTY;

BEGIN
    NEW(stdin);
    NEW(stdout);
    NEW(stderr);
END OSStream.