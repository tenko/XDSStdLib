.. index::
    single: Format

.. _Format:

******
Format
******


String formatting operating on Stream object.


Const
=====

.. code-block:: modula2

    Left* = Const.FmtLeft;

.. code-block:: modula2

    Right* = Const.FmtRight;

.. code-block:: modula2

    Center* = Const.FmtCenter;

.. code-block:: modula2

    Sign* = Const.FmtSign;

.. code-block:: modula2

    Zero* = Const.FmtZero;

.. code-block:: modula2

    Spc* = Const.FmtSpc;

.. code-block:: modula2

    Alt* = Const.FmtAlt;

.. code-block:: modula2

    Upper* = Const.FmtUpper;

.. code-block:: modula2

    YYYYMMDD*       = '%y-%m-%d';

.. code-block:: modula2

    HHMMSS*         = '%H:%M:%S';

.. code-block:: modula2

    DATEANDTIME*    = '%y-%m-%dT%H:%M:%S';

.. code-block:: modula2

    DATE*           = '%A %d, %B, %y';

.. code-block:: modula2

    DATEABBR*       = '%a %d, %b, %y';

Vars
====

.. code-block:: modula2

    defaultNL : LineSep;

Procedures
==========

.. _Format.DateTime:

DateTime
--------


Format `DATETIME` according to format string arguments:

* `%a` : Weekday abbreviated name : Mon .. Sun
* `%A` : Weekday full name : Monday .. Sunday
* `%w` : Weekday as number : 0 .. 6
* `%b` : Month abbreviated name : Jan .. Des
* `%B` : Month full name : Januar .. Desember
* `%Y` : Year without century : 00 - 99
* `%y` : Year with century : 0000 - 9999
* `%m` : Month zero-padded : 00 - 12
* `%d` : Day of the month zero-padded : 01 - XX
* `%W` : Week of the year zero-padded : 01 - 53
* `%H` : Hour (24-hour clock) zero-padded : 00 - 23
* `%I` : Hour (12-hour clock) zero-padded : 1 - 12
* `%p` : AM or PM
* `%M` : Minute zero-padded : 00 - 59
* `%S` : Second zero-padded : 00 - 59
* `%f` : Milliseconds zero-padded : 000 - 999
* `%Z` : Timezone : UTC+/-
* `%%` : Literal `%` char

Other characters are copied to output.


.. code-block:: modula2

    PROCEDURE DateTime* (writer : Stream; datetime : DT.DATETIME; fmt- : ARRAY OF CHAR);

.. _Format.RealHex:

RealHex
-------


Format Real to hex format.

TODO : Add rounding


.. code-block:: modula2

    PROCEDURE RealHex*(writer : Stream; value : LONGREAL; UpperCase := FALSE : BOOLEAN);

.. _Format.Cardinal:

Cardinal
--------


Format `CARD64`. This is a separate method due to a limit in the `XDS`
compiler where `CARD64` is not supported by `SEQ` parameters.

* `base` : Number base. Defalts to 10.
* `width` : Total field with. Can overflow if number is bigger.

The formatting flags defaults to `Right` alignment.
The `Zero` flag fills with 0 of the formatting is right aligned.
The `Upper` flag the hex decimal letters are upper case.

The `Alt` flags prefix binary (base 2) numbers with `0b`,
octal numbers (base 8) with `0o` and hex decimal numbers
with either `0x` or `0X` depending on the `Upper` flag.


.. code-block:: modula2

    PROCEDURE Cardinal*(writer : Stream; value : SYSTEM.CARD64; base := 10 : INTEGER; width := 0 : LONGINT; flags := {} : SET);

.. _Format.Integer:

Integer
-------


Format `LONGLONGINT`. This is a separate method due to a limit in the `XDS`
compiler where `LONGLONGINT` is not supported by `SEQ` parameters.

* `width` : Total field with. Can overflow if number is bigger.

The formatting flags defaults to `Right` alignment.
The `Zero` flag fills with 0 of the formatting is right aligned.
The `Spc` flag fills in a blank character if the number is positive.
The `Sign` flag fills in a `+` character if the number is positive.
If both `Spc` and `Sign` are given then `Sign` precedes.


.. code-block:: modula2

    PROCEDURE Integer*(writer : Stream; value : LONGLONGINT; width := 0 : LONGINT; flags := {} : SET);

.. _Format.String:

String
------


Format `ARRAY OF CHAR`. 

* `width` : Total field with. Can overflow if string is bigger.
* `prec` : The number of characters in string to add.

The formatting flags defaults to `Left` alignment.


.. code-block:: modula2

    PROCEDURE String*(writer : Stream; str- : ARRAY OF CHAR; width := 0 : LONGINT; prec := 0 : LONGINT; flags := {} : SET);

.. _Format.StreamFmt:

StreamFmt
---------


Format arguments according to fmt argument string.

Syntax : ``%[align][sign]["0"]["#"][width]["." prec][type]``

Where :

* `align` : ``"<" |  ">" |  "^"``
* `sign` : ``"+" |  "-" |  " "``
* `width` : ``digit+``
* `prec` : ``digit+``
* `type` :  ``"b" |  "c" |  "d" |  "e" |  "E" |  "f" |  "g" | "o" |  "s" |  "S" |  "u" |  "x" | "X"``            

Unless the `width` argument is specified the formatting will use the
minimum needed space. Alignment has only meaning with the `width`
argument specified. The `prec` argument has different meaning depending
on the formatting `type`.

Align options :

* ``"<"`` - Left alignment. This is default for strings.
* ``">"`` - Right alignment. This is default for numbers.
* ``"^"`` - Center alignment.

Sign options (Numbers only) :

* ``"+"`` - Include sign for both positive and negative numbers.
* ``"-"`` - Include sign for negative numbers. (default)
* ``" "`` - Insert space character for positive number and negative sign for negative numbers.

Other options :

* ``"0"`` - With a right aligned number fill zeros to the left.
* ``"#"`` - Alternative representation valid for some types.

Types :

* ``"b"`` - Binary base 2 number. Alternative form add prefix of ``"0b"``
* ``"c"`` - Character argument.
* ``"d"`` - Signed decimal base 10 number.
* ``"u"`` - Unsigned decimal base 10 number.
* ``"o"`` - Octal base 8 number. Alternative form add prefix of ``"0o"``
* ``"x"`` - Hex base 16 number. Lower case version. Alternative form add prefix of ``"0x"``
* ``"X"`` - Hex base 16 number. Upper case version. Alternative form add prefix of ``"0X"``
* ``"e"`` - Real with scientific notation. The `prec` argument specifies the number of digits after the leading digit.
* ``"E"`` - Similar to scientific notation, but with upper case `E` for the exponent.
* ``"f"`` - Real with fixed-point notation. The `prec` argument specifies the number of digits after decimal point.
* ``"g"`` - Real general format. Rounds the number to `prec` significant digits. Then selects the format givind the most compact representation.
* ``"s"`` - String argument. The `prec` argument shortens the string if less than length.
* ``"S"`` - String argument. Upper case version. The `prec` argument shortens the string if less than length.



.. code-block:: modula2

    PROCEDURE StreamFmt*(writer : Stream; fmt- : ARRAY OF CHAR; seq: ARRAY OF SYSTEM.BYTE);

.. _Format.LineSeparator:

LineSeparator
-------------

 Sets the line separator 

.. code-block:: modula2

    PROCEDURE LineSeparator*(nl-: ARRAY OF CHAR);

