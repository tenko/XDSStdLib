(**
Module for logging to Streams.

Initially no stream is present and must be added
after creation of class.

Logging to a stream is dependent on the logging level
associated with the stream. The levels is in accending
order:

* `DEBUG`
* `INFO`
* `WARN`
* `ERROR`
* `FATAL`

Logging to the stream will only be done for the associated
level and higher levels.
*)
MODULE Log;

IMPORT SYSTEM, Const, Object, ADTStream, Format, DateTime;

TYPE
    LogStream  = RECORD
        level : SHORTINT;
        maxSize : LONGINT;
        stream : Object.Stream;
    END;
    TLevelStr = ARRAY 5, 6 OF CHAR;

CONST
    DEBUG*  = Const.DEBUG;
    INFO*   = Const.INFO;
    WARN*   = Const.WARN;
    ERROR*  = Const.ERROR;
    FATAL*  = Const.FATAL;
    
    LEVELSTR = TLevelStr{
        "FATAL", "ERROR", "WARN", "INFO", "DEBUG"
    };

    LOGSIZE = 16;

VAR
    fh : ADTStream.MemoryStream;
    logstreams : ARRAY LOGSIZE OF LogStream;
    logs : SHORTINT;

PROCEDURE Log(level : SHORTINT; fmt- : ARRAY OF CHAR; seq: ARRAY OF SYSTEM.BYTE);
    VAR
        s : Object.Stream;
        hour, min, sec, msec: LONGINT;
        i : SHORTINT;
BEGIN
    DateTime.DecodeTime(DateTime.Now(), hour, min, sec, msec);
    SYSTEM.EVAL(fh.Seek(0));
    SYSTEM.EVAL(fh.Truncate(0));
    fh.Format("%02d:%02d:%02d.%03d %s ", hour, min, sec, msec, LEVELSTR[level]);
    IF LEN(seq) > 0 THEN Format.StreamFmt(fh, fmt, seq)
    ELSE fh.WriteString(fmt)
    END;
    fh.WriteNL();
    i := 0;
    WHILE i < logs DO
        IF logstreams[i].level <= level THEN
            s := logstreams[i].stream;
            IF ~s.Closed() & s.Writeable() THEN
                SYSTEM.EVAL(fh.Seek(0));
                s.WriteStream(fh);
            END;
        END;
        INC(i);
    END;
END Log;

(**
`DEBUG` level logging.

Reference to :ref:`Format` for formatting options.
*)
PROCEDURE Debug*(fmt- : ARRAY OF CHAR; SEQ seq: SYSTEM.BYTE);
BEGIN Log(DEBUG, fmt, seq);
END Debug;

(**
`INFO` level logging.

Reference to :ref:`Format` for formatting options.
*)
PROCEDURE Info*(fmt- : ARRAY OF CHAR; SEQ seq: SYSTEM.BYTE);
BEGIN Log(INFO, fmt, seq);
END Info;

(**
`WARN` level logging.

Reference to :ref:`Format` for formatting options.
*)
PROCEDURE Warn*(fmt- : ARRAY OF CHAR; SEQ seq: SYSTEM.BYTE);
BEGIN Log(WARN, fmt, seq);
END Warn;

(**
`ERROR` level logging.

Reference to :ref:`Format` for formatting options.
*)
PROCEDURE Error*(fmt- : ARRAY OF CHAR; SEQ seq: SYSTEM.BYTE);
BEGIN Log(ERROR, fmt, seq);
END Error;

(**
`FATAL` level logging.

Reference to :ref:`Format` for formatting options.
*)
PROCEDURE Fatal*(fmt- : ARRAY OF CHAR; SEQ seq: SYSTEM.BYTE);
BEGIN Log(FATAL, fmt, seq);
END Fatal;

(**
Add a stream object to the list of stream to log to.
Up to 16 streams can be added. The logging will be
done for the defined level (default to `ERROR`) and
higher levels.
*)
PROCEDURE AddStream*(stream : Object.Stream; level := ERROR : SHORTINT) : BOOLEAN;
BEGIN
    IF logs < LOGSIZE THEN
        IF ~stream.Writeable() THEN RETURN FALSE END;
        logstreams[logs].level := level;
        logstreams[logs].stream := stream;
        INC(logs);
        RETURN TRUE
    END;
    RETURN FALSE;
END AddStream;

BEGIN
    logs := 0;
    NEW(fh); 
    SYSTEM.EVAL(fh.Open());
END Log.