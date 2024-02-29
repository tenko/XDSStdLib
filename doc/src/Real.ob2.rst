.. index::
    single: Real

.. _Real:

****
Real
****

 Module with operation on `REAL` type. 

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

.. _Real.FPClassify:

FPClassify
----------

 Categorizes floating point value 

.. code-block:: modula2

    PROCEDURE FPClassify*(x : REAL): INTEGER;

.. _Real.IsNan:

IsNan
-----

 Return `TRUE` if x is a NaN (not a number), and `FALSE` otherwise. 

.. code-block:: modula2

    PROCEDURE IsNan*(x : REAL): BOOLEAN;

.. _Real.IsInf:

IsInf
-----

 Return `TRUE` if x is a positive or negative infinity, and `FALSE` otherwise. 

.. code-block:: modula2

    PROCEDURE IsInf*(x : REAL): BOOLEAN;

.. _Real.IsFinite:

IsFinite
--------

 Return `TRUE` if x is neither an infinity nor a NaN, and `FALSE` otherwise.

.. code-block:: modula2

    PROCEDURE IsFinite*(x : REAL): BOOLEAN;

.. _Real.IsNormal:

IsNormal
--------

 Return `TRUE` if x is neither an infinity nor a NaN or Zero, and `FALSE` otherwise.

.. code-block:: modula2

    PROCEDURE IsNormal*(x : REAL): BOOLEAN;

.. _Real.SignBit:

SignBit
-------

 Return `TRUE` if sign bit is set. 

.. code-block:: modula2

    PROCEDURE SignBit*(x : REAL): BOOLEAN;

.. _Real.CopySign:

CopySign
--------

 Return a `LONGREAL` with the magnitude (absolute value) of x but the sign of y. 

.. code-block:: modula2

    PROCEDURE CopySign*(x, y : REAL): REAL;

.. _Real.Abs:

Abs
---

 Return absolute value of x. 

.. code-block:: modula2

    PROCEDURE Abs*(x : REAL): REAL;

.. _Real.Frexp:

Frexp
-----

 Decomposes given floating point value x into a normalized fraction and an integral power of two. 

.. code-block:: modula2

    PROCEDURE Frexp*(x : REAL; VAR exp : LONGINT): REAL;

.. _Real.Scalbn:

Scalbn
------

 Multiplies a floating point value x by RADIX_FLT raised to power n 

.. code-block:: modula2

    PROCEDURE Scalbn*(x : REAL; n : LONGINT): REAL;

.. _Real.Ldexp:

Ldexp
-----

 Multiplies a floating point value arg by the number 2 raised to the exp power. 

.. code-block:: modula2

    PROCEDURE Ldexp*(x : REAL; exp : LONGINT): REAL;

.. _Real.Max:

Max
---

 Return largest of x & y 

.. code-block:: modula2

    PROCEDURE Max* (x, y : REAL) : REAL;

.. _Real.Min:

Min
---

 Return smallest of x & y 

.. code-block:: modula2

    PROCEDURE Min* (x, y : REAL) : REAL;

.. _Real.Sin:

Sin
---

 Computes the sine of the angle `REAL` x in radians 

.. code-block:: modula2

    PROCEDURE Sin* (x: REAL) : REAL ;

.. _Real.Cos:

Cos
---

 Computes the cosine of the angle `REAL` x in radians 

.. code-block:: modula2

    PROCEDURE Cos* (x: REAL) : REAL ;

.. _Real.Tan:

Tan
---

 Computes the tangent of the angle `REAL` x in radians 

.. code-block:: modula2

    PROCEDURE Tan* (x: REAL) : REAL ;

.. _Real.ArcSin:

ArcSin
------

 Computes the arc sine of the value `REAL` x 

.. code-block:: modula2

    PROCEDURE ArcSin* (x: REAL) : REAL ;

.. _Real.ArcCos:

ArcCos
------

 Computes the arc cosine of the value `REAL` x 

.. code-block:: modula2

    PROCEDURE ArcCos* (x: REAL) : REAL ;

.. _Real.ArcTan:

ArcTan
------

 Computes the arc tangent of the value `REAL` x 

.. code-block:: modula2

    PROCEDURE ArcTan* (x: REAL) : REAL ;

.. _Real.ArcTan2:

ArcTan2
-------

 Computes the arc tangent of the value `REAL` x/y using the sign to select the right quadrant 

.. code-block:: modula2

    PROCEDURE ArcTan2* (x, y: REAL) : REAL ;

.. _Real.Sqrt:

Sqrt
----

 Computes the square root of the `REAL` x 

.. code-block:: modula2

    PROCEDURE Sqrt* (x: REAL) : REAL ;

.. _Real.Pow:

Pow
---

 Raises the Real argument x to power y 

.. code-block:: modula2

    PROCEDURE Pow* (x, y: REAL) : REAL ;

.. _Real.Exp:

Exp
---

 Computes e raised to the power of x 

.. code-block:: modula2

    PROCEDURE Exp* (x: REAL) : REAL ;

.. _Real.Log:

Log
---

 Computes natural (e) logarithm of x 

.. code-block:: modula2

    PROCEDURE Log* (x: REAL) : REAL ;

.. _Real.Log10:

Log10
-----

 Computes common (base-10) logarithm of x 

.. code-block:: modula2

    PROCEDURE Log10* (x: REAL) : REAL ;

.. _Real.Floor:

Floor
-----

 Computes the largest integer value not greater than x 

.. code-block:: modula2

    PROCEDURE Floor* (x: REAL) : REAL ;

.. _Real.Round:

Round
-----

 Computes the nearest integer value to x, rounding halfway cases away from zero 

.. code-block:: modula2

    PROCEDURE Round *(x: REAL) : REAL ;

.. _Real.Random:

Random
------

 Next psuedo random number between min and max or 0. -> 1. if both min & max = 0

.. code-block:: modula2

    PROCEDURE Random* (min := 0., max := 0. : REAL): REAL;

.. _Real.FromString:

FromString
----------


Convert string `str` to `REAL` in either decimal or hex format and
optional `start` and `length` into `str`.

The benifit of the hex format is that the conversion is always exact.

TODO : Fix overflow/underflow (return INF/-INF) and add rounding to many digits.
       Skip trailing or leading zeros.

Return `TRUE` if success.


.. code-block:: modula2

    PROCEDURE FromString* (VAR result : REAL; str- : ARRAY OF CHAR; base := 10 : INTEGER; start := 0 : LONGINT ; length := -1 : LONGINT): BOOLEAN;

