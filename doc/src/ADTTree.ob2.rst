.. index::
    single: ADTTree

.. _ADTTree:

*******
ADTTree
*******

 
AVL tree (Adelson-Velsky and Landis) is a self-balancing binary
search tree.

AVL trees keep the order of nodes on insertion/delete and allow
for fast find operations (average and worst case O(log n))

Copyright (c) 1993 xTech Ltd, Russia. All Rights Reserved.
Tenko : Modified for inclusion in library.


Types
=====

.. code-block:: modula2

    TreeNode* = POINTER TO TreeNodeDesc;

.. code-block:: modula2

    TreeNodeDesc* = RECORD
            element-: ADT.Element;
            left, right, up: TreeNode;
            bal: LONGINT;
        END;

.. code-block:: modula2

    Tree * = POINTER TO TreeDesc;

.. code-block:: modula2

    TreeDesc* = RECORD (TreeNodeDesc)
            minimum: TreeNode;
            size: LONGINT;
        END;

.. code-block:: modula2

    TreeIterator* = POINTER TO TreeIteratorDesc;

.. code-block:: modula2

    TreeIteratorDesc* = RECORD
            tree : Tree;
            current : TreeNode;
            reverse : BOOLEAN;
        END;

Procedures
==========

.. _ADTTree.TreeNode.Next:

TreeNode.Next
-------------

.. code-block:: modula2

    PROCEDURE (this : TreeNode) Next*() : TreeNode;

.. _ADTTree.TreeNode.Prev:

TreeNode.Prev
-------------

 Prev node or NIL if first 

.. code-block:: modula2

    PROCEDURE (this : TreeNode) Prev*() : TreeNode;

.. _ADTTree.Tree.Clear:

Tree.Clear
----------

 Clear tree content

.. code-block:: modula2

    PROCEDURE (this : Tree) Clear*;

.. _ADTTree.Tree.Init:

Tree.Init
---------

 Initialize  

.. code-block:: modula2

    PROCEDURE (this : Tree) Init*;

.. _ADTTree.Tree.IsEmpty:

Tree.IsEmpty
------------

 Return TRUE if tree is empty 

.. code-block:: modula2

    PROCEDURE (this: Tree) IsEmpty*(): BOOLEAN;

.. _ADTTree.Tree.Size:

Tree.Size
---------

 Return tree size 

.. code-block:: modula2

    PROCEDURE (this: Tree) Size*(): LONGINT;

.. _ADTTree.Tree.First:

Tree.First
----------

 Return first node 

.. code-block:: modula2

    PROCEDURE (this: Tree) First*(): TreeNode;

.. _ADTTree.Tree.Last:

Tree.Last
---------

 Return last node 

.. code-block:: modula2

    PROCEDURE (this: Tree) Last*(): TreeNode;

.. _ADTTree.Tree.Iterator:

Tree.Iterator
-------------

 Get tree iterator 

.. code-block:: modula2

    PROCEDURE (this : Tree) Iterator*(reverse := FALSE : BOOLEAN): TreeIterator;

.. _ADTTree.TreeIterator.Next:

TreeIterator.Next
-----------------

 Advance iterator. Return `FALSE` if end is reached. 

.. code-block:: modula2

    PROCEDURE (this : TreeIterator) Next*() : BOOLEAN;

.. _ADTTree.TreeIterator.Element:

TreeIterator.Element
--------------------

 Current element or NIL 

.. code-block:: modula2

    PROCEDURE (this : TreeIterator) Element*() : ADT.Element;

.. _ADTTree.TreeIterator.Reset:

TreeIterator.Reset
------------------

 Reset iterator to start of tree. 

.. code-block:: modula2

    PROCEDURE (this : TreeIterator) Reset*();

.. _ADTTree.Tree.FindNode:

Tree.FindNode
-------------

 Find node equal to element argument. Return NIL if no node is found. 

.. code-block:: modula2

    PROCEDURE (this: Tree) FindNode*(element: ADT.Element) : TreeNode;

.. _ADTTree.Tree.Find:

Tree.Find
---------

 Find element equal to argument. Return NIL if no element is found. 

.. code-block:: modula2

    PROCEDURE (this: Tree) Find*(element: ADT.Element) : ADT.Element;

.. _ADTTree.Tree.Insert:

Tree.Insert
-----------

 Insert element 

.. code-block:: modula2

    PROCEDURE (this: Tree) Insert*(e: ADT.Element);

.. _ADTTree.Tree.Remove:

Tree.Remove
-----------

 Remove element from tree if found 

.. code-block:: modula2

    PROCEDURE (this: Tree) Remove*(e: ADT.Element);

