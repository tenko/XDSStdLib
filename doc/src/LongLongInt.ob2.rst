.. index::
    single: LongLongInt

.. _LongLongInt:

***********
LongLongInt
***********

 Module with operation on `LONGLONGINT` (64bit) 

Procedures
==========

.. _LongLongInt.Max:

Max
---

 Return largest of x & y 

.. code-block:: modula2

    PROCEDURE Max* (x, y : LONGLONGINT) : LONGLONGINT;

.. _LongLongInt.Min:

Min
---

 Return smallest of x & y 

.. code-block:: modula2

    PROCEDURE Min* (x, y : LONGLONGINT) : LONGLONGINT;

.. _LongLongInt.Random:

Random
------

 Next psuedo random number between min and max 

.. code-block:: modula2

    PROCEDURE Random* (min := MIN(LONGLONGINT), max := MAX(LONGLONGINT) : LONGLONGINT): LONGLONGINT;

.. _LongLongInt.FromString:

FromString
----------


Convert string `str` to `LONGLONGINT` and with optional `start` and `length` into `str`.

Return `TRUE` if success.


.. code-block:: modula2

    PROCEDURE FromString* (VAR result : LONGLONGINT; str- : ARRAY OF CHAR; start := 0 : LONGINT ; length := -1 : LONGINT): BOOLEAN;

