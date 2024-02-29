.. index::
    single: OSFile

.. _OSFile:

******
OSFile
******

 Module for operating on OS files 

Procedures
==========

.. _OSFile.Exists:

Exists
------

 Check if file exists 

.. code-block:: modula2

    PROCEDURE Exists*(filename-: ARRAY OF CHAR): BOOLEAN;

.. _OSFile.Delete:

Delete
------

 Try to delete file. Return `TRUE` on success 

.. code-block:: modula2

    PROCEDURE Delete*(filename-: ARRAY OF CHAR): BOOLEAN;

.. _OSFile.Rename:

Rename
------

 Try to rename file. Return `TRUE` on success 

.. code-block:: modula2

    PROCEDURE Rename*(oldname-, newname-: ARRAY OF CHAR): BOOLEAN;

.. _OSFile.ModifyTime:

ModifyTime
----------

 Try to get file access time. Return `TRUE` on success 

.. code-block:: modula2

    PROCEDURE ModifyTime*(VAR time : DateTime.DATETIME; filename-: ARRAY OF CHAR): BOOLEAN;

