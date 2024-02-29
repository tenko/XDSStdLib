.. index::
    single: Char

.. _Char:

****
Char
****

 Module with operation on `CHAR` type. 

Const
=====

.. code-block:: modula2

    NUL* = CHR(00H);

.. code-block:: modula2

    TAB* = CHR(09H);

.. code-block:: modula2

    LF* = CHR(0AH);

.. code-block:: modula2

    CR* = CHR(0DH);

.. code-block:: modula2

    SPC* = CHR(020H);

Procedures
==========

.. _Char.IsControl:

IsControl
---------

.. code-block:: modula2

    PROCEDURE IsControl* (ch: CHAR) : BOOLEAN ;

.. _Char.IsDigit:

IsDigit
-------

 Returns true of ch is a digit 

.. code-block:: modula2

    PROCEDURE IsDigit* (ch: CHAR) : BOOLEAN ;

.. _Char.IsLetter:

IsLetter
--------

 Returns true of ch is a letter 

.. code-block:: modula2

    PROCEDURE IsLetter* (ch: CHAR) : BOOLEAN ;

.. _Char.IsSpace:

IsSpace
-------

 Returns true of ch is a white space character 

.. code-block:: modula2

    PROCEDURE IsSpace* (ch: CHAR) : BOOLEAN ;

.. _Char.IsLower:

IsLower
-------

 Returns true of ch is a lower case letter 

.. code-block:: modula2

    PROCEDURE IsLower* (ch: CHAR) : BOOLEAN ;

.. _Char.IsUpper:

IsUpper
-------

 Returns true of ch is a upper case letter 

.. code-block:: modula2

    PROCEDURE IsUpper* (ch: CHAR) : BOOLEAN ;

.. _Char.Lower:

Lower
-----

 Returns lower case letter or unmodified char 

.. code-block:: modula2

    PROCEDURE Lower* (ch: CHAR) : CHAR ;

.. _Char.Upper:

Upper
-----

 Returns upper case letter or unmodified char 

.. code-block:: modula2

    PROCEDURE Upper* (ch: CHAR) : CHAR ;

