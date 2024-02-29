.. index::
    single: ShortInt

.. _ShortInt:

********
ShortInt
********

 Module with operation on `SHORTINT` 

Procedures
==========

.. _ShortInt.Max:

Max
---

 Return largest of x & y 

.. code-block:: modula2

    PROCEDURE Max* (x, y : SHORTINT) : SHORTINT;

.. _ShortInt.Min:

Min
---

 Return smallest of x & y 

.. code-block:: modula2

    PROCEDURE Min* (x, y : SHORTINT) : SHORTINT;

.. _ShortInt.Random:

Random
------

 Next psuedo random number between min and max 

.. code-block:: modula2

    PROCEDURE Random* (min := MIN(SHORTINT), max := MAX(SHORTINT) : SHORTINT): SHORTINT;

.. _ShortInt.FromString:

FromString
----------


Convert string `str` to `SHORTINT` and with optional `start` and `length` into `str`.

Return `TRUE` if success.


.. code-block:: modula2

    PROCEDURE FromString* (VAR result : SHORTINT; str- : ARRAY OF CHAR; start := 0 : LONGINT ; length := -1 : LONGINT): BOOLEAN;

