.. index::
    single: LongWord

.. _LongWord:

********
LongWord
********

 Module with operations on `LONGWORD` (double machine word 64bit) for low-level routines 

Procedures
==========

.. _LongWord.LSR:

LSR
---

.. code-block:: modula2

    PROCEDURE LSR* (x : LONGWORD; n : INTEGER): LONGWORD;

.. _LongWord.Combine:

Combine
-------

 Work around 32bit limit of hex constants 

.. code-block:: modula2

    PROCEDURE Combine*(high, low : WORD): LONGWORD;

.. _LongWord.Split:

Split
-----

 Work around 32bit limit of hex constants 

.. code-block:: modula2

    PROCEDURE Split*(x : LONGWORD; VAR high, low : WORD);

.. _LongWord.Cast:

Cast
----

 Bit cast src to dst 

.. code-block:: modula2

    PROCEDURE Cast*(VAR dst : ARRAY OF BYTE; src- : ARRAY OF BYTE);

.. _LongWord.CastConst:

CastConst
---------

 Bit cast src value to dst 

.. code-block:: modula2

    PROCEDURE CastConst*(VAR dst : ARRAY OF BYTE; src : LONGWORD);

.. _LongWord.PopCnt:

PopCnt
------

 1 Bit count operation 

.. code-block:: modula2

    PROCEDURE PopCnt*(x : LONGWORD): WORD;

.. _LongWord.LZCnt:

LZCnt
-----

 Leading 0 bit count operation 

.. code-block:: modula2

    PROCEDURE LZCnt*(x : LONGWORD): WORD;

.. _LongWord.Random:

Random
------

 Next psuedo random number : 0 -> range or 2^64 (XorShift) 

.. code-block:: modula2

    PROCEDURE Random* (range := 0 : LONGWORD): LONGWORD;

.. _LongWord.FromString:

FromString
----------


Convert string `str` to `LONGWORD` with optional `base` (10 by default) and
optional `start` and `length` into `str`.

Return `TRUE` if success.


.. code-block:: modula2

    PROCEDURE FromString* (VAR result : LONGWORD; str- : ARRAY OF CHAR; base := 10 : INTEGER; start := 0 : LONGINT ; length := -1 : LONGINT): BOOLEAN;

