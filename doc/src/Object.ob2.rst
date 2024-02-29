.. index::
    single: Object

.. _Object:

******
Object
******


Module with library wide abstract interface types.


Const
=====

.. code-block:: modula2

    SeekSet*    = Const.SeekSet;

.. code-block:: modula2

    SeekCur*    = Const.SeekCur;

.. code-block:: modula2

    SeekEnd*    = Const.SeekEnd;

.. code-block:: modula2

    StreamOK*                   = Const.StreamOK;

.. code-block:: modula2

    StreamNotImplementedError*  = Const.StreamNotImplementedError;

.. code-block:: modula2

    StreamNotOpenError*         = Const.StreamNotOpenError;

.. code-block:: modula2

    StreamReadError*            = Const.StreamReadError;

.. code-block:: modula2

    StreamWriteError*           = Const.StreamWriteError;

Types
=====

.. code-block:: modula2

    Stream* = POINTER TO StreamDesc;

.. code-block:: modula2

    StreamDesc* = RECORD
            error* : LONGINT;
        END;

Procedures
==========

.. _Object.Stream.HasError:

Stream.HasError
---------------

.. code-block:: modula2

    PROCEDURE (s : Stream) HasError*(): BOOLEAN;

.. _Object.Stream.LastError:

Stream.LastError
----------------

 Return last error code or `StreamOK` if no error is set. 

.. code-block:: modula2

    PROCEDURE (s : Stream) LastError*(): LONGINT;

.. _Object.Stream.ClearError:

Stream.ClearError
-----------------

 Clear error status to `StreamOK`. 

.. code-block:: modula2

    PROCEDURE (s : Stream) ClearError*();

.. _Object.Stream.ReadBytes:

Stream.ReadBytes
----------------

 Read bytes into buffer with optional start and length. 

.. code-block:: modula2

    PROCEDURE (s : Stream) ReadBytes*(VAR buffer : ARRAY OF SYSTEM.BYTE; start := 0 : LONGINT; length := - 1 : LONGINT): LONGINT;

.. _Object.Stream.ReadByte:

Stream.ReadByte
---------------

 Read `BYTE` value. Return `TRUE` if success. 

.. code-block:: modula2

    PROCEDURE (s : Stream) ReadByte*(VAR value : SYSTEM.BYTE): BOOLEAN;

.. _Object.Stream.ReadChar:

Stream.ReadChar
---------------

 Read `CHAR` value. Return `TRUE` if success. 

.. code-block:: modula2

    PROCEDURE (s : Stream) ReadChar*(VAR value : CHAR): BOOLEAN;

.. _Object.Stream.ReadInteger:

Stream.ReadInteger
------------------

 Read `INTEGER` value. Return `TRUE` if success. 

.. code-block:: modula2

    PROCEDURE (s : Stream) ReadInteger*(VAR value : INTEGER): BOOLEAN;

.. _Object.Stream.ReadLongInt:

Stream.ReadLongInt
------------------

 Read `LONGINT` value. Return `TRUE` if success. 

.. code-block:: modula2

    PROCEDURE (s : Stream) ReadLongInt*(VAR value : LONGINT): BOOLEAN;

.. _Object.Stream.ReadReal:

Stream.ReadReal
---------------

 Read `REAL` value. Return `TRUE` if success. 

.. code-block:: modula2

    PROCEDURE (s : Stream) ReadReal*(VAR value : REAL): BOOLEAN;

.. _Object.Stream.ReadLongReal:

Stream.ReadLongReal
-------------------

 Read `LONGREAL` value. Return `TRUE` if success. 

.. code-block:: modula2

    PROCEDURE (s : Stream) ReadLongReal*(VAR value : LONGREAL): BOOLEAN;

.. _Object.Stream.ReadLine:

Stream.ReadLine
---------------


Read line to `EOL` mark or `EOF` mark.
`STRING` possible reallocated to contain whole line if needed.
Return `TRUE` if success.


.. code-block:: modula2

    PROCEDURE (s : Stream) ReadLine*(VAR value : Type.STRING): BOOLEAN;

.. _Object.Stream.WriteBytes:

Stream.WriteBytes
-----------------

 Write bytes from buffer with optional start and length. 

.. code-block:: modula2

    PROCEDURE (s : Stream) WriteBytes*(buffer- : ARRAY OF SYSTEM.BYTE; start := 0 : LONGINT; length := - 1 : LONGINT): LONGINT;

.. _Object.Stream.WriteByte:

Stream.WriteByte
----------------

 Write `BYTE` value. Sets error to `StreamWriteError` on failure. 

.. code-block:: modula2

    PROCEDURE (s : Stream) WriteByte*(value : SYSTEM.BYTE);

.. _Object.Stream.WriteChar:

Stream.WriteChar
----------------

 Write `CHAR` value. Sets error to `StreamWriteError` on failure. 

.. code-block:: modula2

    PROCEDURE (s : Stream) WriteChar*(value : CHAR);

.. _Object.Stream.WriteInteger:

Stream.WriteInteger
-------------------

 Write `INTEGER` value. Sets error to `StreamWriteError` on failure. 

.. code-block:: modula2

    PROCEDURE (s : Stream) WriteInteger*(value : INTEGER);

.. _Object.Stream.WriteLongInt:

Stream.WriteLongInt
-------------------

 Write `LONGINT` value. Sets error to `StreamWriteError` on failure. 

.. code-block:: modula2

    PROCEDURE (s : Stream) WriteLongInt*(value : LONGINT);

.. _Object.Stream.WriteReal:

Stream.WriteReal
----------------

 Write `REAL` value. Sets error to `StreamWriteError` on failure. 

.. code-block:: modula2

    PROCEDURE (s : Stream) WriteReal*(value : REAL);

.. _Object.Stream.WriteLongReal:

Stream.WriteLongReal
--------------------

 Write `LONGREAL` value. Sets error to `StreamWriteError` on failure. 

.. code-block:: modula2

    PROCEDURE (s : Stream) WriteLongReal*(value : LONGREAL);

.. _Object.Stream.WriteString:

Stream.WriteString
------------------


Write `ARRAY OF CHAR` value to NULL byte or length of array.
Sets error to `StreamWriteError` on failure.


.. code-block:: modula2

    PROCEDURE (s : Stream) WriteString*(value- : ARRAY OF CHAR);

.. _Object.Stream.WriteNL:

Stream.WriteNL
--------------

 Write platforms newline value to stream. Sets error to `StreamWriteError` on failure. 

.. code-block:: modula2

    PROCEDURE (s : Stream) WriteNL*();

.. _Object.Stream.WriteStream:

Stream.WriteStream
------------------

 Write `Stream` `src` to stream. Sets error to `StreamWriteError` on failure. 

.. code-block:: modula2

    PROCEDURE (s : Stream) WriteStream*(src : Stream);

.. _Object.Stream.Format:

Stream.Format
-------------


Writes formatted string according to fmt definition and arguments.
Reference :ref:`Format` module for further details.
Sets error to `StreamWriteError` on failure.


.. code-block:: modula2

    PROCEDURE (s : Stream) Format*(fmt- : ARRAY OF CHAR; SEQ seq: SYSTEM.BYTE);

.. _Object.Stream.FormatInteger:

Stream.FormatInteger
--------------------


Writes formatted string from `LONGLONGINT` value.
This is a separate procedure for handling `64bit` values
due to a limitation in the `XDS` compiler. 
Reference :ref:`Format` module for further details.
Sets error to `StreamWriteError` on failure.


.. code-block:: modula2

    PROCEDURE (s : Stream) FormatInteger*(value : LONGLONGINT; width := 0 : LONGINT; flags := {} : SET);

.. _Object.Stream.FormatCardinal:

Stream.FormatCardinal
---------------------


Writes formatted string from `CARD64` value.
This is a separate procedure for handling `64bit` values
due to a limitation in the `XDS` compiler. 
Reference :ref:`Format` module for further details.
Sets error to `StreamWriteError` on failure.


.. code-block:: modula2

    PROCEDURE (s : Stream) FormatCardinal*(value : SYSTEM.CARD64; base := 10 : INTEGER; width := 0 : LONGINT; flags := {} : SET);

.. _Object.Stream.Seek:

Stream.Seek
-----------


Offsets or set the current location depending on the
mode argument:

 * `SeekSet` : sets position relative to start of stream.
 * `SeekCur` : sets position relative to current position of stream.
 * `SeekEnd` : sets position relative to end position of stream (only negative offset values makes sense).

Return new position or -1 in case of failure.


.. code-block:: modula2

    PROCEDURE (s : Stream) Seek*(offset : LONGINT; mode := SeekSet : INTEGER): LONGINT;

.. _Object.Stream.Tell:

Stream.Tell
-----------

 Return current position or -1 on failure. 

.. code-block:: modula2

    PROCEDURE (s : Stream) Tell*(): LONGINT;

.. _Object.Stream.Truncate:

Stream.Truncate
---------------


Truncates or extends stream to new size.
Return new size or -1 in case of failure.


.. code-block:: modula2

    PROCEDURE (s : Stream) Truncate*(size : LONGINT): LONGINT;

.. _Object.Stream.Flush:

Stream.Flush
------------

 Flush buffers 

.. code-block:: modula2

    PROCEDURE (s : Stream) Flush*();

.. _Object.Stream.Close:

Stream.Close
------------

 Close Stream 

.. code-block:: modula2

    PROCEDURE (s : Stream) Close*();

.. _Object.Stream.Closed:

Stream.Closed
-------------

 Return `TRUE` if Stream is closed 

.. code-block:: modula2

    PROCEDURE (s : Stream) Closed*(): BOOLEAN;

.. _Object.Stream.IsTTY:

Stream.IsTTY
------------

 Return `TRUE` if Stream is a TTY 

.. code-block:: modula2

    PROCEDURE (s : Stream) IsTTY*(): BOOLEAN;

.. _Object.Stream.Readable:

Stream.Readable
---------------

 Return `TRUE` if Stream is readable 

.. code-block:: modula2

    PROCEDURE (s : Stream) Readable*(): BOOLEAN;

.. _Object.Stream.Writeable:

Stream.Writeable
----------------

 Return `TRUE` if Stream is writeable 

.. code-block:: modula2

    PROCEDURE (s : Stream) Writeable*(): BOOLEAN;

.. _Object.Stream.Seekable:

Stream.Seekable
---------------

 Return `TRUE` if Stream is seekable 

.. code-block:: modula2

    PROCEDURE (s : Stream) Seekable*(): BOOLEAN;

