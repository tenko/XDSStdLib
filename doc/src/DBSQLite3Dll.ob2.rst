.. index::
    single: DBSQLite3Dll

.. _DBSQLite3Dll:

************
DBSQLite3Dll
************

Const
=====

.. code-block:: modula2

    OK* 		=  0;

.. code-block:: modula2

    ERROR* 		=  1;

.. code-block:: modula2

    INTERNAL*   =  2;

.. code-block:: modula2

    PERM*       =  3;

.. code-block:: modula2

    ABORT*      =  4;

.. code-block:: modula2

    BUSY*       =  5;

.. code-block:: modula2

    LOCKED*     =  6;

.. code-block:: modula2

    NOMEM*      =  7;

.. code-block:: modula2

    READONLY*   =  8;

.. code-block:: modula2

    INTERRUPT*  =  9;

.. code-block:: modula2

    IOERR*      = 10;

.. code-block:: modula2

    CORRUPT*    = 11;

.. code-block:: modula2

    NOTFOUND*   = 12;

.. code-block:: modula2

    FULL*       = 13;

.. code-block:: modula2

    CANTOPEN*   = 14;

.. code-block:: modula2

    PROTOCOL*   = 15;

.. code-block:: modula2

    EMPTY*      = 16;

.. code-block:: modula2

    SCHEMA*     = 17;

.. code-block:: modula2

    TOOBIG*     = 18;

.. code-block:: modula2

    CONSTRAINT* = 19;

.. code-block:: modula2

    MISMATCH*   = 20;

.. code-block:: modula2

    MISUSE*     = 21;

.. code-block:: modula2

    NOLFS*      = 22;

.. code-block:: modula2

    AUTH*       = 23;

.. code-block:: modula2

    FORMAT*     = 24;

.. code-block:: modula2

    RANGE*      = 25;

.. code-block:: modula2

    NOTADB*     = 26;

.. code-block:: modula2

    NOTICE*     = 27;

.. code-block:: modula2

    WARNING*    = 28;

.. code-block:: modula2

    ROW*        = 100;

.. code-block:: modula2

    DONE*       = 101;

.. code-block:: modula2

    OPEN_READONLY*        = 00000001h;

.. code-block:: modula2

    OPEN_READWRITE*       = 00000002h;

.. code-block:: modula2

    OPEN_CREATE*          = 00000004h;

.. code-block:: modula2

    OPEN_DELETEONCLOSE*   = 00000008h;

.. code-block:: modula2

    OPEN_EXCLUSIVE*       = 00000010h;

.. code-block:: modula2

    OPEN_AUTOPROXY*       = 00000020h;

.. code-block:: modula2

    OPEN_URI*             = 00000040h;

.. code-block:: modula2

    OPEN_MEMORY*          = 00000080h;

.. code-block:: modula2

    OPEN_MAIN_DB*         = 00000100h;

.. code-block:: modula2

    OPEN_TEMP_DB*         = 00000200h;

.. code-block:: modula2

    OPEN_TRANSIENT_DB*    = 00000400h;

.. code-block:: modula2

    OPEN_MAIN_JOURNAL*    = 00000800h;

.. code-block:: modula2

    OPEN_TEMP_JOURNAL*    = 00001000h;

.. code-block:: modula2

    OPEN_SUBJOURNAL*      = 00002000h;

.. code-block:: modula2

    OPEN_SUPER_JOURNAL*   = 00004000h;

.. code-block:: modula2

    OPEN_NOMUTEX*         = 00008000h;

.. code-block:: modula2

    OPEN_FULLMUTEX*       = 00010000h;

.. code-block:: modula2

    OPEN_SHAREDCACHE*     = 00020000h;

.. code-block:: modula2

    OPEN_PRIVATECACHE*    = 00040000h;

.. code-block:: modula2

    OPEN_WAL*             = 00080000h;

.. code-block:: modula2

    OPEN_NOFOLLOW*        = 01000000h;

.. code-block:: modula2

    OPEN_EXRESCODE*       = 02000000h;

.. code-block:: modula2

    SQLITE_INTEGER*  	= 1;

.. code-block:: modula2

    SQLITE_FLOAT*    	= 2;

.. code-block:: modula2

    SQLITE_TEXT*     	= 3;

.. code-block:: modula2

    SQLITE_BLOB*     	= 4;

.. code-block:: modula2

    SQLITE_NULL*     	= 5;

Types
=====

.. code-block:: modula2

    DB* = POINTER TO RECORD END;

.. code-block:: modula2

    STMT* = POINTER TO RECORD END;

Vars
====

.. code-block:: modula2

    db : DB) : INT;

.. code-block:: modula2

    db : DB;

.. code-block:: modula2

    flags : INT;

.. code-block:: modula2

    zVfs : PCHAR) : INT;

.. code-block:: modula2

    stmtref : STMT;

.. code-block:: modula2

    tail : VOID) : INT;

Procedures
==========

.. _DBSQLite3Dll.CStringLength:

CStringLength
-------------

.. code-block:: modula2

    PROCEDURE CStringLength*(adr : ADDRESS): LONGINT;

.. _DBSQLite3Dll.CStringCopy:

CStringCopy
-----------

.. code-block:: modula2

    PROCEDURE CStringCopy*(adr : ADDRESS; VAR dst : ARRAY OF CHAR);

