.. index::
    single: DateTime

.. _DateTime:

********
DateTime
********


Date and Time module.

Adapted from `Julia`. License is MIT: https://julialang.org/license

A Date value is encoded as an `LONGLONGINT`, counting milliseconds
from an epoch. The epoch is 0000-12-31T00:00:00.

Days are adjusted accoring to `Rata Die` approch to simplify date calculations.

* Wikipedia: `Link <https://en.wikipedia.org/wiki/Rata_Die>`_
* Report: `Link <http://web.archive.org/web/20140910060704/http://mysite.verizon.net/aesir_research/date/date0.htm>`_


Const
=====

.. code-block:: modula2

    ERROR* = -1;

Types
=====

.. code-block:: modula2

    DATETIME* = LONGLONGINT;

.. code-block:: modula2

    TType* = (Year, Quarter, Month, Week, Day, Weekday, Hour, Min, Sec, MSec);

Procedures
==========

.. _DateTime.TryEncodeDate:

TryEncodeDate
-------------

 Return `TRUE` if the year, month & day is successful converted to a valid `DATETIME` 

.. code-block:: modula2

    PROCEDURE TryEncodeDate* (VAR date : DATETIME; year,month,day : LONGINT) : BOOLEAN;

.. _DateTime.EncodeDate:

EncodeDate
----------

 Return Encoded date. Return `ERROR` if not valid 

.. code-block:: modula2

    PROCEDURE EncodeDate* (year, month, day : LONGINT): DATETIME;

.. _DateTime.TryEncodeDateTime:

TryEncodeDateTime
-----------------

 Return `TRUE` if Year, Month, Day, Hour, Min, Sec & MSec is successful converted to a valid `DATETIME` 

.. code-block:: modula2

    PROCEDURE TryEncodeDateTime* (VAR datetime : DATETIME; year, month, day, hour, min, sec, msec : LONGINT) : BOOLEAN;

.. _DateTime.EncodeDateTime:

EncodeDateTime
--------------

 Return encoded `DATETIME`. Return `ERROR` if not valid 

.. code-block:: modula2

    PROCEDURE EncodeDateTime* (year, month, day, hour, min, sec : LONGINT; msec := 0 : LONGINT): DATETIME;

.. _DateTime.DecodeDate:

DecodeDate
----------

 Decode `DATETIME` to Year, Month & Day 

.. code-block:: modula2

    PROCEDURE DecodeDate* (datetime: DATETIME; VAR year, month, day: LONGINT);

.. _DateTime.DecodeTime:

DecodeTime
----------

 Decode `DATETIME` to  Hour, Min, Sec & MSec 

.. code-block:: modula2

    PROCEDURE DecodeTime* (datetime: DATETIME; VAR hour, min, sec, msec: LONGINT);

.. _DateTime.DecodeDateTime:

DecodeDateTime
--------------

 Decode `DATETIME` to Year, Month, Day, Hour, Min, Sec & MSec 

.. code-block:: modula2

    PROCEDURE DecodeDateTime* (VAR year, month, day, hour, min, sec, msec: LONGINT; datetime: DATETIME);

.. _DateTime.DateTimeToDate:

DateTimeToDate
--------------

 Remove time part of `DATETIME` 

.. code-block:: modula2

    PROCEDURE DateTimeToDate* (datetime: DATETIME) : DATETIME;

.. _DateTime.Now:

Now
---

 Current `DATETIME` 

.. code-block:: modula2

    PROCEDURE Now* (): DATETIME;

.. _DateTime.Today:

Today
-----

 Current Date 

.. code-block:: modula2

    PROCEDURE Today* (): DATETIME;

.. _DateTime.IncYear:

IncYear
-------

 Increment Year of `DATETIME` and return modified value 

.. code-block:: modula2

    PROCEDURE IncYear* (datetime: DATETIME; years : LONGINT) : DATETIME;

.. _DateTime.DecYear:

DecYear
-------

 Decrement Year of `DATETIME` and return modified value 

.. code-block:: modula2

    PROCEDURE DecYear* (datetime: DATETIME; years : LONGINT) : DATETIME;

.. _DateTime.IncMonth:

IncMonth
--------

 Increment Month of `DATETIME` and return modified value 

.. code-block:: modula2

    PROCEDURE IncMonth* (datetime: DATETIME; months : LONGINT) : DATETIME;

.. _DateTime.DecMonth:

DecMonth
--------

 Deccrement Month of `DATETIME` and return modified value 

.. code-block:: modula2

    PROCEDURE DecMonth*(datetime: DATETIME; months : LONGINT) : DATETIME;

.. _DateTime.Inc:

Inc
---

 Increment `DATETIME` with Value according to Type.

.. code-block:: modula2

    PROCEDURE Inc* (VAR datetime : DATETIME; typ : TType; value : LONGLONGINT);

.. _DateTime.Dec:

Dec
---

 Decrement `DATETIME` with Value according to Type.

.. code-block:: modula2

    PROCEDURE Dec* (VAR datetime : DATETIME; typ : TType; value : LONGLONGINT);

.. _DateTime.Extract:

Extract
-------

 Extract component of `DATETIME` 

.. code-block:: modula2

    PROCEDURE Extract* (datetime : DATETIME; typ : TType) : LONGINT;

.. _DateTime.Trunc:

Trunc
-----


  Trucate `DATETIME` value according to Type.
  Usefull for comparison, calculate spans or finding start of periods (week, month).


.. code-block:: modula2

    PROCEDURE Trunc* (datetime : DATETIME; typ : TType) : DATETIME;

.. _DateTime.Diff:

Diff
----

 Compute difference between two dates. Extract year, month, day to get difference 

.. code-block:: modula2

    PROCEDURE Diff* (dtstart, dtend: DATETIME; addEndDay := FALSE : BOOLEAN) : DATETIME;

.. _DateTime.Span:

Span
----

 Calculate `DATETIME` span between Start and End according to Type 

.. code-block:: modula2

    PROCEDURE Span* (dtstart, dtend: DATETIME; typ : TType) : LONGINT;

.. _DateTime.FromString:

FromString
----------


Try to parse string to a `DATETIME` according to format string:

* `%y` : Year with century : 0 - 9999
* `%m` : Month : 1 - 12
* `%d` : Day of the month : 1 - XX
* `%H` : Hour (24-hour clock) : 0 - 23
* `%M` : Minute : 0 - 59
* `%S` : Second  : 0 - 59
* `%f` : Milliseconds : 0 - 999
* `%t` : One or more TAB or SPC characters
* `%%` : Literal `%` char

Numbers can be zero padded.
Other characters must match exactly.

Return -1 on failure or number of characters converted.


.. code-block:: modula2

    PROCEDURE FromString* (VAR datetime : DATETIME; src- : ARRAY OF CHAR; fmt- : ARRAY OF CHAR; start := 0 : LONGINT): LONGINT;

