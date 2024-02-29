(**
Module with object oriented access to a `SQLite` database.

The class will automatic release any resources when garbage collected.
*)
MODULE DBSQLite3;

IMPORT SYSTEM, String, oberonRTS, SQLite3Dll := DBSQLite3Dll;

CONST
    OPEN_READONLY* 	    = SQLite3Dll.OPEN_READONLY;
    OPEN_READWRITE*	    = SQLite3Dll.OPEN_READWRITE;
    OPEN_CREATE* 		= SQLite3Dll.OPEN_CREATE;
    OPEN_URI* 			= SQLite3Dll.OPEN_URI;
    OPEN_MEMORY* 		= SQLite3Dll.OPEN_MEMORY;
    TINTEGER* 			= SQLite3Dll.SQLITE_INTEGER;
    TFLOAT*  			= SQLite3Dll.SQLITE_FLOAT;
    TTEXT*  			= SQLite3Dll.SQLITE_TEXT;
    TBLOB*  			= SQLite3Dll.SQLITE_BLOB;
    TNULL*  			= SQLite3Dll.SQLITE_NULL;
    ROW*                = SQLite3Dll.ROW;
    DONE*				= SQLite3Dll.DONE;

TYPE
    Db* = POINTER TO DbDesc;
    DbDesc = RECORD
        db : SQLite3Dll.DB;
    END;

    Stmt* = POINTER TO StmtDesc;
    StmtDesc = RECORD
        db : Db;
        stmt : SQLite3Dll.STMT;
    END;

PROCEDURE Finalize(adr : SYSTEM.ADDRESS);
    VAR
        this : Db;
        ret : SYSTEM.int;
BEGIN 
    this := SYSTEM.VAL(Db, adr);
    SQLite3Dll.close_v2(this.db);
END Finalize;

(**
Open a connection to a new or existing `SQLite` database
with mode defined in `Opts`. This defaults to try to create
a new database.

Return `TRUE` on success.
*)
PROCEDURE (this : Db) Open*(filename- : ARRAY OF CHAR; Opts := OPEN_READWRITE OR OPEN_CREATE : INTEGER): BOOLEAN;
    VAR ret : SYSTEM.int;
BEGIN
    IF (this.db # NIL) OR (SQLite3Dll.open_v2 = NIL) THEN RETURN FALSE END;
    IF LENGTH(filename) = 0 THEN
         ret := SQLite3Dll.open_v2(NIL, this.db, Opts, NIL)
    ELSE
        ret := SQLite3Dll.open_v2(filename, this.db, Opts, NIL);
    END;
    IF ret = SQLite3Dll.OK THEN oberonRTS.InstallFinalizer(Finalize, this) END;
    RETURN ret = SQLite3Dll.OK;
END Open;

(** Close database *)
PROCEDURE (this : Db) Close*();
BEGIN
    IF SQLite3Dll.close(this.db) = SQLite3Dll.OK THEN this.db := NIL END;
END Close;

(** Return last error description from SQLite. *)
PROCEDURE (this : Db) ErrorMsg*(): String.STRING;
    VAR
        adr : SYSTEM.ADDRESS;
        ret : String.STRING;
BEGIN
    IF SQLite3Dll.errmsg = NIL THEN String.Assign(ret, "sqlite.dll not loaded"); RETURN ret END;
    IF this.db = NIL THEN String.Assign(ret, "database not open"); RETURN ret END;
    adr := SQLite3Dll.errmsg(this.db);
    String.Reserve(ret, SQLite3Dll.CStringLength(adr) + 1);
    SQLite3Dll.CStringCopy(adr, ret^);
    RETURN ret
END ErrorMsg;

(**
Directly execute sql.

Return `TRUE` on success.
*)
PROCEDURE (this : Db) Execute*(sql- : ARRAY OF CHAR): BOOLEAN;
    VAR ret : SYSTEM.int;
BEGIN
    IF (this.db = NIL) OR (SQLite3Dll.exec = NIL) THEN RETURN FALSE END;
    ret := SQLite3Dll.exec(this.db, sql, NIL, NIL, NIL);
    RETURN ret = SQLite3Dll.OK;
END Execute;

PROCEDURE FinalizeStmt(adr : SYSTEM.ADDRESS);
    VAR
        this : Stmt;
        ret : SYSTEM.int;
BEGIN 
    this := SYSTEM.VAL(Stmt, adr);
    IF this.stmt = NIL THEN RETURN END;
    ret := SQLite3Dll.finalize(this.stmt); 
END FinalizeStmt;

(**
Create a prepared sql statement for further processing.
Return `NIL` on failure.
*)
PROCEDURE (this : Db) Prepare*(sql- : ARRAY OF CHAR): Stmt;
    VAR
        ret : Stmt;
        stmt : SQLite3Dll.STMT;
        res : SYSTEM.int;
BEGIN
    IF (this.db = NIL) OR (SQLite3Dll.prepare_v2 = NIL) THEN RETURN NIL END;
    res := SQLite3Dll.prepare_v2(this.db, sql,  -1,  stmt, NIL);
    IF res # SQLite3Dll.OK THEN RETURN NIL END;
    NEW(ret);
    ret.db := this;
    ret.stmt := stmt;
    oberonRTS.InstallFinalizer(FinalizeStmt, ret);
    RETURN ret;
END Prepare;

(**
Bind `LONGREAL` value to column col.
Return `TRUE` on success.
*)
PROCEDURE (this : Stmt) BindLongReal*(col : LONGINT; value : LONGREAL): BOOLEAN;
    VAR ret : SYSTEM.int;
BEGIN
    IF this.stmt = NIL THEN RETURN FALSE END;
    ret := SQLite3Dll.bind_double(this.stmt, col, value);
    RETURN ret = SQLite3Dll.OK;
END BindLongReal;

(**
Bind `LONGINT` value to column col.
Return `TRUE` on success.
*)
PROCEDURE (this : Stmt) BindInt*(col : LONGINT; value : LONGINT): BOOLEAN;
    VAR ret : SYSTEM.int;
BEGIN
    IF this.stmt = NIL THEN RETURN FALSE END;
    ret := SQLite3Dll.bind_int(this.stmt, col, value);
    RETURN ret = SQLite3Dll.OK;
END BindInt;

(**
Bind `LONGLONGINT` value to column col.
Return `TRUE` on success.
*)
PROCEDURE (this : Stmt) BindInt64*(col : LONGINT; value : LONGLONGINT): BOOLEAN;
    VAR ret : SYSTEM.int;
BEGIN
    IF this.stmt = NIL THEN RETURN FALSE END;
    ret := SQLite3Dll.bind_int64(this.stmt, col, value);
    RETURN ret = SQLite3Dll.OK;
END BindInt64;

(**
Bind string value to column col.
Return `TRUE` on success.
*)
PROCEDURE (this : Stmt) BindText*(col : LONGINT; value- : ARRAY OF CHAR): BOOLEAN;
    VAR ret : SYSTEM.int;
BEGIN
    IF this.stmt = NIL THEN RETURN FALSE END;
    ret := SQLite3Dll.bind_text(this.stmt, col, value, -1, NIL);
    RETURN ret = SQLite3Dll.OK;
END BindText;

(**
Bind SQLite `NULL` value to column col.
Return `TRUE` on success.
*)
PROCEDURE (this : Stmt) BindNull*(col : LONGINT): BOOLEAN;
    VAR ret : SYSTEM.int;
BEGIN
    IF this.stmt = NIL THEN RETURN FALSE END;
    ret := SQLite3Dll.bind_null(this.stmt, col);
    RETURN ret = SQLite3Dll.OK;
END BindNull;

(**
Evaluate the prepared statement and
return status.
 
 * `DONE` if finished.
 * `ROW` if further rows exists.

Any other value indicate an error.
*)
PROCEDURE (this : Stmt) Step*(): LONGINT;
    VAR ret : SYSTEM.int;
BEGIN
    IF this.stmt = NIL THEN RETURN 1 END;
    RETURN SQLite3Dll.step(this.stmt);
END Step;

(** Finalize prepared statment and release resources. *)
PROCEDURE (this : Stmt) Finalize*(): BOOLEAN;
    VAR ret : SYSTEM.int;
BEGIN
    IF this.stmt = NIL THEN RETURN FALSE END;
    ret := SQLite3Dll.finalize(this.stmt);
    RETURN ret = SQLite3Dll.OK;
END Finalize;

(** Reset prepared statment for further processing.*)
PROCEDURE (this : Stmt) Reset*(): BOOLEAN;
    VAR ret : SYSTEM.int;
BEGIN
    IF this.stmt = NIL THEN RETURN FALSE END;
    ret := SQLite3Dll.reset(this.stmt);
    RETURN ret = SQLite3Dll.OK;
END Reset;

(** Result set column count *)
PROCEDURE (this : Stmt) ColumnCount*(): LONGINT;
BEGIN
    IF this.stmt = NIL THEN RETURN 0 END;
    RETURN SQLite3Dll.column_count(this.stmt);
END ColumnCount;

(** Result set row count *)
PROCEDURE (this : Stmt) DataCount*(): LONGINT;
BEGIN
    IF this.stmt = NIL THEN RETURN 0 END;
    RETURN SQLite3Dll.data_count(this.stmt);
END DataCount;

(**
Column data type:

 * `TINTEGER`
 * `TFLOAT`
 * `TTEXT`
 * `TBLOB`
 * `TNULL`
*)
PROCEDURE (this : Stmt) ColumnType*(col : LONGINT): LONGINT;
BEGIN
    IF this.stmt = NIL THEN RETURN 0 END;
    RETURN SQLite3Dll.column_type(this.stmt, col);
END ColumnType;

(**
Return `LONGINT` in column col.

This function will try to cast the type and is
the returned value is possible undefined.
*)
PROCEDURE (this : Stmt) ColumnInt*(col : LONGINT): LONGINT;
BEGIN
    IF this.stmt = NIL THEN RETURN 0 END;
    RETURN SQLite3Dll.column_int(this.stmt, col);
END ColumnInt;

(**
Return `LONGLONGINT` in column col.

This function will try to cast the type and is
the returned value is possible undefined.
*)
PROCEDURE (this : Stmt) ColumnInt64*(col : LONGINT): LONGLONGINT;
BEGIN
    IF this.stmt = NIL THEN RETURN 0 END;
    RETURN SQLite3Dll.column_int64(this.stmt, col);
END ColumnInt64;

(**
Return `LONGREAL` in column col.

This function will try to cast the type and is
the returned value is possible undefined.
*)
PROCEDURE (this : Stmt) ColumnLongReal*(col : LONGINT): LONGREAL;
BEGIN
    IF this.stmt = NIL THEN RETURN 0 END;
    RETURN SQLite3Dll.column_double(this.stmt, col);
END ColumnLongReal;

(**
Return `STRING` in column col.

This function will try to cast the type and is
expected to always succed for the `STRING` type.
*)
PROCEDURE (this : Stmt) ColumnText*(VAR str : String.STRING; col : LONGINT);
   VAR  adr : SYSTEM.ADDRESS;
BEGIN
    IF this.stmt = NIL THEN RETURN END;
    adr := SQLite3Dll.column_text(this.stmt, col);
    String.Reserve(str, SQLite3Dll.CStringLength(adr) + 1);
    SQLite3Dll.CStringCopy(adr, str^);
END ColumnText;

END DBSQLite3.

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