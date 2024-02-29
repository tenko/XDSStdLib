.. index::
    single: ADTDictionary

.. _ADTDictionary:

*************
ADTDictionary
*************


Dictionary which implementes an extensible hash table.

Two types are implemented
 * `DictionaryStrInt` (`STRING` key and `LONGINT` value)
 * `DictionaryStrStr` (`STRING` key and `STRING` value)

Other types can be implemented by method of type
extension. Note that this solution comes with a
overhead (~2x) and if speed is needed it should be
implemented as stand alone.

Adapted from `Ben Hoyt` article about hash tables. License is `MIT`.


Const
=====

.. code-block:: modula2

    INITIAL_CAPACITY* = 32;

Types
=====

.. code-block:: modula2

    DictionaryEntry* = POINTER TO DictionaryEntryDesc;

.. code-block:: modula2

    DictionaryEntryDesc* = RECORD
            deleted* : BOOLEAN;
        END;

.. code-block:: modula2

    DictionaryEntryStorage* = POINTER TO ARRAY OF DictionaryEntry;

.. code-block:: modula2

    Dictionary* = POINTER TO DictionaryDesc;

.. code-block:: modula2

    DictionaryDesc* = RECORD
            storage : DictionaryEntryStorage;
            capacity : LONGINT;
            size : LONGINT;
        END;

.. code-block:: modula2

    DictionaryIterator* = POINTER TO DictionaryIteratorDesc;

.. code-block:: modula2

    DictionaryIteratorDesc* = RECORD
            dictionary* : Dictionary;
            entry* : DictionaryEntry;
            index* : LONGINT;
        END;

.. code-block:: modula2

    StringIntEntry* = POINTER TO StringIntEntryDesc;

.. code-block:: modula2

    DictionaryStrInt* = POINTER TO DictionaryStrIntDesc;

.. code-block:: modula2

    DictionaryStrIntIterator* = POINTER TO DictionaryStrIntIteratorDesc;

.. code-block:: modula2

    StrStrEntry* = POINTER TO StrStrEntryDesc;

.. code-block:: modula2

    DictionaryStrStr* = POINTER TO DictionaryStrStrDesc;

.. code-block:: modula2

    DictionaryStrStrIterator* = POINTER TO DictionaryStrStrIteratorDesc;

Procedures
==========

.. _ADTDictionary.Dictionary.Init:

Dictionary.Init
---------------


Initialize dictionary storage to given capacity. Default to `INITIAL_CAPACITY`.
Capacity will be rounded up to nearest exponent of 2 size, 64, 256, 512 etc. 


.. code-block:: modula2

    PROCEDURE (this : Dictionary) Init*(capacity := INITIAL_CAPACITY : LONGINT);

.. _ADTDictionary.Dictionary.IHasKey:

Dictionary.IHasKey
------------------


Internal HasKey method.
Implemented with concrete entry types in subclass.


.. code-block:: modula2

    PROCEDURE (this : Dictionary) IHasKey*(VAR entry : DictionaryEntryDesc): BOOLEAN;

.. _ADTDictionary.Dictionary.IGet:

Dictionary.IGet
---------------


Internal get method.
Implemented with concrete entry types in subclass.


.. code-block:: modula2

    PROCEDURE (this : Dictionary) IGet*(VAR entry : DictionaryEntryDesc): BOOLEAN;

.. _ADTDictionary.Dictionary.Clear:

Dictionary.Clear
----------------

 Clear entries without deallocation 

.. code-block:: modula2

    PROCEDURE (this : Dictionary) Clear*();

.. _ADTDictionary.Dictionary.ISet:

Dictionary.ISet
---------------


Internal set method.
Implemented with concrete entry types in subclass.


.. code-block:: modula2

    PROCEDURE (this : Dictionary) ISet*(VAR entry : DictionaryEntryDesc): BOOLEAN;

.. _ADTDictionary.Dictionary.IDeleteEntry:

Dictionary.IDeleteEntry
-----------------------


Internal delete method.
Implemented with concrete entry types in subclass.
https://en.wikipedia.org/wiki/Linear_probing#Deletion


.. code-block:: modula2

    PROCEDURE (this : Dictionary) IDeleteEntry*(VAR entry : DictionaryEntryDesc): BOOLEAN;

.. _ADTDictionary.DictionaryIterator.Next:

DictionaryIterator.Next
-----------------------

 Advance iterator. Return `FALSE` if end is reached. 

.. code-block:: modula2

    PROCEDURE (this : DictionaryIterator) Next*() : BOOLEAN;

.. _ADTDictionary.DictionaryIterator.Reset:

DictionaryIterator.Reset
------------------------

 Reset iterator to start of dictionary. 

.. code-block:: modula2

    PROCEDURE (this : DictionaryIterator) Reset*();

.. _ADTDictionary.DictionaryStrInt.HasKey:

DictionaryStrInt.HasKey
-----------------------

 Return `TRUE` if dictionary has given key 

.. code-block:: modula2

    PROCEDURE (this : DictionaryStrInt) HasKey*(key- : ARRAY OF CHAR): BOOLEAN;

.. _ADTDictionary.DictionaryStrInt.SetEntry:

DictionaryStrInt.SetEntry
-------------------------

 Set or update entry 

.. code-block:: modula2

    PROCEDURE (this : DictionaryStrInt) SetEntry*(entry : StringIntEntry): BOOLEAN;

.. _ADTDictionary.DictionaryStrInt.Set:

DictionaryStrInt.Set
--------------------

 Set or update key with value 

.. code-block:: modula2

    PROCEDURE (this : DictionaryStrInt) Set*(key- : ARRAY OF CHAR; value : LONGINT): BOOLEAN;

.. _ADTDictionary.DictionaryStrInt.GetEntry:

DictionaryStrInt.GetEntry
-------------------------

 Get entry. Return `TRUE` if entry exists

.. code-block:: modula2

    PROCEDURE (this : DictionaryStrInt) GetEntry*(entry : StringIntEntry): BOOLEAN;

.. _ADTDictionary.DictionaryStrInt.Get:

DictionaryStrInt.Get
--------------------

 Get value from key. Return `TRUE` if entry exists

.. code-block:: modula2

    PROCEDURE (this : DictionaryStrInt) Get*(key- : ARRAY OF CHAR; VAR value : LONGINT): BOOLEAN;

.. _ADTDictionary.DictionaryStrInt.Delete:

DictionaryStrInt.Delete
-----------------------

 Mark entry as deleted. Return `TRUE` if entry exists 

.. code-block:: modula2

    PROCEDURE (this : DictionaryStrInt) Delete*(key- : ARRAY OF CHAR): BOOLEAN;

.. _ADTDictionary.DictionaryStrInt.Iterator:

DictionaryStrInt.Iterator
-------------------------

 Get dictionary iterator 

.. code-block:: modula2

    PROCEDURE (this : DictionaryStrInt) Iterator*(): DictionaryStrIntIterator;

.. _ADTDictionary.DictionaryStrIntIterator.Key:

DictionaryStrIntIterator.Key
----------------------------

 Get current iterator entry's key 

.. code-block:: modula2

    PROCEDURE (this : DictionaryStrIntIterator) Key*(): S.STRING;

.. _ADTDictionary.DictionaryStrIntIterator.Value:

DictionaryStrIntIterator.Value
------------------------------

 Get current iterator entry's value 

.. code-block:: modula2

    PROCEDURE (this : DictionaryStrIntIterator) Value*(): LONGINT;

.. _ADTDictionary.DictionaryStrInt.Keys:

DictionaryStrInt.Keys
---------------------

 Return Vector of keys 

.. code-block:: modula2

    PROCEDURE (this : DictionaryStrInt) Keys*(): Vector.VectorOfString;

.. _ADTDictionary.DictionaryStrStr.HasKey:

DictionaryStrStr.HasKey
-----------------------

 Return `TRUE` if dictionary has given key 

.. code-block:: modula2

    PROCEDURE (this : DictionaryStrStr) HasKey*(key- : ARRAY OF CHAR): BOOLEAN;

.. _ADTDictionary.DictionaryStrStr.SetEntry:

DictionaryStrStr.SetEntry
-------------------------

 Set or update entry 

.. code-block:: modula2

    PROCEDURE (this : DictionaryStrStr) SetEntry*(entry : StrStrEntry): BOOLEAN;

.. _ADTDictionary.DictionaryStrStr.Set:

DictionaryStrStr.Set
--------------------

 Set or update key with value 

.. code-block:: modula2

    PROCEDURE (this : DictionaryStrStr) Set*(key- : ARRAY OF CHAR; value- : ARRAY OF CHAR): BOOLEAN;

.. _ADTDictionary.DictionaryStrStr.GetEntry:

DictionaryStrStr.GetEntry
-------------------------

 Get entry. Return `TRUE` if entry exists

.. code-block:: modula2

    PROCEDURE (this : DictionaryStrStr) GetEntry*(entry : StrStrEntry): BOOLEAN;

.. _ADTDictionary.DictionaryStrStr.Get:

DictionaryStrStr.Get
--------------------

 Get value from key. Return `TRUE` if entry exists

.. code-block:: modula2

    PROCEDURE (this : DictionaryStrStr) Get*(key- : ARRAY OF CHAR; VAR value : S.STRING): BOOLEAN;

.. _ADTDictionary.DictionaryStrStr.Delete:

DictionaryStrStr.Delete
-----------------------

 Mark entry as deleted. Return `TRUE` if entry exists 

.. code-block:: modula2

    PROCEDURE (this : DictionaryStrStr) Delete*(key- : ARRAY OF CHAR): BOOLEAN;

.. _ADTDictionary.DictionaryStrStr.Iterator:

DictionaryStrStr.Iterator
-------------------------

 Get dictionary iterator 

.. code-block:: modula2

    PROCEDURE (this : DictionaryStrStr) Iterator*(): DictionaryStrStrIterator;

.. _ADTDictionary.DictionaryStrStrIterator.Key:

DictionaryStrStrIterator.Key
----------------------------

 Get current iterator entry's key 

.. code-block:: modula2

    PROCEDURE (this : DictionaryStrStrIterator) Key*(): S.STRING;

.. _ADTDictionary.DictionaryStrStrIterator.Value:

DictionaryStrStrIterator.Value
------------------------------

 Get current iterator entry's value 

.. code-block:: modula2

    PROCEDURE (this : DictionaryStrStrIterator) Value*(): S.STRING;

.. _ADTDictionary.DictionaryStrStr.Keys:

DictionaryStrStr.Keys
---------------------

 Return Vector of keys 

.. code-block:: modula2

    PROCEDURE (this : DictionaryStrStr) Keys*(): Vector.VectorOfString;

