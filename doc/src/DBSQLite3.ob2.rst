.. index::
    single: DBSQLite3

.. _DBSQLite3:

*********
DBSQLite3
*********


Module with object oriented access to a `SQLite` database.

The class will automatic release any resources when garbage collected.


Const
=====

.. code-block:: modula2

    OPEN_READONLY* 	    = SQLite3Dll.OPEN_READONLY;

.. code-block:: modula2

    OPEN_READWRITE*	    = SQLite3Dll.OPEN_READWRITE;

.. code-block:: modula2

    OPEN_CREATE* 		= SQLite3Dll.OPEN_CREATE;

.. code-block:: modula2

    OPEN_URI* 			= SQLite3Dll.OPEN_URI;

.. code-block:: modula2

    OPEN_MEMORY* 		= SQLite3Dll.OPEN_MEMORY;

.. code-block:: modula2

    TINTEGER* 			= SQLite3Dll.SQLITE_INTEGER;

.. code-block:: modula2

    TFLOAT*  			= SQLite3Dll.SQLITE_FLOAT;

.. code-block:: modula2

    TTEXT*  			= SQLite3Dll.SQLITE_TEXT;

.. code-block:: modula2

    TBLOB*  			= SQLite3Dll.SQLITE_BLOB;

.. code-block:: modula2

    TNULL*  			= SQLite3Dll.SQLITE_NULL;

.. code-block:: modula2

    ROW*                = SQLite3Dll.ROW;

.. code-block:: modula2

    DONE*				= SQLite3Dll.DONE;

Types
=====

.. code-block:: modula2

    Db* = POINTER TO DbDesc;

.. code-block:: modula2

    Stmt* = POINTER TO StmtDesc;

Procedures
==========

.. _DBSQLite3.Db.Open:

Db.Open
-------


Open a connection to a new or existing `SQLite` database
with mode defined in `Opts`. This defaults to try to create
a new database.

Return `TRUE` on success.


.. code-block:: modula2

    PROCEDURE (this : Db) Open*(filename- : ARRAY OF CHAR; Opts := OPEN_READWRITE OR OPEN_CREATE : INTEGER): BOOLEAN;

.. _DBSQLite3.Db.Close:

Db.Close
--------

 Close database 

.. code-block:: modula2

    PROCEDURE (this : Db) Close*();

.. _DBSQLite3.Db.ErrorMsg:

Db.ErrorMsg
-----------

 Return last error description from SQLite. 

.. code-block:: modula2

    PROCEDURE (this : Db) ErrorMsg*(): String.STRING;

.. _DBSQLite3.Db.Execute:

Db.Execute
----------


Directly execute sql.

Return `TRUE` on success.


.. code-block:: modula2

    PROCEDURE (this : Db) Execute*(sql- : ARRAY OF CHAR): BOOLEAN;

.. _DBSQLite3.Db.Prepare:

Db.Prepare
----------


Create a prepared sql statement for further processing.
Return `NIL` on failure.


.. code-block:: modula2

    PROCEDURE (this : Db) Prepare*(sql- : ARRAY OF CHAR): Stmt;

.. _DBSQLite3.Stmt.BindLongReal:

Stmt.BindLongReal
-----------------


Bind `LONGREAL` value to column col.
Return `TRUE` on success.


.. code-block:: modula2

    PROCEDURE (this : Stmt) BindLongReal*(col : LONGINT; value : LONGREAL): BOOLEAN;

.. _DBSQLite3.Stmt.BindInt:

Stmt.BindInt
------------


Bind `LONGINT` value to column col.
Return `TRUE` on success.


.. code-block:: modula2

    PROCEDURE (this : Stmt) BindInt*(col : LONGINT; value : LONGINT): BOOLEAN;

.. _DBSQLite3.Stmt.BindInt64:

Stmt.BindInt64
--------------


Bind `LONGLONGINT` value to column col.
Return `TRUE` on success.


.. code-block:: modula2

    PROCEDURE (this : Stmt) BindInt64*(col : LONGINT; value : LONGLONGINT): BOOLEAN;

.. _DBSQLite3.Stmt.BindText:

Stmt.BindText
-------------


Bind string value to column col.
Return `TRUE` on success.


.. code-block:: modula2

    PROCEDURE (this : Stmt) BindText*(col : LONGINT; value- : ARRAY OF CHAR): BOOLEAN;

.. _DBSQLite3.Stmt.BindNull:

Stmt.BindNull
-------------


Bind SQLite `NULL` value to column col.
Return `TRUE` on success.


.. code-block:: modula2

    PROCEDURE (this : Stmt) BindNull*(col : LONGINT): BOOLEAN;

.. _DBSQLite3.Stmt.Step:

Stmt.Step
---------


Evaluate the prepared statement and
return status.
 
 * `DONE` if finished.
 * `ROW` if further rows exists.

Any other value indicate an error.


.. code-block:: modula2

    PROCEDURE (this : Stmt) Step*(): LONGINT;

.. _DBSQLite3.Stmt.Finalize:

Stmt.Finalize
-------------

 Finalize prepared statment and release resources. 

.. code-block:: modula2

    PROCEDURE (this : Stmt) Finalize*(): BOOLEAN;

.. _DBSQLite3.Stmt.Reset:

Stmt.Reset
----------

 Reset prepared statment for further processing.

.. code-block:: modula2

    PROCEDURE (this : Stmt) Reset*(): BOOLEAN;

.. _DBSQLite3.Stmt.ColumnCount:

Stmt.ColumnCount
----------------

 Result set column count 

.. code-block:: modula2

    PROCEDURE (this : Stmt) ColumnCount*(): LONGINT;

.. _DBSQLite3.Stmt.DataCount:

Stmt.DataCount
--------------

 Result set row count 

.. code-block:: modula2

    PROCEDURE (this : Stmt) DataCount*(): LONGINT;

.. _DBSQLite3.Stmt.ColumnType:

Stmt.ColumnType
---------------


Column data type:

 * `TINTEGER`
 * `TFLOAT`
 * `TTEXT`
 * `TBLOB`
 * `TNULL`


.. code-block:: modula2

    PROCEDURE (this : Stmt) ColumnType*(col : LONGINT): LONGINT;

.. _DBSQLite3.Stmt.ColumnInt:

Stmt.ColumnInt
--------------


Return `LONGINT` in column col.

This function will try to cast the type and is
the returned value is possible undefined.


.. code-block:: modula2

    PROCEDURE (this : Stmt) ColumnInt*(col : LONGINT): LONGINT;

.. _DBSQLite3.Stmt.ColumnInt64:

Stmt.ColumnInt64
----------------


Return `LONGLONGINT` in column col.

This function will try to cast the type and is
the returned value is possible undefined.


.. code-block:: modula2

    PROCEDURE (this : Stmt) ColumnInt64*(col : LONGINT): LONGLONGINT;

.. _DBSQLite3.Stmt.ColumnLongReal:

Stmt.ColumnLongReal
-------------------


Return `LONGREAL` in column col.

This function will try to cast the type and is
the returned value is possible undefined.


.. code-block:: modula2

    PROCEDURE (this : Stmt) ColumnLongReal*(col : LONGINT): LONGREAL;

.. _DBSQLite3.Stmt.ColumnText:

Stmt.ColumnText
---------------


Return `STRING` in column col.

This function will try to cast the type and is
expected to always succed for the `STRING` type.


.. code-block:: modula2

    PROCEDURE (this : Stmt) ColumnText*(VAR str : String.STRING; col : LONGINT);


Example
=======

Basic Example
-------------

.. code-block:: modula2

    <* +MAIN *>
    MODULE SQLite3BasicExample;
    
    IMPORT SQLite3, OSStream, String;
    
    PROCEDURE Test*();
    CONST
        sql = "DROP TABLE IF EXISTS Cars;" +
            "CREATE TABLE Cars(Id INT, Name TEXT, Price INT);" +
            "INSERT INTO Cars VALUES(1, 'Audi', 52642);" +
            "INSERT INTO Cars VALUES(2, 'Mercedes', 57127);" +
            "INSERT INTO Cars VALUES(3, 'Skoda', 9000);" +
            "INSERT INTO Cars VALUES(4, 'Volvo', 29000);" +
            "INSERT INTO Cars VALUES(5, 'Bentley', 350000);" +
            "INSERT INTO Cars VALUES(6, 'Citroen', 21000);" +
            "INSERT INTO Cars VALUES(7, 'Hummer', 41400);" +
            "INSERT INTO Cars VALUES(8, 'Volkswagen', 21600);";
    VAR
        db : SQLite3.Db;
        stmt : SQLite3.Stmt;
        s : String.STRING;
        ret : BOOLEAN;

        PROCEDURE Error();
        BEGIN 
            s := db.ErrorMsg();
            OSStream.stdout.Format("Error : '%s'\n", s^);
            HALT;
        END Error;
    BEGIN
        NEW(db);
        IF ~db.Open("") THEN Error() END;
        IF ~db.Execute(sql) THEN Error() END;

        stmt := db.Prepare("SELECT * from Cars WHERE Price > ?;");
        IF stmt = NIL THEN Error() END;

        ret := stmt.BindLongReal(1, 9000.);
        IF ~ret THEN Error() END;

        OSStream.stdout.Format("ID      Name    Price  \n");
        OSStream.stdout.Format("------------------------\n");
        WHILE stmt.Step() # SQLite3.DONE DO
            stmt.ColumnText(s, 1);
            OSStream.stdout.Format("%02d % 12s % 8d\n", stmt.ColumnInt(0), s^, stmt.ColumnInt(2));
        END;
    END Test;

    BEGIN
        Test();
    END SQLite3BasicExample.

