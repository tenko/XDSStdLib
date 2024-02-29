.. index::
    single: ADTSet

.. _ADTSet:

******
ADTSet
******


Set which s a hash table for values based on :ref:`ADTDictionary`

Two set types are implemented
 * `SetInt` (`LONGINT` value)
 * `SetStr` (`STRING` value)

Other types can be implemented by method of type
extension. Note that this solution comes with a
overhead (~2x) and if speed is needed it should be
implemented as stand alone.

Adapted from Ben Hoyt article about hash tables. License is MIT.


Types
=====

.. code-block:: modula2

    IntEntry* = POINTER TO IntEntryDesc;

.. code-block:: modula2

    SetInt* = POINTER TO SetIntDesc;

.. code-block:: modula2

    SetIntIterator* = POINTER TO SetIntIteratorDesc;

.. code-block:: modula2

    StrEntry* = POINTER TO StrEntryDesc;

.. code-block:: modula2

    SetStr* = POINTER TO SetStrDesc;

.. code-block:: modula2

    SetStrIterator* = POINTER TO SetStrIteratorDesc;

Procedures
==========

.. _ADTSet.SetInt.In:

SetInt.In
---------

 Return TRUE if set has given value 

.. code-block:: modula2

    PROCEDURE (this : SetInt) In*(value : LONGINT): BOOLEAN;

.. _ADTSet.SetInt.Add:

SetInt.Add
----------

 Add value to set 

.. code-block:: modula2

    PROCEDURE (this : SetInt) Add*(value : LONGINT): BOOLEAN;

.. _ADTSet.SetInt.Remove:

SetInt.Remove
-------------

 Mark entry as deleted. Return TRUE if entry exists 

.. code-block:: modula2

    PROCEDURE (this : SetInt) Remove*(value : LONGINT): BOOLEAN;

.. _ADTSet.SetInt.Iterator:

SetInt.Iterator
---------------

 Get set iterator 

.. code-block:: modula2

    PROCEDURE (this : SetInt) Iterator*(): SetIntIterator;

.. _ADTSet.SetIntIterator.Value:

SetIntIterator.Value
--------------------

 Get current iterator entry's value 

.. code-block:: modula2

    PROCEDURE (this : SetIntIterator) Value*(): LONGINT;

.. _ADTSet.SetInt.Values:

SetInt.Values
-------------

 Return Vector of values 

.. code-block:: modula2

    PROCEDURE (this : SetInt) Values*(): Vector.VectorOfLongInt;

.. _ADTSet.SetStr.In:

SetStr.In
---------

 Return TRUE if set has given value 

.. code-block:: modula2

    PROCEDURE (this : SetStr) In*(value : ARRAY OF CHAR): BOOLEAN;

.. _ADTSet.SetStr.Add:

SetStr.Add
----------

 Add value to set 

.. code-block:: modula2

    PROCEDURE (this : SetStr) Add*(value : ARRAY OF CHAR): BOOLEAN;

.. _ADTSet.SetStr.Remove:

SetStr.Remove
-------------

 Mark entry as deleted. Return TRUE if entry exists 

.. code-block:: modula2

    PROCEDURE (this : SetStr) Remove*(value : ARRAY OF CHAR): BOOLEAN;

.. _ADTSet.SetStr.Iterator:

SetStr.Iterator
---------------

 Get set iterator 

.. code-block:: modula2

    PROCEDURE (this : SetStr) Iterator*(): SetStrIterator;

.. _ADTSet.SetStrIterator.Value:

SetStrIterator.Value
--------------------

 Get current iterator entry's value 

.. code-block:: modula2

    PROCEDURE (this : SetStrIterator) Value*(): S.STRING;

.. _ADTSet.SetStr.Values:

SetStr.Values
-------------

 Return Vector of values 

.. code-block:: modula2

    PROCEDURE (this : SetStr) Values*(): Vector.VectorOfString;

