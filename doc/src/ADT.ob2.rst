.. index::
    single: ADT

.. _ADT:

***
ADT
***

 
Common ADT objects


Types
=====

.. code-block:: modula2

    Element* = POINTER TO ElementDesc;

.. code-block:: modula2

    ElementDesc* = RECORD END;

.. code-block:: modula2

    StringElement* = POINTER TO StringElementDesc;

.. code-block:: modula2

    StringElementDesc* = RECORD(ElementDesc)
            str- : String.STRING;
        END;

Procedures
==========

.. _ADT.Element.Compare:

Element.Compare
---------------

.. code-block:: modula2

    PROCEDURE (this: Element) Compare* (e: Element): LONGINT;

.. _ADT.StringElement.Compare:

StringElement.Compare
---------------------

 Comapre StringElement 

.. code-block:: modula2

    PROCEDURE (this: StringElement) Compare* (e: Element): LONGINT;

.. _ADT.NewStringElement:

NewStringElement
----------------

 Allocate new StringElement from str 

.. code-block:: modula2

    PROCEDURE NewStringElement* (str- : ARRAY OF CHAR) : StringElement;

