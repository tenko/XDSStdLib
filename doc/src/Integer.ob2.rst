.. index::
    single: Integer

.. _Integer:

*******
Integer
*******

 Module with operation on `INTEGER` 

Procedures
==========

.. _Integer.Max:

Max
---

 Return largest of x & y 

.. code-block:: modula2

    PROCEDURE Max* (x, y : INTEGER) : INTEGER;

.. _Integer.Min:

Min
---

 Return smallest of x & y 

.. code-block:: modula2

    PROCEDURE Min* (x, y : INTEGER) : INTEGER;

.. _Integer.Random:

Random
------

 Next psuedo random number between min and max 

.. code-block:: modula2

    PROCEDURE Random* (min := MIN(INTEGER), max := MAX(INTEGER) : INTEGER): INTEGER;

.. _Integer.FromString:

FromString
----------


Convert string `str` to `INTEGER` and with optional `start` and `length` into `str`.

Return `TRUE` if success.


.. code-block:: modula2

    PROCEDURE FromString* (VAR result : INTEGER; str- : ARRAY OF CHAR; start := 0 : LONGINT ; length := -1 : LONGINT): BOOLEAN;

