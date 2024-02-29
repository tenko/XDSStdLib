.. index::
    single: OSPath

.. _OSPath:

******
OSPath
******

 Module for OS path operations.

Const
=====

.. code-block:: modula2

    SEP* = "\";

.. code-block:: modula2

    SEP* = "/";

Procedures
==========

.. _OSPath.Join:

Join
----

.. code-block:: modula2

    PROCEDURE Join*(VAR dst : String.STRING; left-, right- : ARRAY OF CHAR);

.. _OSPath.Absolute:

Absolute
--------

 Create absolute version of path 

.. code-block:: modula2

    PROCEDURE Absolute*(VAR dst : String.STRING; path- : ARRAY OF CHAR);

.. _OSPath.FileName:

FileName
--------

 Extract filename part of path 

.. code-block:: modula2

    PROCEDURE FileName*(VAR dst : String.STRING; path- : ARRAY OF CHAR);

.. _OSPath.DirName:

DirName
-------

 Extract directory part of path 

.. code-block:: modula2

    PROCEDURE DirName*(VAR dst : String.STRING; path- : ARRAY OF CHAR);

.. _OSPath.Extension:

Extension
---------

 Extract filename extension. 

.. code-block:: modula2

    PROCEDURE Extension*(VAR dst : String.STRING; path- : ARRAY OF CHAR);

.. _OSPath.Match:

Match
-----


Match `str` against ``pattern`` similar to the unix shell.

- `"*"` - match any string including empty string except for path separator
- `"?"` - match any single character except for path separator
- Character classes are defined with brackets `"[abc]"`
- Ranges are defined with `"-"` : `"[a-Z]"`
- Range and character classes can be negated with `"!"` : `"[!a-Z]"`
 

.. code-block:: modula2

    PROCEDURE Match*(str-, pattern- : ARRAY OF CHAR) : BOOLEAN;

