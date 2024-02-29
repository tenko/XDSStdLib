.. index::
    single: ArrayOfChar

.. _ArrayOfChar:

***********
ArrayOfChar
***********

 Operations on `ARRAY OF CHAR`. All operations sets the `NUL` termination if possible 

Procedures
==========

.. _ArrayOfChar.Clear:

Clear
-----

 Set length of string to 0 

.. code-block:: modula2

    PROCEDURE Clear* (VAR str : ARRAY OF CHAR);

.. _ArrayOfChar.NulTerminate:

NulTerminate
------------

 Ensure string is `NUL` terminated 

.. code-block:: modula2

    PROCEDURE NulTerminate* (VAR str : ARRAY OF CHAR);

.. _ArrayOfChar.Capacity:

Capacity
--------

 Return capacity of the array 

.. code-block:: modula2

    PROCEDURE Capacity* (str- : ARRAY OF CHAR): LONGINT;

.. _ArrayOfChar.Length:

Length
------

 Find length of C style `NUL` terminated string or length of array if not `NUL` terminated 

.. code-block:: modula2

    PROCEDURE Length* (str-: ARRAY OF CHAR) : LONGINT ;

.. _ArrayOfChar.Assign:

Assign
------

 Assign `src` to `dst` 

.. code-block:: modula2

    PROCEDURE Assign* (VAR dst : ARRAY OF CHAR; src- : ARRAY OF CHAR);

.. _ArrayOfChar.FillChar:

FillChar
--------

 Fill string `dst` with char `chr` 

.. code-block:: modula2

    PROCEDURE FillChar* (VAR dst : ARRAY OF CHAR; chr : CHAR);

.. _ArrayOfChar.AppendChar:

AppendChar
----------

 Append `ch` to `dst` 

.. code-block:: modula2

    PROCEDURE AppendChar* (VAR dst : ARRAY OF CHAR; ch : CHAR);

.. _ArrayOfChar.Append:

Append
------

 Append `src` to `dst` 

.. code-block:: modula2

    PROCEDURE Append* (VAR dst : ARRAY OF CHAR; src- : ARRAY OF CHAR);

.. _ArrayOfChar.Extract:

Extract
-------

 Extract substring to `dst` from `src` from `start` position and `count` length. 

.. code-block:: modula2

    PROCEDURE Extract* (VAR dst : ARRAY OF CHAR; src- : ARRAY OF CHAR; start, count: LONGINT);

.. _ArrayOfChar.Compare:

Compare
-------


Compare strings `left` and `right` with option `IgnoreCase` set to ignore case.

* 0 if left = right
* -1 if left < right
* +1 if left > right


.. code-block:: modula2

    PROCEDURE Compare* (left-, right- : ARRAY OF CHAR; IgnoreCase := FALSE : BOOLEAN): INTEGER;

.. _ArrayOfChar.IndexChar:

IndexChar
---------

 Index of `char` in `str`. One based index with zero indicating `char` not found 

.. code-block:: modula2

    PROCEDURE IndexChar* (chr : CHAR; str- : ARRAY OF CHAR; start := 0 : LONGINT): LONGINT;

.. _ArrayOfChar.Index:

Index
-----


Index of `pattern` in `str`. -1 indicating pattern not found.
Note : This is a very simple implementation.


.. code-block:: modula2

    PROCEDURE Index* (pattern-, str-: ARRAY OF CHAR; start := 0 : LONGINT): LONGINT;

.. _ArrayOfChar.Index:

Index
-----


Index of `pattern` in str. -1 indicating `pattern` not found.

This is the TwoWay algorithm
 * http://monge.univ-mlv.fr/~mac/Articles-PDF/CP-1991-jacm.pdf
 * https://www-igm.univ-mlv.fr/~lecroq/string/node26.html


.. code-block:: modula2

    PROCEDURE Index* (pattern-, str-: ARRAY OF CHAR; start := 0 : LONGINT): LONGINT;

.. _ArrayOfChar.Delete:

Delete
------

 Delete `count` characters from `dst` starting from `start`. 

.. code-block:: modula2

    PROCEDURE Delete* (VAR dst: ARRAY OF CHAR; start, count: LONGINT);

.. _ArrayOfChar.Insert:

Insert
------

 Insert `src` into `dst` at `start`. 

.. code-block:: modula2

    PROCEDURE Insert* (VAR dst : ARRAY OF CHAR; src- : ARRAY OF CHAR; start: LONGINT);

.. _ArrayOfChar.Replace:

Replace
-------

 Replace `old` string with `new` string starting at index `start` (defaults to 0). 

.. code-block:: modula2

    PROCEDURE Replace* (VAR dst: ARRAY OF CHAR; old-, new-: ARRAY OF CHAR; start := 0 : LONGINT);

.. _ArrayOfChar.LeftTrim:

LeftTrim
--------

 Remove white space & control characters from left side of string. 

.. code-block:: modula2

    PROCEDURE LeftTrim* (VAR dst: ARRAY OF CHAR);

.. _ArrayOfChar.RightTrim:

RightTrim
---------

 Remove white space & special characters from right side of string. 

.. code-block:: modula2

    PROCEDURE RightTrim* (VAR dst: ARRAY OF CHAR);

.. _ArrayOfChar.Trim:

Trim
----

 Remove white space & special characters from right & left side of string. 

.. code-block:: modula2

    PROCEDURE Trim* (VAR dst: ARRAY OF CHAR);

.. _ArrayOfChar.LeftPad:

LeftPad
-------

 Left justified of length `width` with `ch` (defaults to SPC). 

.. code-block:: modula2

    PROCEDURE LeftPad* (VAR dst: ARRAY OF CHAR; width : LONGINT; ch := ' ' : CHAR);

.. _ArrayOfChar.RightPad:

RightPad
--------

 Right justified of length `width` with `ch` (defaults to SPC). 

.. code-block:: modula2

    PROCEDURE RightPad* (VAR dst: ARRAY OF CHAR; width : LONGINT; ch := ' ' : CHAR);

.. _ArrayOfChar.LowerCase:

LowerCase
---------

 Transform string inplace to lower case (Only takes into account the ASCII characters). 

.. code-block:: modula2

    PROCEDURE LowerCase* (VAR dst: ARRAY OF CHAR);

.. _ArrayOfChar.UpperCase:

UpperCase
---------

 Transform string inplace to upper case (Only takes into account the ASCII characters).

.. code-block:: modula2

    PROCEDURE UpperCase* (VAR dst: ARRAY OF CHAR);

.. _ArrayOfChar.Capitalize:

Capitalize
----------

 Capitalize string inplace. (Only takes into account the ASCII characters). 

.. code-block:: modula2

    PROCEDURE Capitalize* (VAR dst: ARRAY OF CHAR);

.. _ArrayOfChar.StartsWith:

StartsWith
----------

 Check if string `str` starts with `prefix`. 

.. code-block:: modula2

    PROCEDURE StartsWith* (str-, prefix- : ARRAY OF CHAR): BOOLEAN;

.. _ArrayOfChar.EndsWith:

EndsWith
--------

 Check if string `str` ends with `postfix`. 

.. code-block:: modula2

    PROCEDURE EndsWith* (str-, postfix- : ARRAY OF CHAR): BOOLEAN;

.. _ArrayOfChar.Match:

Match
-----


Return `TRUE` if `patter` matches `str`.

* `?` mathches a single character
*  `*` mathches any sequence of characters including zero length


.. code-block:: modula2

    PROCEDURE Match* (str- : ARRAY OF CHAR; pattern- : ARRAY OF CHAR; IgnoreCase := FALSE : BOOLEAN): BOOLEAN;

.. _ArrayOfChar.Hash:

Hash
----

  Hash value of array (32bit FNV-1a) 

.. code-block:: modula2

    PROCEDURE Hash* (src- : ARRAY OF CHAR; hash :=  0811C9DC5H : Type.CARD32): Type.CARD32;

