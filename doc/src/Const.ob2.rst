.. index::
    single: Const

.. _Const:

*****
Const
*****

 Module with common library constants 

Const
=====

.. code-block:: modula2

    VERSION* = "0.1";

.. code-block:: modula2

    BUILD* = "1";

.. code-block:: modula2

    HOST* = COMPILER.EQUATION("ENV_HOST");

.. code-block:: modula2

    TARGET* = COMPILER.EQUATION("ENV_TARGET");

.. code-block:: modula2

    CPU* = COMPILER.EQUATION("CPU");

.. code-block:: modula2

    WORDSIZE* = 4;

.. code-block:: modula2

    EQUAL*      = 0;

.. code-block:: modula2

    GREATER*    = 1;

.. code-block:: modula2

    LESS*       = -1;

.. code-block:: modula2

    NONCOMPARED*= 2;

.. code-block:: modula2

    DEBUG*  = 4;

.. code-block:: modula2

    INFO*   = 3;

.. code-block:: modula2

    WARN*   = 2;

.. code-block:: modula2

    ERROR*  = 1;

.. code-block:: modula2

    FATAL*  = 0;

.. code-block:: modula2

    FmtLeft* = {0};

.. code-block:: modula2

    FmtRight* = {1};

.. code-block:: modula2

    FmtCenter* = {2};

.. code-block:: modula2

    FmtSign* = {3};

.. code-block:: modula2

    FmtZero* = {4};

.. code-block:: modula2

    FmtSpc* = {5};

.. code-block:: modula2

    FmtAlt* = {6};

.. code-block:: modula2

    FmtUpper* = {7};

.. code-block:: modula2

    FPZero* = 0;

.. code-block:: modula2

    FPNormal* = 1;

.. code-block:: modula2

    FPSubnormal* = 2;

.. code-block:: modula2

    FPInfinite* = 3;

.. code-block:: modula2

    FPNaN* = 4;

.. code-block:: modula2

    SeekSet* = 0;

.. code-block:: modula2

    SeekCur* = 1;

.. code-block:: modula2

    SeekEnd* = 2;

.. code-block:: modula2

    StreamOK* = 0;

.. code-block:: modula2

    StreamNotImplementedError* = 1;

.. code-block:: modula2

    StreamNotOpenError* = 2;

.. code-block:: modula2

    StreamReadError* = 3;

.. code-block:: modula2

    StreamWriteError* = 4;

