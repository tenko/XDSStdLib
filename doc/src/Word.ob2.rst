.. index::
    single: Word

.. _Word:

****
Word
****


Module with operations on `WORD` (machine word 32bit) for low-level routines.


Vars
====

.. code-block:: modula2

    randomSeed : WORD;

Procedures
==========

.. _Word.PopCnt:

PopCnt
------

 1 Bit count operation 

.. code-block:: modula2

    PROCEDURE PopCnt*(x : WORD): WORD;

.. _Word.LZCnt:

LZCnt
-----

 Leading 0 bit count operation 

.. code-block:: modula2

    PROCEDURE LZCnt*(x : WORD): WORD;

.. _Word.Swap:

Swap
----

 Swap bytes 

.. code-block:: modula2

    PROCEDURE Swap* (x : WORD) : WORD;

.. _Word.FillByte:

FillByte
--------

 Fill `WORD` with `BYTE` value 

.. code-block:: modula2

    PROCEDURE FillByte* (val : BYTE) : WORD;

.. _Word.Cast:

Cast
----

 Bit cast src to dst 

.. code-block:: modula2

    PROCEDURE Cast*(VAR dst : ARRAY OF BYTE; src- : ARRAY OF BYTE);

.. _Word.CastConst:

CastConst
---------

 Bit cast src value to dst 

.. code-block:: modula2

    PROCEDURE CastConst*(VAR dst : ARRAY OF BYTE; src : WORD);

.. _Word.RandomSeed:

RandomSeed
----------

 Reset random seed 

.. code-block:: modula2

    PROCEDURE RandomSeed* (seed : WORD);

.. _Word.Random:

Random
------

 Next psuedo random number : 0 -> range or 2^32 (XorShift) 

.. code-block:: modula2

    PROCEDURE Random* (range := 0 : WORD): WORD;

.. _Word.Hash:

Hash
----

 Robert Jenkins' 32 bit integer hash function 

.. code-block:: modula2

    PROCEDURE Hash* (value : WORD): WORD;

.. _Word.FromString:

FromString
----------


Convert string `str` to `WORD` with optional `base` (10 by default) and
optional `start` and `length` into `str`.

Return `TRUE` if success.


.. code-block:: modula2

    PROCEDURE FromString* (VAR result : WORD; str- : ARRAY OF CHAR; base := 10 : INTEGER; start := 0 : LONGINT ; length := -1 : LONGINT): BOOLEAN;

