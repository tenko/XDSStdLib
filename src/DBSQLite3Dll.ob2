MODULE DBSQLite3Dll;

IMPORT SYSTEM,  dllRTS;

(* Error codes *)
CONST
    OK* 		=  0;  -- Successful result
    ERROR* 		=  1;  -- Generic error
    INTERNAL*   =  2;  -- Internal logic error in SQLite
    PERM*       =  3;  -- Access permission denied
    ABORT*      =  4;  -- Callback routine requested an abort
    BUSY*       =  5;  -- The database file is locked
    LOCKED*     =  6;  -- A table in the database is locked
    NOMEM*      =  7;  -- A malloc() failed
    READONLY*   =  8;  -- Attempt to write a readonly database
    INTERRUPT*  =  9;  -- Operation terminated by sqlite3_interrupt()
    IOERR*      = 10;  -- Some kind of disk I/O error occurred
    CORRUPT*    = 11;  -- The database disk image is malformed
    NOTFOUND*   = 12;  -- Unknown opcode in sqlite3_file_control()
    FULL*       = 13;  -- Insertion failed because database is full
    CANTOPEN*   = 14;  -- Unable to open the database file
    PROTOCOL*   = 15;  -- Database lock protocol error
    EMPTY*      = 16;  -- Internal use only
    SCHEMA*     = 17;  -- The database schema changed
    TOOBIG*     = 18;  -- String or BLOB exceeds size limit
    CONSTRAINT* = 19;  -- Abort due to constraint violation
    MISMATCH*   = 20;  -- Data type mismatch
    MISUSE*     = 21;  -- Library used incorrectly
    NOLFS*      = 22;  -- Uses OS features not supported on host
    AUTH*       = 23;  -- Authorization denied
    FORMAT*     = 24;  -- Not used
    RANGE*      = 25;  -- 2nd parameter to sqlite3_bind out of range
    NOTADB*     = 26;  -- File opened that is not a database file
    NOTICE*     = 27;  -- Notifications from sqlite3_log()
    WARNING*    = 28;  -- Warnings from sqlite3_log()
    ROW*        = 100; -- sqlite3_step() has another row ready
    DONE*       = 101; -- sqlite3_step() has finished executing

(* Open flags *) 
CONST
    OPEN_READONLY*        = 00000001h; -- Ok for sqlite3_open_v2()
    OPEN_READWRITE*       = 00000002h; -- Ok for sqlite3_open_v2()
    OPEN_CREATE*          = 00000004h; -- Ok for sqlite3_open_v2()
    OPEN_DELETEONCLOSE*   = 00000008h; -- VFS only
    OPEN_EXCLUSIVE*       = 00000010h; -- VFS only
    OPEN_AUTOPROXY*       = 00000020h; -- VFS only
    OPEN_URI*             = 00000040h; -- Ok for sqlite3_open_v2()
    OPEN_MEMORY*          = 00000080h; -- Ok for sqlite3_open_v2()
    OPEN_MAIN_DB*         = 00000100h; -- VFS only
    OPEN_TEMP_DB*         = 00000200h; -- VFS only
    OPEN_TRANSIENT_DB*    = 00000400h; -- VFS only
    OPEN_MAIN_JOURNAL*    = 00000800h; -- VFS only
    OPEN_TEMP_JOURNAL*    = 00001000h; -- VFS only
    OPEN_SUBJOURNAL*      = 00002000h; -- VFS only
    OPEN_SUPER_JOURNAL*   = 00004000h; -- VFS only
    OPEN_NOMUTEX*         = 00008000h; -- Ok for sqlite3_open_v2()
    OPEN_FULLMUTEX*       = 00010000h; -- Ok for sqlite3_open_v2()
    OPEN_SHAREDCACHE*     = 00020000h; -- Ok for sqlite3_open_v2()
    OPEN_PRIVATECACHE*    = 00040000h; -- Ok for sqlite3_open_v2()
    OPEN_WAL*             = 00080000h; -- VFS only
    OPEN_NOFOLLOW*        = 01000000h; -- Ok for sqlite3_open_v2()
    OPEN_EXRESCODE*       = 02000000h; -- Extended result codes

(* types *) 
CONST
    SQLITE_INTEGER*  	= 1;
    SQLITE_FLOAT*    	= 2;
    SQLITE_TEXT*     	= 3;
    SQLITE_BLOB*     	= 4;
    SQLITE_NULL*     	= 5;

TYPE
    DB* = POINTER TO RECORD END;
    STMT* = POINTER TO RECORD END;
    INT = SYSTEM.int;
    INT64 = SYSTEM.INT64;
    ADDRESS = SYSTEM.ADDRESS;
    PCHAR = POINTER TO ARRAY OF CHAR;
    VOID = POINTER TO RECORD END;

    sqlite3_libversion_number   = PROCEDURE ["C"] () : INT;
    sqlite3_libversion          = PROCEDURE ["C"] () : ADDRESS;
    sqlite3_errmsg              = PROCEDURE ["C"] (db : DB) : ADDRESS;
    sqlite3_errstr              = PROCEDURE ["C"] (err : INT) : ADDRESS;
    sqlite3_open                = PROCEDURE ["C"] (filename : PCHAR; VAR db : DB) : INT;
    sqlite3_open_v2             = PROCEDURE ["C"] (filename : PCHAR; VAR db : DB; flags : INT; zVfs : PCHAR) : INT;
    sqlite3_exec                = PROCEDURE ["C"] (db : DB; sql : PCHAR; callback, arg, errmsg : VOID) : INT;
    sqlite3_close               = PROCEDURE ["C"] (db : DB): INT;
    sqlite3_close_v2            = PROCEDURE ["C"] (db : DB);
    sqlite3_prepare_v2          = PROCEDURE ["C"] (db : DB; sql : PCHAR; nbyte : INT; VAR stmtref : STMT; tail : VOID) : INT;
    sqlite3_bind_double         = PROCEDURE ["C"] (stmt : STMT; col : INT; value : LONGREAL) : INT;
    sqlite3_bind_int            = PROCEDURE ["C"] (stmt : STMT; col : INT; value : INT) : INT;
    sqlite3_bind_int64          = PROCEDURE ["C"] (stmt : STMT; col : INT; value : INT64) : INT;
    sqlite3_bind_text           = PROCEDURE ["C"] (stmt : STMT; col : INT; value : PCHAR; nbyte : INT; ptr: VOID) : INT;
    sqlite3_bind_null           = PROCEDURE ["C"] (stmt : STMT; col : INT) : INT;
    sqlite3_step                = PROCEDURE ["C"] (stmt : STMT) : INT;
    sqlite3_finalize            = PROCEDURE ["C"] (stmt : STMT) : INT;
    sqlite3_reset               = PROCEDURE ["C"] (stmt : STMT) : INT;
    sqlite3_column_count        = PROCEDURE ["C"] (stmt : STMT) : INT;
    sqlite3_data_count          = PROCEDURE ["C"] (stmt : STMT) : INT;
    sqlite3_column_type         = PROCEDURE ["C"] (stmt : STMT; col : INT) : INT;
    sqlite3_column_double       = PROCEDURE ["C"] (stmt : STMT; col : INT) : LONGREAL;
    sqlite3_column_int          = PROCEDURE ["C"] (stmt : STMT; col : INT) : INT;
    sqlite3_column_int64        = PROCEDURE ["C"] (stmt : STMT; col : INT) : INT64;
    sqlite3_column_text         = PROCEDURE ["C"] (stmt : STMT; col : INT) : ADDRESS;

VAR
    libversion_number*          : sqlite3_libversion_number;
    libversion*                 : sqlite3_libversion;
    errmsg*                     : sqlite3_errmsg;
    errstr*                     : sqlite3_errstr;
    open*                       : sqlite3_open;
    open_v2*                    : sqlite3_open_v2;
    exec*                       : sqlite3_exec;
    close*                      : sqlite3_close;
    close_v2*                   : sqlite3_close_v2;
    prepare_v2*                 : sqlite3_prepare_v2;
    bind_double*                : sqlite3_bind_double;
    bind_int*                   : sqlite3_bind_int;
    bind_int64*                 : sqlite3_bind_int64;
    bind_text*                  : sqlite3_bind_text;
    bind_null*                  : sqlite3_bind_null;
    step*                       : sqlite3_step;
    finalize*                   : sqlite3_finalize;
    reset*                      : sqlite3_reset;
    column_count*               : sqlite3_column_count;
    data_count*                 : sqlite3_data_count;
    column_type*                : sqlite3_column_type;
    column_double*              : sqlite3_column_double;
    column_int*                 : sqlite3_column_int;
    column_int64*               : sqlite3_column_int64;
    column_text*                : sqlite3_column_text;

PROCEDURE CStringLength*(adr : ADDRESS): LONGINT;
VAR
    i : LONGINT;
    ch : CHAR;
BEGIN
    IF adr = NIL THEN RETURN 0 END;
    i := 0; ch := 00X;
    LOOP
        SYSTEM.MOVE(adr, SYSTEM.ADR(ch), 1);
        IF ch = 00X THEN EXIT END;
        INC(i);
        adr := SYSTEM.ADDADR(adr, 1);
    END;
    RETURN i
END CStringLength;

PROCEDURE CStringCopy*(adr : ADDRESS; VAR dst : ARRAY OF CHAR);
VAR
    i : LONGINT;
    ch : CHAR;
BEGIN
    IF adr = NIL THEN dst[0] := 00X; RETURN END;
    i := 0;
    LOOP
        SYSTEM.MOVE(adr, SYSTEM.ADR(ch), 1);
        IF ch = 00X THEN EXIT END;
        dst[i] := ch;
        INC(i);
        adr := SYSTEM.ADDADR(adr, 1);
    END;
    dst[i] := 00X;
END CStringCopy;

PROCEDURE Initialize ();
VAR
    dll : dllRTS.HMOD;
BEGIN
    <* IF env_target = "x86nt" THEN *>
    dll := dllRTS.LoadModule("sqlite3.dll");
    <* ELSIF env_target = 'x86linux' THEN *>
    dll := dllRTS.LoadModule("sqlite3.so");
    <* ELSE *>
    *** OS NOT SUPPORTED ***
    <* END *>
    IF dll #  dllRTS.InvalidHandle THEN
        libversion_number   := SYSTEM.VAL(sqlite3_libversion_number,    dllRTS.GetProcAdr(dll, "sqlite3_libversion_number"));
        libversion          := SYSTEM.VAL(sqlite3_libversion,           dllRTS.GetProcAdr(dll, "sqlite3_libversion"));
        libversion          := SYSTEM.VAL(sqlite3_libversion,           dllRTS.GetProcAdr(dll, "sqlite3_libversion"));
        errmsg              := SYSTEM.VAL(sqlite3_errmsg,               dllRTS.GetProcAdr(dll, "sqlite3_errmsg"));
        errstr              := SYSTEM.VAL(sqlite3_errstr,               dllRTS.GetProcAdr(dll, "sqlite3_errstr"));
        open                := SYSTEM.VAL(sqlite3_open,                 dllRTS.GetProcAdr(dll, "sqlite3_open"));
        open_v2             := SYSTEM.VAL(sqlite3_open_v2,              dllRTS.GetProcAdr(dll, "sqlite3_open_v2"));
        exec                := SYSTEM.VAL(sqlite3_exec,                 dllRTS.GetProcAdr(dll, "sqlite3_exec"));
        close               := SYSTEM.VAL(sqlite3_close,                dllRTS.GetProcAdr(dll, "sqlite3_close"));
        close_v2            := SYSTEM.VAL(sqlite3_close_v2,             dllRTS.GetProcAdr(dll, "sqlite3_close_v2"));
        prepare_v2          := SYSTEM.VAL(sqlite3_prepare_v2,           dllRTS.GetProcAdr(dll, "sqlite3_prepare_v2"));
        bind_double         := SYSTEM.VAL(sqlite3_bind_double,          dllRTS.GetProcAdr(dll, "sqlite3_bind_double"));
        bind_int            := SYSTEM.VAL(sqlite3_bind_int,             dllRTS.GetProcAdr(dll, "sqlite3_bind_int"));
        bind_int64          := SYSTEM.VAL(sqlite3_bind_int64,           dllRTS.GetProcAdr(dll, "sqlite3_bind_int64"));
        bind_text           := SYSTEM.VAL(sqlite3_bind_text,            dllRTS.GetProcAdr(dll, "sqlite3_bind_text"));
        bind_null           := SYSTEM.VAL(sqlite3_bind_null,            dllRTS.GetProcAdr(dll, "sqlite3_bind_null"));
        step                := SYSTEM.VAL(sqlite3_step,                 dllRTS.GetProcAdr(dll, "sqlite3_step"));
        finalize            := SYSTEM.VAL(sqlite3_finalize,             dllRTS.GetProcAdr(dll, "sqlite3_finalize"));
        reset               := SYSTEM.VAL(sqlite3_reset,                dllRTS.GetProcAdr(dll, "sqlite3_reset"));
        column_count        := SYSTEM.VAL(sqlite3_column_count,         dllRTS.GetProcAdr(dll, "sqlite3_column_count"));
        data_count          := SYSTEM.VAL(sqlite3_data_count,           dllRTS.GetProcAdr(dll, "sqlite3_data_count"));
        column_type         := SYSTEM.VAL(sqlite3_column_type,          dllRTS.GetProcAdr(dll, "sqlite3_column_type"));
        column_double       := SYSTEM.VAL(sqlite3_column_double,        dllRTS.GetProcAdr(dll, "sqlite3_column_double"));
        column_int          := SYSTEM.VAL(sqlite3_column_int,           dllRTS.GetProcAdr(dll, "sqlite3_column_int"));
        column_int64        := SYSTEM.VAL(sqlite3_column_int64,         dllRTS.GetProcAdr(dll, "sqlite3_column_int64"));
        column_text         := SYSTEM.VAL(sqlite3_column_text,          dllRTS.GetProcAdr(dll, "sqlite3_column_text"));
    ELSE
        libversion_number           := NIL;
        libversion                  := NIL;
        errmsg                      := NIL;
        errstr                      := NIL;
        open                        := NIL;
        open_v2                     := NIL;
        exec                        := NIL;
        close                       := NIL;
        close_v2                    := NIL;
        prepare_v2                  := NIL;
        bind_double                 := NIL;
        bind_int                    := NIL;
        bind_int64                  := NIL;
        bind_text                   := NIL;
        bind_null                   := NIL;
        step                        := NIL;
        finalize                    := NIL;
        reset                       := NIL;
        column_count                := NIL;
        data_count                  := NIL;
        column_type                 := NIL;
        column_double               := NIL;
        column_int                  := NIL;
        column_int64                := NIL;
        column_text                 := NIL;
    END;
END Initialize;
BEGIN
    Initialize();
END DBSQLite3Dll.