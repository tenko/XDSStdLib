.. index::
    single: ADTList

.. _ADTList:

*******
ADTList
*******

 
Double linked list class.


Types
=====

.. code-block:: modula2

    ListNode* = POINTER TO ListNodeDesc;

.. code-block:: modula2

    ListNodeDesc* = RECORD
            element-: ADT.Element;
            next, prev: ListNode;
        END;

.. code-block:: modula2

    List * = POINTER TO ListDesc;

.. code-block:: modula2

    ListDesc* = RECORD (ListNodeDesc)
            size: LONGINT;
        END;

.. code-block:: modula2

    ListIterator* = POINTER TO ListIteratorDesc;

.. code-block:: modula2

    ListIteratorDesc* = RECORD
            list : List;
            current : ListNode;
            reverse : BOOLEAN;
        END;

Procedures
==========

.. _ADTList.ListNode.Next:

ListNode.Next
-------------

.. code-block:: modula2

    PROCEDURE (this : ListNode) Next*() : ListNode;

.. _ADTList.ListNode.Prev:

ListNode.Prev
-------------

 Prev node or NIL if first 

.. code-block:: modula2

    PROCEDURE (this : ListNode) Prev*() : ListNode;

.. _ADTList.List.Clear:

List.Clear
----------

 Clear tree content

.. code-block:: modula2

    PROCEDURE (this : List) Clear*;

.. _ADTList.List.Init:

List.Init
---------

 Initialize  

.. code-block:: modula2

    PROCEDURE (this : List) Init*;

.. _ADTList.List.IsEmpty:

List.IsEmpty
------------

 Return TRUE if list is empty 

.. code-block:: modula2

    PROCEDURE (this: List) IsEmpty*(): BOOLEAN;

.. _ADTList.List.Size:

List.Size
---------

 Return list size 

.. code-block:: modula2

    PROCEDURE (this: List) Size*(): LONGINT;

.. _ADTList.List.First:

List.First
----------

 Return first node 

.. code-block:: modula2

    PROCEDURE (this: List) First*(): ListNode;

.. _ADTList.List.Last:

List.Last
---------

 Return last node 

.. code-block:: modula2

    PROCEDURE (this: List) Last*(): ListNode;

.. _ADTList.List.Iterator:

List.Iterator
-------------

 Get tree iterator 

.. code-block:: modula2

    PROCEDURE (this : List) Iterator*(reverse := FALSE : BOOLEAN): ListIterator;

.. _ADTList.ListIterator.Next:

ListIterator.Next
-----------------

 Advance iterator. Return `FALSE` if end is reached. 

.. code-block:: modula2

    PROCEDURE (this : ListIterator) Next*() : BOOLEAN;

.. _ADTList.ListIterator.Element:

ListIterator.Element
--------------------

 Current element or NIL 

.. code-block:: modula2

    PROCEDURE (this : ListIterator) Element*() : ADT.Element;

.. _ADTList.ListIterator.Reset:

ListIterator.Reset
------------------

 Reset iterator to start of tree. 

.. code-block:: modula2

    PROCEDURE (this : ListIterator) Reset*();

.. _ADTList.ListIterator.Insert:

ListIterator.Insert
-------------------

 Insert element before current iterator position 

.. code-block:: modula2

    PROCEDURE (this : ListIterator) Insert*(e : ADT.Element) ;

.. _ADTList.List.Append:

List.Append
-----------

 Append element to tail of list 

.. code-block:: modula2

    PROCEDURE (this: List) Append*(e: ADT.Element);

.. _ADTList.List.AppendHead:

List.AppendHead
---------------

 Append element to head of list 

.. code-block:: modula2

    PROCEDURE (this: List) AppendHead*(e: ADT.Element);

.. _ADTList.List.Pop:

List.Pop
--------

 Remove and return element at tail of list 

.. code-block:: modula2

    PROCEDURE (this: List) Pop*(): ADT.Element;

.. _ADTList.List.PopHead:

List.PopHead
------------

 Remove and return element at head of list 

.. code-block:: modula2

    PROCEDURE (this: List) PopHead*(): ADT.Element;

