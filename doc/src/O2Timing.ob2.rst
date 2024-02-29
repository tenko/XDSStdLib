.. index::
    single: O2Timing

.. _O2Timing:

********
O2Timing
********


Module for timing of procedure execution.

Reference files the perf directory for usage examples.


Types
=====

.. code-block:: modula2

    Proc* = PROCEDURE;

Vars
====

.. code-block:: modula2

    PCFreq : LONGREAL;

.. code-block:: modula2

    CounterStart : LONGREAL;

Procedures
==========

.. _O2Timing.StartTimer:

StartTimer
----------

 Setup timer 

.. code-block:: modula2

    PROCEDURE StartTimer*;

.. _O2Timing.Elapsed:

Elapsed
-------

 Elapsed time 

.. code-block:: modula2

    PROCEDURE Elapsed* (): LONGREAL;

.. _O2Timing.Timing:

Timing
------

 Run testproc and report statistics 

.. code-block:: modula2

    PROCEDURE Timing* (name : ARRAY OF CHAR; testproc : Proc; loops := 1000000 : LONGINT; outer := 10 : LONGINT);

