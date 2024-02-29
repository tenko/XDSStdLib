(**
Stream classes which implements concrete streams
according to the interface defined in :ref:`Object`.

The following classes are implemented
 * `NullStream` - Swallow any write operation and return 0 on read operations.
 * `MemoryStream` - Allocate dynamic memory as needed for operations.

Some methods are inherited from abstract `Stream` in :ref:`Object`.
*)
MODULE ADTStream;

IMPORT SYSTEM, Object, Const, Fmt := Format, ArrayOfByte, String;

CONST
    INIT_SIZE* = 64;
    -- Seek --
    SeekSet* = Const.SeekSet;
    SeekCur* = Const.SeekCur;
    SeekEnd* = Const.SeekEnd;
    -- Errors --
    StreamOK                    = Const.StreamOK;
    StreamNotImplementedError   = Const.StreamNotImplementedError;
    StreamNotOpenError          = Const.StreamNotOpenError;
    StreamReadError             = Const.StreamReadError;
    StreamWriteError            = Const.StreamWriteError;

TYPE
    BYTE = SYSTEM.BYTE;
    NullStream* = POINTER TO NullStreamDesc;
    NullStreamDesc* = RECORD (Object.StreamDesc)END;
    MemoryStorage = POINTER TO ARRAY OF BYTE;
    MemoryStream* = POINTER TO MemoryStreamDesc;
    MemoryStreamDesc* = RECORD (Object.StreamDesc)
        storage : MemoryStorage;
        pos : LONGINT;
        last : LONGINT;
    END;
--
-- NullStream
--

(** Read bytes into buffer with optional start and length. *)
PROCEDURE (s : NullStream) ReadBytes*(VAR buffer : ARRAY OF BYTE; start := 0 : LONGINT; length := - 1 : LONGINT): LONGINT;
    VAR i : LONGINT;
BEGIN
    IF length < 0 THEN length := LEN(buffer) END;
    i := start;
    WHILE i < length DO buffer[i] := 0; INC(i) END;
    RETURN i - start
END ReadBytes;

(** Write bytes from buffer with optional start and length. *)
PROCEDURE (s : NullStream) WriteBytes*(buffer- : ARRAY OF BYTE; start := 0 : LONGINT; length := - 1 : LONGINT): LONGINT;
BEGIN
    IF length < 0 THEN length := LEN(buffer) END;
    RETURN length - start
END WriteBytes;

(** Return `TRUE` if Stream is readable *)
PROCEDURE (s : NullStream) Readable*(): BOOLEAN;
BEGIN RETURN TRUE END Readable;

(** Return `TRUE` if Stream is writeable *)
PROCEDURE (s : NullStream) Writeable*(): BOOLEAN;
BEGIN RETURN TRUE END Writeable;

(** Return `TRUE` if Stream is seekable *)
PROCEDURE (s : NullStream) Seekable*(): BOOLEAN;
BEGIN RETURN FALSE END Seekable;

--
-- MemoryStream
--

(**
Open `MemoryStream` with optional size (defaults to `INIT_SIZE`).

Return `TRUE` if success.
*)
PROCEDURE (s : MemoryStream) Open*(size := INIT_SIZE : LONGINT): BOOLEAN;
BEGIN
    ASSERT(size > 0);
    IF size < INIT_SIZE THEN size := INIT_SIZE END;
    IF s.storage = NIL THEN
        NEW(s.storage, size);
        s.pos := 0;
        s.last := 0;
        RETURN TRUE
    END;
    RETURN FALSE
END Open;

(**
Copy Stream content to string.
The string is possible resized and is NUL terminated.
*)
PROCEDURE (s : MemoryStream) ToString*(VAR str : String.STRING);
BEGIN
    String.Reserve(str, s.last + 1, FALSE);
    ArrayOfByte.Copy(s.storage^, str^, s.last);
    str[s.last] := 00X;
END ToString;

(** Read bytes into buffer with optional start and length. *)
PROCEDURE (s : MemoryStream) ReadBytes*(VAR buffer : ARRAY OF BYTE; start := 0 : LONGINT; length := - 1 : LONGINT): LONGINT;
    VAR i : LONGINT;
BEGIN
    IF length < 0 THEN length := LEN(buffer) END;
    i := start;
    WHILE (s.pos < s.last) & (i < length) DO
        buffer[i] := s.storage[s.pos];
        INC(s.pos); INC(i)
    END;
    RETURN i - start
END ReadBytes;

(** Resize storage to accomodate capacity *)
PROCEDURE (s : MemoryStream) Reserve*(capacity  : LONGINT);
    VAR
        storage : MemoryStorage;
        cap : LONGINT;
BEGIN
    ASSERT(capacity > 0);
    cap := LEN(s.storage^);
    IF capacity > cap THEN
        WHILE cap < capacity DO cap := cap * 2 END;
        NEW(storage, cap);
        IF s.last > 0 THEN
            ArrayOfByte.Copy(storage^, s.storage^, s.last)
        END;
        s.storage := storage
    END;
END Reserve;

(** Shrink storage if possible *)
PROCEDURE (s : MemoryStream) Shrink*();
    VAR
        storage : MemoryStorage;
        cap : LONGINT;
BEGIN
    cap := LEN(s.storage^);
    IF cap > s.last + 1 THEN
        WHILE (cap > s.last) & (cap > INIT_SIZE) DO cap := cap DIV 2 END;
        IF cap < s.last THEN cap := cap * 2 END;
        NEW(storage, cap);
        IF s.last > 0 THEN
            ArrayOfByte.Copy(storage^, s.storage^, s.last)
        END;
        s.storage := storage
    END;
END Shrink;

(** Append data to end and expand size if needed *)
PROCEDURE (s : MemoryStream) Append(data : BYTE);
    VAR capacity : LONGINT;
BEGIN
    capacity := LEN(s.storage^);
    IF s.last >= capacity THEN
        s.Reserve(capacity + 1)
    END;
    s.storage[s.last] := data;
    INC(s.last)
END Append;

(** Write bytes from buffer with optional start and length. *)
PROCEDURE (s : MemoryStream) WriteBytes*(buffer- : ARRAY OF BYTE; start := 0 : LONGINT; length := - 1 : LONGINT): LONGINT;
    VAR i : LONGINT;
BEGIN
    IF length < 0 THEN length := LEN(buffer) END;
    i := start;
    WHILE (s.pos < s.last) & (i < length) DO
        s.storage[s.pos] := buffer[i];
        INC(s.pos); INC(i)
    END;
    WHILE i < length DO
        s.Append(buffer[i]);
        INC(s.pos); INC(i)
    END;
    RETURN i - start
END WriteBytes;

(**
Writes formatted string according to fmt definition and arguments.
Reference :ref:`Format` module for further details.
Sets error to `StreamWriteError` on failure.
*)
PROCEDURE (s : MemoryStream) Format*(fmt- : ARRAY OF CHAR; SEQ seq: SYSTEM.BYTE);
BEGIN
    Fmt.StreamFmt(s, fmt, seq);
END Format;

(**
Offsets or set the current location depending on the
mode argument:

 * `SeekSet` : sets position relative to start of stream.
 * `SeekCur` : sets position relative to current position of stream.
 * `SeekEnd` : sets position relative to end position of stream (only negative offset values makes sense).

Return new position or -1 in case of failure.
*)
PROCEDURE (s : MemoryStream) Seek*(offset : LONGINT; mode := SeekSet : INTEGER): LONGINT;
BEGIN
    CASE mode OF
        SeekSet  : s.pos := offset;
      | SeekCur  : s.pos := s.pos + offset;
      | SeekEnd  : s.pos := s.last + offset - 1;
    ELSE
        RETURN -1
    END;
    IF s.pos < 0 THEN s.pos := 0
    ELSIF s.pos > s.last THEN s.pos := s.last - 1 END;
    RETURN s.pos
END Seek;

(** Return current position or -1 on failure. *)
PROCEDURE (s : MemoryStream) Tell*(): LONGINT;
BEGIN
    RETURN s.pos;
END Tell;

(**
Truncates or extends stream to new size.
Return new size or -1 in case of failure.
*)
PROCEDURE (s : MemoryStream) Truncate*(size : LONGINT): LONGINT;
    VAR i, cap : LONGINT;
BEGIN
    IF size <= 0 THEN size := 1 END;
    cap := LEN(s.storage^);
    s.Reserve(size);
    IF (cap > 4*INIT_SIZE) & (LEN(s.storage^) < cap)  THEN s.Shrink() END;
    i := LEN(s.storage^) - 1;
    WHILE i >= size DO s.storage[i] := 0; DEC(i) END;
    IF size < s.last THEN s.last := size END;
    IF size < s.pos THEN s.pos := size - 1 END;
    RETURN size
END Truncate;

(** Close Stream *)
PROCEDURE (s : MemoryStream) Close*();
BEGIN
    IF s.storage # NIL THEN s.storage := NIL
    ELSE s.error := StreamNotOpenError
    END;
END Close;

(** Return `TRUE` if Stream is closed *)
PROCEDURE (s : MemoryStream) Closed*(): BOOLEAN;
BEGIN RETURN s.storage = NIL END Closed;

(** Return `TRUE` if Stream is readable *)
PROCEDURE (s : MemoryStream) Readable*(): BOOLEAN;
BEGIN RETURN TRUE END Readable;

(** Return `TRUE` if Stream is writeable *)
PROCEDURE (s : MemoryStream) Writeable*(): BOOLEAN;
BEGIN RETURN TRUE END Writeable;

(** Return `TRUE` if Stream is seekable *)
PROCEDURE (s : MemoryStream) Seekable*(): BOOLEAN;
BEGIN RETURN TRUE END Seekable;

END ADTStream.