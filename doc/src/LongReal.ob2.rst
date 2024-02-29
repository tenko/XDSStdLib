.. index::
    single: LongReal

.. _LongReal:

********
LongReal
********

 Module with operation on `LONGREAL` type. 

Const
=====

.. code-block:: modula2

    FPZero*     = Const.FPZero;

.. code-block:: modula2

    FPNormal*   = Const.FPNormal;

.. code-block:: modula2

    FPSubnormal*= Const.FPSubnormal;

.. code-block:: modula2

    FPInfinite* = Const.FPInfinite;

.. code-block:: modula2

    FPNaN*      = Const.FPNaN;

.. code-block:: modula2

    PI*   = 3.1415926535897932384626433832795028841972;

.. code-block:: modula2

    E* = 2.7182818284590452353602874713526624977572;

Procedures
==========

.. _LongReal.FPClassify:

FPClassify
----------

 Categorizes floating point value 

.. code-block:: modula2

    PROCEDURE FPClassify*(x : LONGREAL): INTEGER;

.. _LongReal.IsNan:

IsNan
-----

 Return `TRUE` if x is a NaN (not a number), and `FALSE` otherwise. 

.. code-block:: modula2

    PROCEDURE IsNan*(x : LONGREAL): BOOLEAN;

.. _LongReal.IsInf:

IsInf
-----

 Return `TRUE` if x is a positive or negative infinity, and `FALSE` otherwise. 

.. code-block:: modula2

    PROCEDURE IsInf*(x : LONGREAL): BOOLEAN;

.. _LongReal.IsFinite:

IsFinite
--------

 Return `TRUE` if x is neither an infinity nor a NaN, and `FALSE` otherwise.

.. code-block:: modula2

    PROCEDURE IsFinite*(x : LONGREAL): BOOLEAN;

.. _LongReal.IsNormal:

IsNormal
--------

 Return `TRUE` if x is neither an infinity nor a NaN or Zero, and `FALSE` otherwise.

.. code-block:: modula2

    PROCEDURE IsNormal*(x : LONGREAL): BOOLEAN;

.. _LongReal.SignBit:

SignBit
-------

 Return `TRUE` if sign bit is set. 

.. code-block:: modula2

    PROCEDURE SignBit*(x : LONGREAL): BOOLEAN;

.. _LongReal.CopySign:

CopySign
--------

 Return a `LONGREAL` with the magnitude (absolute value) of x but the sign of y. 

.. code-block:: modula2

    PROCEDURE CopySign*(x, y : LONGREAL): LONGREAL;

.. _LongReal.Abs:

Abs
---

 Return absolute value of x. 

.. code-block:: modula2

    PROCEDURE Abs*(x : LONGREAL): LONGREAL;

.. _LongReal.Frexp:

Frexp
-----

 Decomposes given floating point value x into a normalized fraction and an integral power of two. 

.. code-block:: modula2

    PROCEDURE Frexp*(x : LONGREAL; VAR exp : LONGINT): LONGREAL;

.. _LongReal.Scalbn:

Scalbn
------

 Multiplies a floating point value x by RADIX_FLT raised to power n 

.. code-block:: modula2

    PROCEDURE Scalbn*(x : LONGREAL; n : LONGINT): LONGREAL;

.. _LongReal.Ldexp:

Ldexp
-----

 Multiplies a floating point value arg by the number 2 raised to the exp power. 

.. code-block:: modula2

    PROCEDURE Ldexp*(x : LONGREAL; exp : LONGINT): LONGREAL;

.. _LongReal.Max:

Max
---

 Return largest of x & y 

.. code-block:: modula2

    PROCEDURE Max* (x, y : LONGREAL) : LONGREAL;

.. _LongReal.Min:

Min
---

 Return smallest of x & y 

.. code-block:: modula2

    PROCEDURE Min* (x, y : LONGREAL) : LONGREAL;

.. _LongReal.Sin:

Sin
---

 Computes the sine of the angle `LONGREAL` x in radians 

.. code-block:: modula2

    PROCEDURE Sin* (x: LONGREAL) : LONGREAL ;

.. _LongReal.Cos:

Cos
---

 Computes the cosine of the angle `LONGREAL` x in radians 

.. code-block:: modula2

    PROCEDURE Cos* (x: LONGREAL) : LONGREAL ;

.. _LongReal.Tan:

Tan
---

 Computes the tangent of the angle `LONGREAL` x in radians 

.. code-block:: modula2

    PROCEDURE Tan* (x: LONGREAL) : LONGREAL ;

.. _LongReal.ArcSin:

ArcSin
------

 Computes the arc sine of the value `LONGREAL` x 

.. code-block:: modula2

    PROCEDURE ArcSin* (x: LONGREAL) : LONGREAL ;

.. _LongReal.ArcCos:

ArcCos
------

 Computes the arc cosine of the value `LONGREAL` x 

.. code-block:: modula2

    PROCEDURE ArcCos* (x: LONGREAL) : LONGREAL ;

.. _LongReal.ArcTan:

ArcTan
------

 Computes the arc tangent of the value `LONGREAL` x 

.. code-block:: modula2

    PROCEDURE ArcTan* (x: LONGREAL) : LONGREAL ;

.. _LongReal.ArcTan2:

ArcTan2
-------

 Computes the arc tangent of the value `LONGREAL` x/y using the sign to select the right quadrant 

.. code-block:: modula2

    PROCEDURE ArcTan2* (x, y: LONGREAL) : LONGREAL ;

.. _LongReal.Sqrt:

Sqrt
----

 Computes the square root of the `LONGREAL` x 

.. code-block:: modula2

    PROCEDURE Sqrt* (x: LONGREAL) : LONGREAL ;

.. _LongReal.Pow:

Pow
---

 Raises the `LONGREAL` argument x to power y 

.. code-block:: modula2

    PROCEDURE Pow* (x, y: LONGREAL) : LONGREAL ;

.. _LongReal.Exp:

Exp
---

 Computes e raised to the power of x 

.. code-block:: modula2

    PROCEDURE Exp* (x: LONGREAL) : LONGREAL ;

.. _LongReal.Log:

Log
---

 Computes natural (e) logarithm of x 

.. code-block:: modula2

    PROCEDURE Log* (x: LONGREAL) : LONGREAL ;

.. _LongReal.Log10:

Log10
-----

 Computes common (base-10) logarithm of x 

.. code-block:: modula2

    PROCEDURE Log10* (x: LONGREAL) : LONGREAL ;

.. _LongReal.Floor:

Floor
-----

 Computes the largest integer value not greater than x 

.. code-block:: modula2

    PROCEDURE Floor* (x: LONGREAL) : LONGREAL ;

.. _LongReal.Round:

Round
-----

 Computes the nearest integer value to x, rounding halfway cases away from zero 

.. code-block:: modula2

    PROCEDURE Round *(x: LONGREAL) : LONGREAL ;

.. _LongReal.Random:

Random
------

 Next psuedo random number between min and max or 0. -> 1. if both min & max = 0

.. code-block:: modula2

    PROCEDURE Random* (min := 0., max := 0. : LONGREAL): LONGREAL;

.. _LongReal.FromString:

FromString
----------


Convert string `str` to `LONGREAL` in either decimal or hex format and
optional `start` and `length` into `str`.

The benifit of the hex format is that the conversion is always exact.

TODO : Fix overflow/underflow (return INF/-INF) and add rounding to many digits.
       Skip trailing or leading zeros.

Return `TRUE` if success.


.. code-block:: modula2

    PROCEDURE FromString* (VAR result : LONGREAL; str- : ARRAY OF CHAR; base := 10 : INTEGER; start := 0 : LONGINT ; length := -1 : LONGINT): BOOLEAN;

.. _LongReal.WordsToLongReal:

WordsToLongReal
---------------


Convert hi & lo 32bit numbers to `LONGREAL`.

This is neede due to a limitation in the `XDS`
compiler where 64bit hex constants is not available.


.. code-block:: modula2

    PROCEDURE WordsToLongReal*(VAR dst : LONGREAL; hi, lo : Type.WORD);

