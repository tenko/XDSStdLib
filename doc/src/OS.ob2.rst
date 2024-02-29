.. index::
    single: OS

.. _OS:

**
OS
**


Module for basic OS functionality


Const
=====

.. code-block:: modula2

    Unknown*    = 0;

.. code-block:: modula2

    Position*   = 1;

.. code-block:: modula2

    Flag*       = 2;

.. code-block:: modula2

    Parameter*  = 3;

Types
=====

.. code-block:: modula2

    Argument* =
        RECORD
            name*   : String.STRING;
            value*  : String.STRING;
            index*  : LONGINT;
            type*   : LONGINT
        END;

Procedures
==========

.. _OS.ProgramName:

ProgramName
-----------

.. code-block:: modula2

    PROCEDURE ProgramName*(VAR name : String.STRING);

.. _OS.Args:

Args
----


Get number of program arguments


.. code-block:: modula2

    PROCEDURE Args*(): LONGINT;

.. _OS.Arg:

Arg
---


Get n-th argument


.. code-block:: modula2

    PROCEDURE Arg*(VAR value : String.STRING; n : LONGINT);

.. _OS.InitArgument:

InitArgument
------------


Initialize argument parser.

The parser support a on purpose limited for unambigious
parsing. The POSIX type of arguments with space between
flag and value is ambigious and therfore not supported.

* `-f`, sets type to `Flag` and name to `f`. value is empty.
* `-fval1`, sets type to `Parameter`, name to `f` and value to `val1`

Only alpha numeric characters are supported for short arguments.

* `--flag`, sets type to `Flag` and name to `flag`. value is empty.
* `-flag=val1`, sets type to `Parameter`, name to `flag` and value to `val1`

Any character is valid after `=`.
Whitespace is supported by enclosing the value in quotes.

An invalid argument is marked with type set to `Unknown` and
with value set the argument.

Other arguments are returned as type `Position` and
with value set to the argument.


.. code-block:: modula2

    PROCEDURE InitArgument*(VAR arg : Argument);

.. _OS.NextArgument:

NextArgument
------------


Fetch next argument or return `FALSE` if finished


.. code-block:: modula2

    PROCEDURE NextArgument*(VAR arg : Argument): BOOLEAN;

.. _OS.HasEnv:

HasEnv
------

 Check if environment variable exists 

.. code-block:: modula2

    PROCEDURE HasEnv*(name : ARRAY OF CHAR): BOOLEAN;

.. _OS.Env:

Env
---

 Get environment variable 

.. code-block:: modula2

    PROCEDURE Env*(VAR value : String.STRING; name : ARRAY OF CHAR);

.. _OS.Execute:

Execute
-------

 Execute shell command 

.. code-block:: modula2

    PROCEDURE Execute*(name : ARRAY OF CHAR): BOOLEAN;

.. _OS.Exit:

Exit
----

 Exit with return code 

.. code-block:: modula2

    PROCEDURE Exit*(code : INTEGER);

