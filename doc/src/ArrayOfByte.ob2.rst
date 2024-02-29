.. index::
    single: ArrayOfByte

.. _ArrayOfByte:

***********
ArrayOfByte
***********

 Operations on ARRAY OF BYTE. 

Procedures
==========

.. _ArrayOfByte.FillWord:

FillWord
--------

.. code-block:: modula2

    PROCEDURE FillWord* (VAR dst : ARRAY OF BYTE; val := {0,0,0,0} : ARRAY 4 OF BYTE; cnt := -1 : LONGINT);

.. _ArrayOfByte.Fill:

Fill
----

 Fill array with byte value 

.. code-block:: modula2

    PROCEDURE Fill* (VAR dst : ARRAY OF BYTE; val := 0 : BYTE; cnt := -1 : LONGINT);

.. _ArrayOfByte.Zero:

Zero
----

 Fill array with zeros 

.. code-block:: modula2

    PROCEDURE Zero* (VAR dst : ARRAY OF BYTE);

.. _ArrayOfByte.Copy:

Copy
----

 Copy from src to dst with optional cnt bytes, otherwise smallest size 

.. code-block:: modula2

    PROCEDURE Copy* (VAR dst : ARRAY OF BYTE; src- : ARRAY OF BYTE; cnt := -1 : LONGINT);

.. _ArrayOfByte.Compare:

Compare
-------


Compare byte arrays returns

* 0: if left = right
* -1: if left < right
* +1: if left > right


.. code-block:: modula2

    PROCEDURE Compare* (left-, right- : ARRAY OF BYTE): INTEGER;

.. _ArrayOfByte.Find:

Find
----

 Index of byte in array. Return -1 if not found 

.. code-block:: modula2

    PROCEDURE Find* (val : BYTE; arr- : ARRAY OF BYTE): LONGINT;

.. _ArrayOfByte.Hash:

Hash
----

  Hash value of array (32bit FNV-1a) 

.. code-block:: modula2

    PROCEDURE Hash* (src- : ARRAY OF BYTE; cnt := -1 : LONGINT; hash :=  HSTART : Type.CARD32): Type.CARD32;

