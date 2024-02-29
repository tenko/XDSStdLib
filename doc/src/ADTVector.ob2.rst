.. index::
    single: ADTVector

.. _ADTVector:

*********
ADTVector
*********


The `Vector` module implements resizable container.
It is fast to append to end of array. Insert data
at random locations then this container is not suitable for.

WARNING: The `VectorOfByte` implementation is not type safe and
the developer must ensure that no `GC` data is placed in the array.
Any data can be pushed to this Vector. `VectorOfByte` should be
extended with a concrete type safe interface.

The follow classes are defined
 * `VectorOfByte` (Ref. warning above.)
 * `VectorOfLongInt`
 * `VectorOfLongReal`
 * `VectorOfString`

Other types can be implemented by method of type
extension without much overhead.


Const
=====

.. code-block:: modula2

    INIT_SIZE* = 64;

Types
=====

.. code-block:: modula2

    VectorValue* = RECORD END;

.. code-block:: modula2

    Vector* = POINTER TO VectorDesc;

.. code-block:: modula2

    VectorDesc* = RECORD
            last : LONGINT;
        END;

.. code-block:: modula2

    VectorByteValue* = RECORD (VectorValue) byte- : SYSTEM.BYTE END;

.. code-block:: modula2

    VectorOfByte* = POINTER TO VectorOfByteDesc;

.. code-block:: modula2

    VectorLongIntValue* = RECORD (VectorValue) longint- : LONGINT END;

.. code-block:: modula2

    VectorOfLongInt* = POINTER TO VectorOfLongIntDesc;

.. code-block:: modula2

    VectorLongRealValue* = RECORD (VectorValue) longreal- : LONGREAL END;

.. code-block:: modula2

    VectorOfLongReal* = POINTER TO VectorOfLongRealDesc;

.. code-block:: modula2

    VectorStringValue* = RECORD (VectorValue) string- : String.STRING END;

.. code-block:: modula2

    VectorOfString* = POINTER TO VectorOfStringDesc;

Procedures
==========

.. _ADTVector.Vector.Size:

Vector.Size
-----------

.. code-block:: modula2

    PROCEDURE (this : Vector) Size*(): LONGINT;

.. _ADTVector.Vector.Capacity:

Vector.Capacity
---------------


Capacity of array.
Must be reimplemented. 

.. code-block:: modula2

    PROCEDURE (this : Vector) Capacity*(): LONGINT;

.. _ADTVector.Vector.Reserve:

Vector.Reserve
--------------


Resize storage to accomodate capacity.
Must be reimplemented. 

.. code-block:: modula2

    PROCEDURE (this : Vector) Reserve*(capacity  : LONGINT);

.. _ADTVector.Vector.Resize:

Vector.Resize
-------------

 Resize vector potential discarding data 

.. code-block:: modula2

    PROCEDURE (this : Vector) Resize*(capacity  : LONGINT);

.. _ADTVector.Vector.Shrink:

Vector.Shrink
-------------


Shrink storage.
Must be reimplemented. 

.. code-block:: modula2

    PROCEDURE (this : Vector) Shrink*();

.. _ADTVector.Vector.Clear:

Vector.Clear
------------

 Clear Vector to zero size 

.. code-block:: modula2

    PROCEDURE (this : Vector) Clear*();

.. _ADTVector.Vector.Reverse:

Vector.Reverse
--------------

 Reverse array in-place 

.. code-block:: modula2

    PROCEDURE (this : Vector) Reverse*();

.. _ADTVector.Vector.Shuffle:

Vector.Shuffle
--------------

 Random shuffle array in-place 

.. code-block:: modula2

    PROCEDURE (this : Vector) Shuffle*();

.. _ADTVector.Vector.Sort:

Vector.Sort
-----------

 Sort array in-place (QuickSort) 

.. code-block:: modula2

    PROCEDURE (this : Vector) Sort*;

.. _ADTVector.VectorOfByte.InitRaw:

VectorOfByte.InitRaw
--------------------

 Initialize  

.. code-block:: modula2

    PROCEDURE (this : VectorOfByte) InitRaw*(size : LONGINT; itemSize := 1 : LONGINT);

.. _ADTVector.VectorOfByte.Capacity:

VectorOfByte.Capacity
---------------------

 Item capacity of vector 

.. code-block:: modula2

    PROCEDURE (this : VectorOfByte) Capacity*(): LONGINT;

.. _ADTVector.VectorOfByte.Reserve:

VectorOfByte.Reserve
--------------------

 Resize storage to accomodate capacity 

.. code-block:: modula2

    PROCEDURE (this : VectorOfByte) Reserve*(capacity  : LONGINT);

.. _ADTVector.VectorOfByte.Shrink:

VectorOfByte.Shrink
-------------------

 Shrink storage 

.. code-block:: modula2

    PROCEDURE (this : VectorOfByte) Shrink*();

.. _ADTVector.VectorOfByte.FillRaw:

VectorOfByte.FillRaw
--------------------

 Fill vector with capacity values, overwriting content and possible resize vector 

.. code-block:: modula2

    PROCEDURE (this : VectorOfByte) FillRaw*(capacity : LONGINT; value := 0 : SYSTEM.BYTE);

.. _ADTVector.VectorOfByte.GetRaw:

VectorOfByte.GetRaw
-------------------

 Get raw data from array 

.. code-block:: modula2

    PROCEDURE (this : VectorOfByte) GetRaw*(idx : LONGINT; VAR dst : ARRAY OF SYSTEM.BYTE);

.. _ADTVector.VectorOfByte.SetRaw:

VectorOfByte.SetRaw
-------------------

 Set raw data from src 

.. code-block:: modula2

    PROCEDURE (this : VectorOfByte) SetRaw*(idx : LONGINT; src- : ARRAY OF SYSTEM.BYTE);

.. _ADTVector.VectorOfByte.AppendRaw:

VectorOfByte.AppendRaw
----------------------

 Append raw data 

.. code-block:: modula2

    PROCEDURE (this : VectorOfByte) AppendRaw*(src- : ARRAY OF SYSTEM.BYTE);

.. _ADTVector.VectorOfLongInt.Init:

VectorOfLongInt.Init
--------------------

 Initialize  

.. code-block:: modula2

    PROCEDURE (this : VectorOfLongInt) Init*(size := INIT_SIZE : LONGINT);

.. _ADTVector.VectorOfLongInt.Capacity:

VectorOfLongInt.Capacity
------------------------

 Item capacity of vector 

.. code-block:: modula2

    PROCEDURE (this : VectorOfLongInt) Capacity*(): LONGINT;

.. _ADTVector.VectorOfLongInt.Reserve:

VectorOfLongInt.Reserve
-----------------------

 Resize storage to accomodate capacity 

.. code-block:: modula2

    PROCEDURE (this : VectorOfLongInt) Reserve*(capacity  : LONGINT);

.. _ADTVector.VectorOfLongInt.Shrink:

VectorOfLongInt.Shrink
----------------------

 Shrink storage 

.. code-block:: modula2

    PROCEDURE (this : VectorOfLongInt) Shrink*();

.. _ADTVector.VectorOfLongInt.BinaryFind:

VectorOfLongInt.BinaryFind
--------------------------


Find position in array. Expect array to be sorted in ascending order.
Return -1 if not found.


.. code-block:: modula2

    PROCEDURE (this : VectorOfLongInt) BinaryFind*(value : LONGINT): LONGINT;

.. _ADTVector.VectorOfLongInt.BinarySearch:

VectorOfLongInt.BinarySearch
----------------------------

 Find position in array where value should be inserted to keep array sorted.
Expect array to be sorted in ascending order.


.. code-block:: modula2

    PROCEDURE (this : VectorOfLongInt) BinarySearch*(value : LONGINT): LONGINT;

.. _ADTVector.VectorOfLongInt.Fill:

VectorOfLongInt.Fill
--------------------

 Fill vector with capacity values, overwriting content and possible resize vector 

.. code-block:: modula2

    PROCEDURE (this : VectorOfLongInt) Fill*(capacity : LONGINT; value := 0 : LONGINT);

.. _ADTVector.VectorOfLongInt.Append:

VectorOfLongInt.Append
----------------------

 Append raw data 

.. code-block:: modula2

    PROCEDURE (this : VectorOfLongInt) Append*(value : LONGINT);

.. _ADTVector.VectorOfLongInt.At:

VectorOfLongInt.At
------------------

 Return value at idx 

.. code-block:: modula2

    PROCEDURE (this : VectorOfLongInt) At*(idx : LONGINT) : LONGINT;

.. _ADTVector.VectorOfLongInt.Set:

VectorOfLongInt.Set
-------------------

 Set value at idx 

.. code-block:: modula2

    PROCEDURE (this : VectorOfLongInt) Set*(idx, value : LONGINT);

.. _ADTVector.VectorOfLongInt.Pop:

VectorOfLongInt.Pop
-------------------

 Pop last value 

.. code-block:: modula2

    PROCEDURE (this : VectorOfLongInt) Pop*(VAR value : LONGINT) : BOOLEAN;

.. _ADTVector.VectorOfLongReal.Init:

VectorOfLongReal.Init
---------------------

 Initialize  

.. code-block:: modula2

    PROCEDURE (this : VectorOfLongReal) Init*(size := INIT_SIZE : LONGINT);

.. _ADTVector.VectorOfLongReal.Capacity:

VectorOfLongReal.Capacity
-------------------------

 Item capacity of vector 

.. code-block:: modula2

    PROCEDURE (this : VectorOfLongReal) Capacity*(): LONGINT;

.. _ADTVector.VectorOfLongReal.Reserve:

VectorOfLongReal.Reserve
------------------------

 Resize storage to accomodate capacity 

.. code-block:: modula2

    PROCEDURE (this : VectorOfLongReal) Reserve*(capacity  : LONGINT);

.. _ADTVector.VectorOfLongReal.Shrink:

VectorOfLongReal.Shrink
-----------------------

 Shrink storage 

.. code-block:: modula2

    PROCEDURE (this : VectorOfLongReal) Shrink*();

.. _ADTVector.VectorOfLongReal.BinarySearch:

VectorOfLongReal.BinarySearch
-----------------------------


Find position in array where value should be inserted to keep array sorted.
Expect array to be sorted in ascending order.


.. code-block:: modula2

    PROCEDURE (this : VectorOfLongReal) BinarySearch*(value : LONGREAL): LONGINT;

.. _ADTVector.VectorOfLongReal.Fill:

VectorOfLongReal.Fill
---------------------

 Fill vector with capacity values, overwriting content and possible resize vector 

.. code-block:: modula2

    PROCEDURE (this : VectorOfLongReal) Fill*(capacity : LONGINT; value := 0.0 : LONGREAL);

.. _ADTVector.VectorOfLongReal.Append:

VectorOfLongReal.Append
-----------------------

 Append value to end of vector 

.. code-block:: modula2

    PROCEDURE (this : VectorOfLongReal) Append*(value : LONGREAL);

.. _ADTVector.VectorOfLongReal.At:

VectorOfLongReal.At
-------------------

 Return value at idx 

.. code-block:: modula2

    PROCEDURE (this : VectorOfLongReal) At*(idx : LONGINT) : LONGREAL;

.. _ADTVector.VectorOfLongReal.Set:

VectorOfLongReal.Set
--------------------

 Set value at idx 

.. code-block:: modula2

    PROCEDURE (this : VectorOfLongReal) Set*(idx : LONGINT; value : LONGREAL);

.. _ADTVector.VectorOfLongReal.Pop:

VectorOfLongReal.Pop
--------------------

 Pop last value 

.. code-block:: modula2

    PROCEDURE (this : VectorOfLongReal) Pop*(VAR value : LONGREAL) : BOOLEAN;

.. _ADTVector.VectorOfString.Init:

VectorOfString.Init
-------------------

 Initialize  

.. code-block:: modula2

    PROCEDURE (this : VectorOfString) Init*(size := INIT_SIZE : LONGINT);

.. _ADTVector.VectorOfString.Capacity:

VectorOfString.Capacity
-----------------------

 Item capacity of vector 

.. code-block:: modula2

    PROCEDURE (this : VectorOfString) Capacity*(): LONGINT;

.. _ADTVector.VectorOfString.Reserve:

VectorOfString.Reserve
----------------------

 Resize storage to accomodate capacity 

.. code-block:: modula2

    PROCEDURE (this : VectorOfString) Reserve*(capacity  : LONGINT);

.. _ADTVector.VectorOfString.Shrink:

VectorOfString.Shrink
---------------------

 Shrink storage 

.. code-block:: modula2

    PROCEDURE (this : VectorOfString) Shrink*();

.. _ADTVector.VectorOfString.BinarySearch:

VectorOfString.BinarySearch
---------------------------


Find position in array where value should be inserted to keep array sorted.
Expect array to be sorted in ascending order.


.. code-block:: modula2

    PROCEDURE (this : VectorOfString) BinarySearch*(value : ARRAY OF CHAR): LONGINT;

.. _ADTVector.VectorOfString.Fill:

VectorOfString.Fill
-------------------

 Fill vector with capacity values, overwriting content and possible resize vector 

.. code-block:: modula2

    PROCEDURE (this : VectorOfString) Fill*(capacity : LONGINT; value : ARRAY OF CHAR);

.. _ADTVector.VectorOfString.Append:

VectorOfString.Append
---------------------

 Append string to end of vector 

.. code-block:: modula2

    PROCEDURE (this : VectorOfString) Append*(value : ARRAY OF CHAR);

.. _ADTVector.VectorOfString.At:

VectorOfString.At
-----------------

 Return value at idx 

.. code-block:: modula2

    PROCEDURE (this : VectorOfString) At*(idx : LONGINT) : String.STRING;

.. _ADTVector.VectorOfString.Set:

VectorOfString.Set
------------------

 Set value at idx 

.. code-block:: modula2

    PROCEDURE (this : VectorOfString) Set*(idx : LONGINT; value : ARRAY OF CHAR);

.. _ADTVector.VectorOfString.Pop:

VectorOfString.Pop
------------------

 Pop last value 

.. code-block:: modula2

    PROCEDURE (this : VectorOfString) Pop*(VAR value : String.STRING) : BOOLEAN;

