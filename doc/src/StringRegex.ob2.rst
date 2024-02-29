.. index::
    single: StringRegex

.. _StringRegex:

***********
StringRegex
***********


This module is the RegCom module from the XDS compiler.
Copyright (c) 1993 xTech Ltd, Russia. All Rights Reserved.
Modified for inclusion in library.

A regular expression is a string which may contain certain special symbols:

* `"*"` - an arbitrary sequence of any characters, possibly empty.
* `"?"` - any single character.
* `"[...]"` - one of the listed characters.
* `"{...}"` - an arbitrary sequence of the listed characters, possibly empty.
* `"\nnn"` - the ASCII character with octal code nnn, where n is [0-7].
* `"&"` - the logical operation AND.
* `"|"` - the logical operation OR.
* `"^"` - the logical operation NOT.
* `"(...)"` - the priority of operations.
* `"$digit"` - subexpression number (see below).

A sequence of the form `a-b` used within either `[]` or `{}` brackets
denotes all characters from `a` to `b`.

`$digit` may follow `*`, `?`, `[]`, `{}` or `()` subexpression.
For a string matching a regular expression, it represents the
corresponding substring.

If you need to use any special symbol as an ordinary symbol, you should precede
it with a backslash (`\`), which suppresses interpretation of the following symbol.


Types
=====

.. code-block:: modula2

    Pattern* = POINTER TO PatternDesc;

Procedures
==========

.. _StringRegex.Compile:

Compile
-------


Compile the regular expression expr and return status:

* `res` <= 0 : error at position `ABS(res)` in expr;
* `res` >  0 : no error.


.. code-block:: modula2

    PROCEDURE Compile*(VAR reg: Pattern; expr-: ARRAY OF CHAR; VAR res: LONGINT);

.. _StringRegex.Pattern.Match:

Pattern.Match
-------------


Returns `TRUE`, if expression matches with string `s` starting
from position `pos`.


.. code-block:: modula2

    PROCEDURE (re : Pattern) Match*(s-: ARRAY OF CHAR; pos := 0 : LONGINT): BOOLEAN;

.. _StringRegex.Pattern.FullMatch:

Pattern.FullMatch
-----------------


Returns `TRUE`, if expression matches with whole string `s`.


.. code-block:: modula2

    PROCEDURE (re : Pattern) FullMatch*(s-: ARRAY OF CHAR): BOOLEAN;

.. _StringRegex.Pattern.MatchLength:

Pattern.MatchLength
-------------------


Returns the length of  the  substring matched to `$n`
at last call of match procedure with parameter `re`.


.. code-block:: modula2

    PROCEDURE (re : Pattern) MatchLength*(n := 0 : INTEGER): LONGINT;

.. _StringRegex.Pattern.MatchPos:

Pattern.MatchPos
----------------


Returns the position of the  beginning  of  the  substring
matched to `$n` at last call of match procedure with
parameter `re`.


.. code-block:: modula2

    PROCEDURE (re : Pattern) MatchPos*(n := 0 : INTEGER): LONGINT;


Example
=======

Date Example
------------

.. code-block:: modula2
    
    <* +MAIN *>
    MODULE TestRegex;
    IMPORT String, Re := StringRegex, 
    VAR   
        s : String.STRING;
        str : ARRAY 32 OF CHAR;
        re : Re.Pattern;
        res : LONGINT;
        ret : BOOLEAN;
        PROCEDURE Assert(b: BOOLEAN; id: LONGINT) ;
        BEGIN
            ASSERT(b);
        END Assert ;
    BEGIN
        Re.Compile(re, "(([0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9])|([0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]))", res);
        Assert(res > 0, 1);
        ret := re.FullMatch("01-01-2023");
        Assert(ret, 2);
        Assert(re.MatchPos() = 0, 3);
        Assert(re.MatchLength() = 10, 4);
    END TestRegex;

