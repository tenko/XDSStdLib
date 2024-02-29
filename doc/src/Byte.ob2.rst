.. index::
    single: Byte

.. _Byte:

****
Byte
****


Module with operation on `BYTE` type for low level routions.
`BYTE` is assignment compatible with, `CHAR`, `SHORTINT`, `SYSTEM.CARD8`


Types
=====

.. code-block:: modula2

    BYTE* = Type.BYTE;

.. code-block:: modula2

    CARD8* = Type.CARD8;

Procedures
==========

.. _Byte.Max:

Max
---

.. code-block:: modula2

    PROCEDURE Max* (x, y : BYTE) : BYTE;

.. _Byte.Min:

Min
---

 Return smallest of x & y 

.. code-block:: modula2

    PROCEDURE Min* (x, y : BYTE) : BYTE;

.. _Byte.FromString:

FromString
----------


Convert string `str` to `BYTE` with optional `base` (10 by default) and
optional `start` and `length` into `str`.

Return `TRUE` if success.


.. code-block:: modula2

    PROCEDURE FromString* (VAR result : BYTE; str- : ARRAY OF CHAR; base := 10 : INTEGER; start := 0 : LONGINT ; length := -1 : LONGINT): BOOLEAN;

