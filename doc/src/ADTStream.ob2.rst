.. index::
    single: ADTStream

.. _ADTStream:

*********
ADTStream
*********


Stream classes which implements concrete streams
according to the interface defined in :ref:`Object`.

The following classes are implemented
 * `NullStream` - Swallow any write operation and return 0 on read operations.
 * `MemoryStream` - Allocate dynamic memory as needed for operations.

Some methods are inherited from abstract `Stream` in :ref:`Object`.


Const
=====

.. code-block:: modula2

    INIT_SIZE* = 64;

.. code-block:: modula2

    SeekSet* = Const.SeekSet;

.. code-block:: modula2

    SeekCur* = Const.SeekCur;

.. code-block:: modula2

    SeekEnd* = Const.SeekEnd;

Types
=====

.. code-block:: modula2

    NullStream* = POINTER TO NullStreamDesc;

.. code-block:: modula2

    NullStreamDesc* = RECORD (Object.StreamDesc)END;

.. code-block:: modula2

    MemoryStream* = POINTER TO MemoryStreamDesc;

.. code-block:: modula2

    MemoryStreamDesc* = RECORD (Object.StreamDesc)
            storage : MemoryStorage;
            pos : LONGINT;
            last : LONGINT;
        END;

Procedures
==========

.. _ADTStream.NullStream.ReadBytes:

NullStream.ReadBytes
--------------------

.. code-block:: modula2

    PROCEDURE (s : NullStream) ReadBytes*(VAR buffer : ARRAY OF BYTE; start := 0 : LONGINT; length := - 1 : LONGINT): LONGINT;

.. _ADTStream.NullStream.WriteBytes:

NullStream.WriteBytes
---------------------

 Write bytes from buffer with optional start and length. 

.. code-block:: modula2

    PROCEDURE (s : NullStream) WriteBytes*(buffer- : ARRAY OF BYTE; start := 0 : LONGINT; length := - 1 : LONGINT): LONGINT;

.. _ADTStream.NullStream.Readable:

NullStream.Readable
-------------------

 Return `TRUE` if Stream is readable 

.. code-block:: modula2

    PROCEDURE (s : NullStream) Readable*(): BOOLEAN;

.. _ADTStream.NullStream.Writeable:

NullStream.Writeable
--------------------

 Return `TRUE` if Stream is writeable 

.. code-block:: modula2

    PROCEDURE (s : NullStream) Writeable*(): BOOLEAN;

.. _ADTStream.NullStream.Seekable:

NullStream.Seekable
-------------------

 Return `TRUE` if Stream is seekable 

.. code-block:: modula2

    PROCEDURE (s : NullStream) Seekable*(): BOOLEAN;

.. _ADTStream.MemoryStream.Open:

MemoryStream.Open
-----------------


Open `MemoryStream` with optional size (defaults to `INIT_SIZE`).

Return `TRUE` if success.


.. code-block:: modula2

    PROCEDURE (s : MemoryStream) Open*(size := INIT_SIZE : LONGINT): BOOLEAN;

.. _ADTStream.MemoryStream.ToString:

MemoryStream.ToString
---------------------


Copy Stream content to string.
The string is possible resized and is NUL terminated.


.. code-block:: modula2

    PROCEDURE (s : MemoryStream) ToString*(VAR str : String.STRING);

.. _ADTStream.MemoryStream.ReadBytes:

MemoryStream.ReadBytes
----------------------

 Read bytes into buffer with optional start and length. 

.. code-block:: modula2

    PROCEDURE (s : MemoryStream) ReadBytes*(VAR buffer : ARRAY OF BYTE; start := 0 : LONGINT; length := - 1 : LONGINT): LONGINT;

.. _ADTStream.MemoryStream.Reserve:

MemoryStream.Reserve
--------------------

 Resize storage to accomodate capacity 

.. code-block:: modula2

    PROCEDURE (s : MemoryStream) Reserve*(capacity  : LONGINT);

.. _ADTStream.MemoryStream.Shrink:

MemoryStream.Shrink
-------------------

 Shrink storage if possible 

.. code-block:: modula2

    PROCEDURE (s : MemoryStream) Shrink*();

.. _ADTStream.MemoryStream.WriteBytes:

MemoryStream.WriteBytes
-----------------------

 Write bytes from buffer with optional start and length. 

.. code-block:: modula2

    PROCEDURE (s : MemoryStream) WriteBytes*(buffer- : ARRAY OF BYTE; start := 0 : LONGINT; length := - 1 : LONGINT): LONGINT;

.. _ADTStream.MemoryStream.Format:

MemoryStream.Format
-------------------


Writes formatted string according to fmt definition and arguments.
Reference :ref:`Format` module for further details.
Sets error to `StreamWriteError` on failure.


.. code-block:: modula2

    PROCEDURE (s : MemoryStream) Format*(fmt- : ARRAY OF CHAR; SEQ seq: SYSTEM.BYTE);

.. _ADTStream.MemoryStream.Seek:

MemoryStream.Seek
-----------------


Offsets or set the current location depending on the
mode argument:

 * `SeekSet` : sets position relative to start of stream.
 * `SeekCur` : sets position relative to current position of stream.
 * `SeekEnd` : sets position relative to end position of stream (only negative offset values makes sense).

Return new position or -1 in case of failure.


.. code-block:: modula2

    PROCEDURE (s : MemoryStream) Seek*(offset : LONGINT; mode := SeekSet : INTEGER): LONGINT;

.. _ADTStream.MemoryStream.Tell:

MemoryStream.Tell
-----------------

 Return current position or -1 on failure. 

.. code-block:: modula2

    PROCEDURE (s : MemoryStream) Tell*(): LONGINT;

.. _ADTStream.MemoryStream.Truncate:

MemoryStream.Truncate
---------------------


Truncates or extends stream to new size.
Return new size or -1 in case of failure.


.. code-block:: modula2

    PROCEDURE (s : MemoryStream) Truncate*(size : LONGINT): LONGINT;

.. _ADTStream.MemoryStream.Close:

MemoryStream.Close
------------------

 Close Stream 

.. code-block:: modula2

    PROCEDURE (s : MemoryStream) Close*();

.. _ADTStream.MemoryStream.Closed:

MemoryStream.Closed
-------------------

 Return `TRUE` if Stream is closed 

.. code-block:: modula2

    PROCEDURE (s : MemoryStream) Closed*(): BOOLEAN;

.. _ADTStream.MemoryStream.Readable:

MemoryStream.Readable
---------------------

 Return `TRUE` if Stream is readable 

.. code-block:: modula2

    PROCEDURE (s : MemoryStream) Readable*(): BOOLEAN;

.. _ADTStream.MemoryStream.Writeable:

MemoryStream.Writeable
----------------------

 Return `TRUE` if Stream is writeable 

.. code-block:: modula2

    PROCEDURE (s : MemoryStream) Writeable*(): BOOLEAN;

.. _ADTStream.MemoryStream.Seekable:

MemoryStream.Seekable
---------------------

 Return `TRUE` if Stream is seekable 

.. code-block:: modula2

    PROCEDURE (s : MemoryStream) Seekable*(): BOOLEAN;

