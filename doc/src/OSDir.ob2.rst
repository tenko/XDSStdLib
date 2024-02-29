.. index::
    single: OSDir

.. _OSDir:

*****
OSDir
*****

 Module for operating on OS directories 

Types
=====

.. code-block:: modula2

    Dir* = RECORD
            dir : xlibOS.X2C_Dir;
        END;

Procedures
==========

.. _OSDir.Dir.Open:

Dir.Open
--------

.. code-block:: modula2

    PROCEDURE (VAR d : Dir) Open*(name- : ARRAY OF CHAR);

.. _OSDir.Dir.Close:

Dir.Close
---------

 Close directory listing 

.. code-block:: modula2

    PROCEDURE (VAR d : Dir) Close*();

.. _OSDir.Dir.Next:

Dir.Next
--------

 Advance to next item in directory listing 

.. code-block:: modula2

    PROCEDURE (VAR d : Dir) Next*();

.. _OSDir.Dir.Name:

Dir.Name
--------

 Entry name 

.. code-block:: modula2

    PROCEDURE (VAR d : Dir) Name*(VAR name : String.STRING);

.. _OSDir.Dir.IsDone:

Dir.IsDone
----------

 End of directory listing 

.. code-block:: modula2

    PROCEDURE (VAR d : Dir) IsDone*() : BOOLEAN;

.. _OSDir.Dir.IsFile:

Dir.IsFile
----------

 Entry is file? 

.. code-block:: modula2

    PROCEDURE (VAR d : Dir) IsFile*() : BOOLEAN;

.. _OSDir.Current:

Current
-------

 Get current directory name 

.. code-block:: modula2

    PROCEDURE Current*(VAR name : String.STRING);

.. _OSDir.SetCurrent:

SetCurrent
----------

 Set current directory name 

.. code-block:: modula2

    PROCEDURE SetCurrent*(name- : ARRAY OF CHAR): BOOLEAN;

.. _OSDir.Create:

Create
------

 Try to create directory. Return `TRUE` on success 

.. code-block:: modula2

    PROCEDURE Create*(filename-: ARRAY OF CHAR): BOOLEAN;

.. _OSDir.Delete:

Delete
------

 Try to delete directory. Return `TRUE` on success 

.. code-block:: modula2

    PROCEDURE Delete*(filename-: ARRAY OF CHAR): BOOLEAN;

