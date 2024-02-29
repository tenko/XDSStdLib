.. index::
    single: String

.. _String:

******
String
******


Dynamic `STRING` type.
Strings are always `NUL` terminated and possible
resized to accomodate content.

For further operations on `STRING` type check :ref:`ArrayOfChar`.


Types
=====

.. code-block:: modula2

    STRING* = Type.STRING;

.. code-block:: modula2

    Writer* = POINTER TO WriterDesc;

.. code-block:: modula2

    WriterDesc* = RECORD (Object.StreamDesc)
            str* : STRING;
            pos* : LONGINT;
        END;

Procedures
==========

.. _String.Reserve:

Reserve
-------

.. code-block:: modula2

    PROCEDURE Reserve* (VAR dst :STRING; capacity : LONGINT; Copy := TRUE : BOOLEAN);

.. _String.Assign:

Assign
------

 Assign `src` to `dst`. 

.. code-block:: modula2

    PROCEDURE Assign* (VAR dst :STRING; src- : ARRAY OF CHAR);

.. _String.AppendChar:

AppendChar
----------

 Append `ch` to `dst`. 

.. code-block:: modula2

    PROCEDURE AppendChar* (VAR dst : STRING; ch : CHAR);

.. _String.Append:

Append
------

 Append `src` to `dst`. 

.. code-block:: modula2

    PROCEDURE Append* (VAR dst : STRING; src- : ARRAY OF CHAR);

.. _String.Extract:

Extract
-------

 Extract substring from `src` starting at `start` and `count` length. 

.. code-block:: modula2

    PROCEDURE Extract* (VAR dst : STRING; src- : ARRAY OF CHAR; start, count: LONGINT);

.. _String.Insert:

Insert
------

 Insert `src` into `dst` at `start` 

.. code-block:: modula2

    PROCEDURE Insert* (VAR dst : STRING; src : ARRAY OF CHAR; start: LONGINT);

.. _String.Replace:

Replace
-------

 Replace `old` string with `new` string starting at index `start` (default to 0) 

.. code-block:: modula2

    PROCEDURE Replace* (VAR dst: STRING; old-, new-: ARRAY OF CHAR; start := 0 : LONGINT);

.. _String.Writer.WriteChar:

Writer.WriteChar
----------------

 WriteChar method for Writer 

.. code-block:: modula2

    PROCEDURE (s : Writer) WriteChar*(ch : CHAR);

.. _String.Writer.WriteString:

Writer.WriteString
------------------

 WriteString method for Writer 

.. code-block:: modula2

    PROCEDURE (s : Writer) WriteString*(value- : ARRAY OF CHAR);

.. _String.Writer.Format:

Writer.Format
-------------

 Format method for Writer 

.. code-block:: modula2

    PROCEDURE (s : Writer) Format*(fmt- : ARRAY OF CHAR; SEQ seq: SYSTEM.BYTE);

.. _String.Format:

Format
------


Append formatted string to end of `dst` according to `fmt` definition and arguments.

Reference :ref:`Format` module for further details.


.. code-block:: modula2

    PROCEDURE Format*(VAR dst: STRING; fmt- : ARRAY OF CHAR; SEQ seq: SYSTEM.BYTE);

.. _String.FormatDateTime:

FormatDateTime
--------------


Format `DateTime` according to `fmt` specification and append to `dst`.

Reference :ref:`Format` module for further details.


.. code-block:: modula2

    PROCEDURE FormatDateTime*(VAR dst: STRING; datetime : DateTime.DATETIME; fmt- : ARRAY OF CHAR);

