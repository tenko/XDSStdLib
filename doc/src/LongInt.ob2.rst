.. index::
    single: LongInt

.. _LongInt:

*******
LongInt
*******

 Module with operation on `LONGINT` 

Procedures
==========

.. _LongInt.Max:

Max
---

 Return largest of x & y 

.. code-block:: modula2

    PROCEDURE Max* (x, y : LONGINT) : LONGINT;

.. _LongInt.Min:

Min
---

 Return smallest of x & y 

.. code-block:: modula2

    PROCEDURE Min* (x, y : LONGINT) : LONGINT;

.. _LongInt.Exp:

Exp
---

 Integer power function 

.. code-block:: modula2

    PROCEDURE Exp*(exp : LONGINT; base := 2 : LONGINT): LONGINT;

.. _LongInt.Random:

Random
------

 Next psuedo random number between min and max 

.. code-block:: modula2

    PROCEDURE Random* (min := MIN(LONGINT), max := MAX(LONGINT) : LONGINT): LONGINT;

.. _LongInt.FromString:

FromString
----------


Convert string `str` to `LONGINT` and with optional `start` and `length` into `str`.

Return `TRUE` if success.


.. code-block:: modula2

    PROCEDURE FromString* (VAR result : LONGINT; str- : ARRAY OF CHAR; start := 0 : LONGINT ; length := -1 : LONGINT): BOOLEAN;

