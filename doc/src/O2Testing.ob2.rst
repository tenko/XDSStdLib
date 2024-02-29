.. index::
    single: O2Testing

.. _O2Testing:

*********
O2Testing
*********


Module for code testing.

For now the code Assert function must be given
sequential id numbers as the line number in files
is not available.

Reference to tests/Main.ob2 for usage.


Types
=====

.. code-block:: modula2

    TEST* = 
        RECORD
            tests : LONGINT;
            failed : LONGINT;
            local : LONGINT;
            localid : LONGINT;
            localfailed : LONGINT;
        END;

Procedures
==========

.. _O2Testing.Initialize:

Initialize
----------

.. code-block:: modula2

    PROCEDURE Initialize* (VAR test: TEST; file: ARRAY OF CHAR);

.. _O2Testing.Begin:

Begin
-----

 Begin local module tests 

.. code-block:: modula2

    PROCEDURE Begin* (VAR test: TEST; file: ARRAY OF CHAR);

.. _O2Testing.End:

End
---

 End local module tests and print out statistics 

.. code-block:: modula2

    PROCEDURE End* (VAR test: TEST; file: ARRAY OF CHAR);

.. _O2Testing.Finalize:

Finalize
--------

 Finalize tests and print out total statistics 

.. code-block:: modula2

    PROCEDURE Finalize* (VAR test: TEST; file: ARRAY OF CHAR);

.. _O2Testing.Assert:

Assert
------


Assert procedure.

id should be a sequental number starting from 1.


.. code-block:: modula2

    PROCEDURE Assert* (VAR test: TEST; b: BOOLEAN; file: ARRAY OF CHAR; id: LONGINT) ;

