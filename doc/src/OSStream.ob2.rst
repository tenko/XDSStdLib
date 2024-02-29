.. index::
    single: OSStream

.. _OSStream:

********
OSStream
********


Module for Stream class with access to OS files and the standard streams.

The standard streams `stdin`, `stdout` and `stderr` are accessable as variables
exported from this module and is opened on demand.

Reference :ref:`Object` module for further details on procedures/functions.


Const
=====

.. code-block:: modula2

    ModeRead* = xlibOS.X2C_fAccessRead;

.. code-block:: modula2

    ModeWrite* = xlibOS.X2C_fAccessWrite;

.. code-block:: modula2

    ModeNew* = xlibOS.X2C_fModeNew;

.. code-block:: modula2

    ModeText* = xlibOS.X2C_fModeText;

.. code-block:: modula2

    ModeRaw* = xlibOS.X2C_fModeRaw;

.. code-block:: modula2

    SeekSet* = Object.SeekSet;

.. code-block:: modula2

    SeekCur* = Object.SeekCur;

.. code-block:: modula2

    SeekEnd* = Object.SeekEnd;

.. code-block:: modula2

    StreamOK*                   = Object.StreamOK;

.. code-block:: modula2

    StreamNotImplementedError*  = Object.StreamNotImplementedError;

.. code-block:: modula2

    StreamNotOpenError*         = Object.StreamNotOpenError;

.. code-block:: modula2

    StreamReadError*            = Object.StreamReadError;

.. code-block:: modula2

    StreamWriteError*           = Object.StreamWriteError;

Types
=====

.. code-block:: modula2

    StreamDesc* = Object.StreamDesc;

.. code-block:: modula2

    StreamFile* = POINTER TO StreamFileDesc;

.. code-block:: modula2

    StreamFileDesc* = RECORD (StreamDesc)
            fh : xlibOS.X2C_OSFHANDLE;
            mode : SET;
            opened : BOOLEAN;
        END;

.. code-block:: modula2

    StreamStdIn* = POINTER TO StreamStdInDesc;

.. code-block:: modula2

    StreamStdInDesc* = RECORD (StreamDesc)
            fh : xlibOS.X2C_OSFHANDLE;
            opened : BOOLEAN;
        END;

.. code-block:: modula2

    StreamStdOut* = POINTER TO StreamStdOutDesc;

.. code-block:: modula2

    StreamStdOutDesc* = RECORD (StreamDesc)
            fh : xlibOS.X2C_OSFHANDLE;
            opened : BOOLEAN;
        END;

.. code-block:: modula2

    StreamStdErr* = POINTER TO StreamStdErrDesc;

.. code-block:: modula2

    StreamStdErrDesc* = RECORD (StreamDesc)
            fh : xlibOS.X2C_OSFHANDLE;
            opened : BOOLEAN;
        END;

Procedures
==========

.. _OSStream.StreamFile.Open:

StreamFile.Open
---------------


Open a OS file with given mode (defaults to  `ModeRead` + `ModeRaw`).
Return `TRUE` on success.


.. code-block:: modula2

    PROCEDURE (s : StreamFile) Open*(filename- : ARRAY OF CHAR; mode := ModeRead + ModeRaw: SET): BOOLEAN;

.. _OSStream.StreamFile.Format:

StreamFile.Format
-----------------


Writes formatted string according to fmt definition and arguments.
Reference :ref:`Format` module for further details.
Sets error to `StreamWriteError` on failure.


.. code-block:: modula2

    PROCEDURE (s : StreamFile) Format*(fmt- : ARRAY OF CHAR; SEQ seq: SYSTEM.BYTE);

.. _OSStream.StreamFile.FormatInteger:

StreamFile.FormatInteger
------------------------


Writes formatted string from `LONGLONGINT` value.
This is a separate procedure for handling `64bit` values
due to a limitation in the `XDS` compiler. 
Reference :ref:`Format` module for further details.
Sets error to `StreamWriteError` on failure.


.. code-block:: modula2

    PROCEDURE (s : StreamFile) FormatInteger*(value : LONGLONGINT; width := 0 : LONGINT; flags := {} : SET);

.. _OSStream.StreamFile.FormatCardinal:

StreamFile.FormatCardinal
-------------------------


Writes formatted string from `CARD64` value.
This is a separate procedure for handling `64bit` values
due to a limitation in the `XDS` compiler. 
Reference :ref:`Format` module for further details.
Sets error to `StreamWriteError` on failure.


.. code-block:: modula2

    PROCEDURE (s : StreamFile) FormatCardinal*(value : SYSTEM.CARD64; base := 10 : INTEGER; width := 0 : LONGINT; flags := {} : SET);

.. _OSStream.StreamFile.ReadBytes:

StreamFile.ReadBytes
--------------------

 Read bytes into buffer with optional start and length. 

.. code-block:: modula2

    PROCEDURE (s : StreamFile) ReadBytes*(VAR buffer : ARRAY OF BYTE; start := 0 : LONGINT; length := - 1 : LONGINT): LONGINT;

.. _OSStream.StreamFile.WriteBytes:

StreamFile.WriteBytes
---------------------

 Write bytes from buffer with optional start and length. 

.. code-block:: modula2

    PROCEDURE (s : StreamFile) WriteBytes*(buffer- : ARRAY OF BYTE; start := 0 : LONGINT; length := - 1 : LONGINT): LONGINT;

.. _OSStream.StreamFile.Seek:

StreamFile.Seek
---------------


Offsets or set the current location depending on the
mode argument:

 * `SeekSet` : sets position relative to start of stream.
 * `SeekCur` : sets position relative to current position of stream.
 * `SeekEnd` : sets position relative to end position of stream (only negative offset values makes sense).

Return new position or -1 in case of failure.


.. code-block:: modula2

    PROCEDURE (s : StreamFile) Seek*(offset : LONGINT; mode := SeekSet : INTEGER): LONGINT;

.. _OSStream.StreamFile.Tell:

StreamFile.Tell
---------------

 Return current position or -1 on failure. 

.. code-block:: modula2

    PROCEDURE (s : StreamFile) Tell*(): LONGINT;

.. _OSStream.StreamFile.Truncate:

StreamFile.Truncate
-------------------


Truncates or extends stream to new size.
Return new size or -1 in case of failure.


.. code-block:: modula2

    PROCEDURE (s : StreamFile) Truncate*(size : LONGINT): LONGINT;

.. _OSStream.StreamFile.Flush:

StreamFile.Flush
----------------

 Flush buffers 

.. code-block:: modula2

    PROCEDURE (s : StreamFile) Flush*();

.. _OSStream.StreamFile.Close:

StreamFile.Close
----------------

 Close Stream 

.. code-block:: modula2

    PROCEDURE (s : StreamFile) Close*();

.. _OSStream.StreamFile.Closed:

StreamFile.Closed
-----------------

 Return `TRUE` if Stream is closed 

.. code-block:: modula2

    PROCEDURE (s : StreamFile) Closed*(): BOOLEAN;

.. _OSStream.StreamFile.Readable:

StreamFile.Readable
-------------------

 Return `TRUE` if Stream is readable 

.. code-block:: modula2

    PROCEDURE (s : StreamFile) Readable*(): BOOLEAN;

.. _OSStream.StreamFile.Writeable:

StreamFile.Writeable
--------------------

 Return `TRUE` if Stream is writeable 

.. code-block:: modula2

    PROCEDURE (s : StreamFile) Writeable*(): BOOLEAN;

.. _OSStream.StreamFile.Seekable:

StreamFile.Seekable
-------------------

 Return `TRUE` if Stream is seekable 

.. code-block:: modula2

    PROCEDURE (s : StreamFile) Seekable*(): BOOLEAN;

.. _OSStream.StreamStdIn.ReadBytes:

StreamStdIn.ReadBytes
---------------------

 Read bytes into buffer with optional start and length. 

.. code-block:: modula2

    PROCEDURE (s : StreamStdIn) ReadBytes*(VAR buffer : ARRAY OF BYTE; start := 0 : LONGINT; length := - 1 : LONGINT): LONGINT;

.. _OSStream.StreamStdIn.ReadChar:

StreamStdIn.ReadChar
--------------------

 Read `CHAR` value. Return `TRUE` if success. 

.. code-block:: modula2

    PROCEDURE (s : StreamStdIn) ReadChar*(VAR value : CHAR): BOOLEAN;

.. _OSStream.StreamStdIn.Readable:

StreamStdIn.Readable
--------------------

 Return `TRUE` if Stream is readable 

.. code-block:: modula2

    PROCEDURE (s : StreamStdIn) Readable*(): BOOLEAN;

.. _OSStream.StreamStdIn.IsTTY:

StreamStdIn.IsTTY
-----------------

 Return `TRUE` if Stream is a TTY 

.. code-block:: modula2

    PROCEDURE (s : StreamStdIn) IsTTY*(): BOOLEAN;

.. _OSStream.StreamStdOut.Format:

StreamStdOut.Format
-------------------


Writes formatted string according to fmt definition and arguments.
Reference :ref:`Format` module for further details.
Sets error to `StreamWriteError` on failure.


.. code-block:: modula2

    PROCEDURE (s : StreamStdOut) Format*(fmt- : ARRAY OF CHAR; SEQ seq: SYSTEM.BYTE);

.. _OSStream.StreamStdOut.FormatInteger:

StreamStdOut.FormatInteger
--------------------------


Writes formatted string from `LONGLONGINT` value.
This is a separate procedure for handling `64bit` values
due to a limitation in the `XDS` compiler. 
Reference :ref:`Format` module for further details.
Sets error to `StreamWriteError` on failure.


.. code-block:: modula2

    PROCEDURE (s : StreamStdOut) FormatInteger*(value : LONGLONGINT; width := 0 : LONGINT; flags := {} : SET);

.. _OSStream.StreamStdOut.FormatCardinal:

StreamStdOut.FormatCardinal
---------------------------


Writes formatted string from `CARD64` value.
This is a separate procedure for handling `64bit` values
due to a limitation in the `XDS` compiler. 
Reference :ref:`Format` module for further details.
Sets error to `StreamWriteError` on failure.


.. code-block:: modula2

    PROCEDURE (s : StreamStdOut) FormatCardinal*(value : SYSTEM.CARD64; base := 10 : INTEGER; width := 0 : LONGINT; flags := {} : SET);

.. _OSStream.StreamStdOut.WriteBytes:

StreamStdOut.WriteBytes
-----------------------

 Write bytes from buffer with optional start and length. 

.. code-block:: modula2

    PROCEDURE (s : StreamStdOut) WriteBytes*(buffer- : ARRAY OF BYTE; start := 0 : LONGINT; length := - 1 : LONGINT): LONGINT;

.. _OSStream.StreamStdOut.Writeable:

StreamStdOut.Writeable
----------------------

 Return `TRUE` if Stream is writeable 

.. code-block:: modula2

    PROCEDURE (s : StreamStdOut) Writeable*(): BOOLEAN;

.. _OSStream.StreamStdOut.IsTTY:

StreamStdOut.IsTTY
------------------

 Return `TRUE` if Stream is a TTY 

.. code-block:: modula2

    PROCEDURE (s : StreamStdOut) IsTTY*(): BOOLEAN;

.. _OSStream.StreamStdErr.Format:

StreamStdErr.Format
-------------------


Writes formatted string according to fmt definition and arguments.
Reference :ref:`Format` module for further details.
Sets error to `StreamWriteError` on failure.


.. code-block:: modula2

    PROCEDURE (s : StreamStdErr) Format*(fmt- : ARRAY OF CHAR; SEQ seq: SYSTEM.BYTE);

.. _OSStream.StreamStdErr.FormatInteger:

StreamStdErr.FormatInteger
--------------------------


Writes formatted string from `LONGLONGINT` value.
This is a separate procedure for handling `64bit` values
due to a limitation in the `XDS` compiler. 
Reference :ref:`Format` module for further details.
Sets error to `StreamWriteError` on failure.


.. code-block:: modula2

    PROCEDURE (s : StreamStdErr) FormatInteger*(value : LONGLONGINT; width := 0 : LONGINT; flags := {} : SET);

.. _OSStream.StreamStdErr.FormatCardinal:

StreamStdErr.FormatCardinal
---------------------------


Writes formatted string from `CARD64` value.
This is a separate procedure for handling `64bit` values
due to a limitation in the `XDS` compiler. 
Reference :ref:`Format` module for further details.
Sets error to `StreamWriteError` on failure.


.. code-block:: modula2

    PROCEDURE (s : StreamStdErr) FormatCardinal*(value : SYSTEM.CARD64; base := 10 : INTEGER; width := 0 : LONGINT; flags := {} : SET);

.. _OSStream.StreamStdErr.WriteBytes:

StreamStdErr.WriteBytes
-----------------------

 Write bytes from buffer with optional start and length. 

.. code-block:: modula2

    PROCEDURE (s : StreamStdErr) WriteBytes*(buffer- : ARRAY OF BYTE; start := 0 : LONGINT; length := - 1 : LONGINT): LONGINT;

.. _OSStream.StreamStdErr.Writeable:

StreamStdErr.Writeable
----------------------

 Return `TRUE` if Stream is writeable 

.. code-block:: modula2

    PROCEDURE (s : StreamStdErr) Writeable*(): BOOLEAN;

.. _OSStream.StreamStdErr.IsTTY:

StreamStdErr.IsTTY
------------------

 Return `TRUE` if Stream is a TTY 

.. code-block:: modula2

    PROCEDURE (s : StreamStdErr) IsTTY*(): BOOLEAN;

