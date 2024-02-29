.. index::
    single: Log

.. _Log:

***
Log
***


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


Const
=====

.. code-block:: modula2

    DEBUG*  = Const.DEBUG;

.. code-block:: modula2

    INFO*   = Const.INFO;

.. code-block:: modula2

    WARN*   = Const.WARN;

.. code-block:: modula2

    ERROR*  = Const.ERROR;

.. code-block:: modula2

    FATAL*  = Const.FATAL;

Vars
====

.. code-block:: modula2

    fh : ADTStream.MemoryStream;

.. code-block:: modula2

    logstreams : ARRAY LOGSIZE OF LogStream;

.. code-block:: modula2

    logs : SHORTINT;

Procedures
==========

.. _Log.Debug:

Debug
-----


`DEBUG` level logging.

Reference to :ref:`Format` for formatting options.


.. code-block:: modula2

    PROCEDURE Debug*(fmt- : ARRAY OF CHAR; SEQ seq: SYSTEM.BYTE);

.. _Log.Info:

Info
----


`INFO` level logging.

Reference to :ref:`Format` for formatting options.


.. code-block:: modula2

    PROCEDURE Info*(fmt- : ARRAY OF CHAR; SEQ seq: SYSTEM.BYTE);

.. _Log.Warn:

Warn
----


`WARN` level logging.

Reference to :ref:`Format` for formatting options.


.. code-block:: modula2

    PROCEDURE Warn*(fmt- : ARRAY OF CHAR; SEQ seq: SYSTEM.BYTE);

.. _Log.Error:

Error
-----


`ERROR` level logging.

Reference to :ref:`Format` for formatting options.


.. code-block:: modula2

    PROCEDURE Error*(fmt- : ARRAY OF CHAR; SEQ seq: SYSTEM.BYTE);

.. _Log.Fatal:

Fatal
-----


`FATAL` level logging.

Reference to :ref:`Format` for formatting options.


.. code-block:: modula2

    PROCEDURE Fatal*(fmt- : ARRAY OF CHAR; SEQ seq: SYSTEM.BYTE);

.. _Log.AddStream:

AddStream
---------


Add a stream object to the list of stream to log to.
Up to 16 streams can be added. The logging will be
done for the defined level (default to `ERROR`) and
higher levels.


.. code-block:: modula2

    PROCEDURE AddStream*(stream : Object.Stream; level := ERROR : SHORTINT) : BOOLEAN;

