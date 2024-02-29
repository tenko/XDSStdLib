(**
Module with library wide abstract interface types.
*)
MODULE Object;

IMPORT SYSTEM, Type, Const;

CONST
    -- Stream Seek --
    SeekSet*    = Const.SeekSet;
    SeekCur*    = Const.SeekCur;
    SeekEnd*    = Const.SeekEnd;

    StreamOK*                   = Const.StreamOK;
    StreamNotImplementedError*  = Const.StreamNotImplementedError;
    StreamNotOpenError*         = Const.StreamNotOpenError;
    StreamReadError*            = Const.StreamReadError;
    StreamWriteError*           = Const.StreamWriteError;

TYPE
    (* Abstract Stream Class *)
    Stream* = POINTER TO StreamDesc;
    StreamDesc* = RECORD
        error* : LONGINT;
    END;

--
-- Stream (Abstract)
--

(** Return `TRUE` if the `Stream` operation has returned an error.  *)
PROCEDURE (s : Stream) HasError*(): BOOLEAN;
BEGIN RETURN s.error # StreamOK
END HasError;

(** Return last error code or `StreamOK` if no error is set. *)
PROCEDURE (s : Stream) LastError*(): LONGINT;
BEGIN RETURN s.error
END LastError;

(** Clear error status to `StreamOK`. *)
PROCEDURE (s : Stream) ClearError*();
BEGIN s.error := StreamOK
END ClearError;

(** Read bytes into buffer with optional start and length. *)
PROCEDURE (s : Stream) ReadBytes*(VAR buffer : ARRAY OF SYSTEM.BYTE; start := 0 : LONGINT; length := - 1 : LONGINT): LONGINT;
BEGIN
    s.error := StreamNotImplementedError;
    RETURN -1
END ReadBytes;

(** Read `BYTE` value. Return `TRUE` if success. *)
PROCEDURE (s : Stream) ReadByte*(VAR value : SYSTEM.BYTE): BOOLEAN;
BEGIN RETURN s.ReadBytes(value, 0, SYSTEM.BYTES(value)) = SYSTEM.BYTES(value) END ReadByte;

(** Read `CHAR` value. Return `TRUE` if success. *)
PROCEDURE (s : Stream) ReadChar*(VAR value : CHAR): BOOLEAN;
BEGIN RETURN s.ReadBytes(value, 0, SYSTEM.BYTES(value)) = SYSTEM.BYTES(value) END ReadChar;

(** Read `INTEGER` value. Return `TRUE` if success. *)
PROCEDURE (s : Stream) ReadInteger*(VAR value : INTEGER): BOOLEAN;
BEGIN RETURN s.ReadBytes(value, 0, SYSTEM.BYTES(value)) = SYSTEM.BYTES(value) END ReadInteger;

(** Read `LONGINT` value. Return `TRUE` if success. *)
PROCEDURE (s : Stream) ReadLongInt*(VAR value : LONGINT): BOOLEAN;
BEGIN RETURN s.ReadBytes(value, 0, SYSTEM.BYTES(value)) = SYSTEM.BYTES(value) END ReadLongInt;

(** Read `REAL` value. Return `TRUE` if success. *)
PROCEDURE (s : Stream) ReadReal*(VAR value : REAL): BOOLEAN;
BEGIN RETURN s.ReadBytes(value, 0, SYSTEM.BYTES(value)) = SYSTEM.BYTES(value) END ReadReal;

(** Read `LONGREAL` value. Return `TRUE` if success. *)
PROCEDURE (s : Stream) ReadLongReal*(VAR value : LONGREAL): BOOLEAN;
BEGIN RETURN s.ReadBytes(value, 0, SYSTEM.BYTES(value)) = SYSTEM.BYTES(value) END ReadLongReal;

(**
Read line to `EOL` mark or `EOF` mark.
`STRING` possible reallocated to contain whole line if needed.
Return `TRUE` if success.
*)
PROCEDURE (s : Stream) ReadLine*(VAR value : Type.STRING): BOOLEAN;
    VAR
        i, len : LONGINT;
        ch : CHAR;
        eof : BOOLEAN;
        (* Reimplemented here to avoid circular import from String *)
        PROCEDURE Reserve(VAR dst :Type.STRING; capacity : LONGINT);
            VAR tmp : Type.STRING;
        BEGIN
            IF capacity < 2 THEN capacity := 2 END;
            IF dst = NIL THEN
                NEW(dst, capacity);
            ELSIF LEN(dst^) <= capacity THEN
                NEW(tmp, capacity);
                COPY(dst^, tmp^);
                dst := tmp;
            END;
        END Reserve;
BEGIN
    Reserve(value, 1);
    value^[0] := 00X;
    i := 0 ; eof := FALSE;
    len := LEN(value^);
    LOOP
        IF i >= len THEN
            len := 2 * len;
            Reserve(value, len);
        END;
        IF ~s.ReadChar(ch) THEN eof := TRUE; EXIT END;
        <* IF (env_target = "x86nt") THEN *>
        IF ch = 0DX THEN
            IF ~s.ReadChar(ch) THEN EXIT END;
            IF ch = 0AX THEN EXIT END
        <* ELSE *>
        IF ch = 0AX THEN EXIT
        <* END *>
        ELSIF ch = 00X THEN EXIT
        END;
        value^[i] := ch;
        INC(i);
    END;
    value[i] := 00X;
    IF (i = 0) & eof THEN RETURN FALSE END;
    RETURN TRUE
END ReadLine;

(** Write bytes from buffer with optional start and length. *)
PROCEDURE (s : Stream) WriteBytes*(buffer- : ARRAY OF SYSTEM.BYTE; start := 0 : LONGINT; length := - 1 : LONGINT): LONGINT;
BEGIN
    s.error := StreamNotImplementedError;
    RETURN -1
END WriteBytes;

(** Write `BYTE` value. Sets error to `StreamWriteError` on failure. *)
PROCEDURE (s : Stream) WriteByte*(value : SYSTEM.BYTE);
BEGIN
    IF s.WriteBytes(value, 0, SYSTEM.BYTES(value)) = SYSTEM.BYTES(value) THEN
        s.error := StreamWriteError
    END
END WriteByte;

(** Write `CHAR` value. Sets error to `StreamWriteError` on failure. *)
PROCEDURE (s : Stream) WriteChar*(value : CHAR);
BEGIN
    IF s.WriteBytes(value, 0, SYSTEM.BYTES(value)) # SYSTEM.BYTES(value) THEN
        s.error := StreamWriteError
    END
END WriteChar;

(** Write `INTEGER` value. Sets error to `StreamWriteError` on failure. *)
PROCEDURE (s : Stream) WriteInteger*(value : INTEGER);
BEGIN
    IF s.WriteBytes(value, 0, SYSTEM.BYTES(value)) # SYSTEM.BYTES(value) THEN
        s.error := StreamWriteError
    END
END WriteInteger;

(** Write `LONGINT` value. Sets error to `StreamWriteError` on failure. *)
PROCEDURE (s : Stream) WriteLongInt*(value : LONGINT);
BEGIN
    IF s.WriteBytes(value, 0, SYSTEM.BYTES(value)) # SYSTEM.BYTES(value) THEN
        s.error := StreamWriteError
    END
END WriteLongInt;

(** Write `REAL` value. Sets error to `StreamWriteError` on failure. *)
PROCEDURE (s : Stream) WriteReal*(value : REAL);
BEGIN
    IF s.WriteBytes(value, 0, SYSTEM.BYTES(value)) # SYSTEM.BYTES(value) THEN
        s.error := StreamWriteError
    END
END WriteReal;

(** Write `LONGREAL` value. Sets error to `StreamWriteError` on failure. *)
PROCEDURE (s : Stream) WriteLongReal*(value : LONGREAL);
BEGIN
    IF s.WriteBytes(value, 0, SYSTEM.BYTES(value)) # SYSTEM.BYTES(value) THEN
        s.error := StreamWriteError
    END
END WriteLongReal;

(**
Write `ARRAY OF CHAR` value to NULL byte or length of array.
Sets error to `StreamWriteError` on failure.
*)
PROCEDURE (s : Stream) WriteString*(value- : ARRAY OF CHAR);
    VAR len : LONGINT;
BEGIN
    len := LENGTH(value);
    IF len > 0 THEN
        IF s.WriteBytes(value, 0, len) # len THEN
            s.error := StreamWriteError
        END
    END
END WriteString;

(** Write platforms newline value to stream. Sets error to `StreamWriteError` on failure. *)
PROCEDURE (s : Stream) WriteNL*();
BEGIN
    <* IF (env_target = "x86nt") THEN *> 
    s.WriteChar(0DX);
    <* END *>
    s.WriteChar(0AX)
END WriteNL;

(** Write `Stream` `src` to stream. Sets error to `StreamWriteError` on failure. *)
PROCEDURE (s : Stream) WriteStream*(src : Stream);
    VAR value : SYSTEM.BYTE;
BEGIN
    WHILE src.ReadByte(value) DO s.WriteByte(value) END
END WriteStream;

(**
Writes formatted string according to fmt definition and arguments.
Reference :ref:`Format` module for further details.
Sets error to `StreamWriteError` on failure.
*)
PROCEDURE (s : Stream) Format*(fmt- : ARRAY OF CHAR; SEQ seq: SYSTEM.BYTE);
BEGIN s.error := StreamNotImplementedError END Format;

(**
Writes formatted string from `LONGLONGINT` value.
This is a separate procedure for handling `64bit` values
due to a limitation in the `XDS` compiler. 
Reference :ref:`Format` module for further details.
Sets error to `StreamWriteError` on failure.
*)
PROCEDURE (s : Stream) FormatInteger*(value : LONGLONGINT; width := 0 : LONGINT; flags := {} : SET);
BEGIN s.error := StreamNotImplementedError END FormatInteger;

(**
Writes formatted string from `CARD64` value.
This is a separate procedure for handling `64bit` values
due to a limitation in the `XDS` compiler. 
Reference :ref:`Format` module for further details.
Sets error to `StreamWriteError` on failure.
*)
PROCEDURE (s : Stream) FormatCardinal*(value : SYSTEM.CARD64; base := 10 : INTEGER; width := 0 : LONGINT; flags := {} : SET);
BEGIN s.error := StreamNotImplementedError END FormatCardinal;

(**
Offsets or set the current location depending on the
mode argument:

 * `SeekSet` : sets position relative to start of stream.
 * `SeekCur` : sets position relative to current position of stream.
 * `SeekEnd` : sets position relative to end position of stream (only negative offset values makes sense).

Return new position or -1 in case of failure.
*)
PROCEDURE (s : Stream) Seek*(offset : LONGINT; mode := SeekSet : INTEGER): LONGINT;
BEGIN
    s.error := StreamNotImplementedError;
    RETURN -1
END Seek;

(** Return current position or -1 on failure. *)
PROCEDURE (s : Stream) Tell*(): LONGINT;
BEGIN
    s.error := StreamNotImplementedError;
    RETURN -1
END Tell;

(**
Truncates or extends stream to new size.
Return new size or -1 in case of failure.
*)
PROCEDURE (s : Stream) Truncate*(size : LONGINT): LONGINT;
BEGIN
    s.error := StreamNotImplementedError;
    RETURN -1
END Truncate;

(** Flush buffers *)
PROCEDURE (s : Stream) Flush*();
BEGIN
    s.error := StreamNotImplementedError
END Flush;

(** Close Stream *)
PROCEDURE (s : Stream) Close*();
BEGIN
    s.error := StreamNotImplementedError
END Close;

(** Return `TRUE` if Stream is closed *)
PROCEDURE (s : Stream) Closed*(): BOOLEAN;
BEGIN RETURN FALSE END Closed;

(** Return `TRUE` if Stream is a TTY *)
PROCEDURE (s : Stream) IsTTY*(): BOOLEAN;
BEGIN RETURN FALSE END IsTTY;

(** Return `TRUE` if Stream is readable *)
PROCEDURE (s : Stream) Readable*(): BOOLEAN;
BEGIN RETURN FALSE END Readable;

(** Return `TRUE` if Stream is writeable *)
PROCEDURE (s : Stream) Writeable*(): BOOLEAN;
BEGIN RETURN FALSE END Writeable;

(** Return `TRUE` if Stream is seekable *)
PROCEDURE (s : Stream) Seekable*(): BOOLEAN;
BEGIN RETURN FALSE END Seekable;

END Object.