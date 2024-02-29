(** Module for operating on OS directories *)
MODULE OSDir;

IMPORT SYSTEM, xlibOS, String;

TYPE
    Dir* = RECORD
        dir : xlibOS.X2C_Dir;
    END;

(** Open directory listing *)
PROCEDURE (VAR d : Dir) Open*(name- : ARRAY OF CHAR);
BEGIN
    IF name = "" THEN xlibOS.X2C_DirOpen(d.dir, "*.*")
    ELSE xlibOS.X2C_DirOpen(d.dir, name) END;
END Open;

(** Close directory listing *)
PROCEDURE (VAR d : Dir) Close*();
BEGIN
    xlibOS.X2C_DirClose(d.dir);
END Close;

(** Advance to next item in directory listing *)
PROCEDURE (VAR d : Dir) Next*();
BEGIN
    xlibOS.X2C_DirNext(d.dir);
END Next;

(** Entry name *)
PROCEDURE (VAR d : Dir) Name*(VAR name : String.STRING);
BEGIN
    String.Reserve(name, d.dir.namelen + 1, FALSE);
    xlibOS.X2C_DirGetName(d.dir, name^, LEN(name^));
END Name;

(** End of directory listing *)
PROCEDURE (VAR d : Dir) IsDone*() : BOOLEAN;
BEGIN
    RETURN ~d.dir.done;
END IsDone;

(** Entry is file? *)
PROCEDURE (VAR d : Dir) IsFile*() : BOOLEAN;
BEGIN
    RETURN ~d.dir.is_dir;
END IsFile;

(** Get current directory name *)
PROCEDURE Current*(VAR name : String.STRING);
BEGIN
    String.Reserve(name, xlibOS.X2C_GetCDNameLength() + 1, FALSE);
    xlibOS.X2C_GetCDName(name^, LEN(name^))
END Current;

(** Set current directory name *)
PROCEDURE SetCurrent*(name- : ARRAY OF CHAR): BOOLEAN;
BEGIN
    RETURN xlibOS.X2C_SetCD(name)
END SetCurrent;

(** Try to create directory. Return `TRUE` on success *)
PROCEDURE Create*(filename-: ARRAY OF CHAR): BOOLEAN;
BEGIN
    RETURN xlibOS.X2C_CreateDirectory(filename);
END Create;

(** Try to delete directory. Return `TRUE` on success *)
PROCEDURE Delete*(filename-: ARRAY OF CHAR): BOOLEAN;
BEGIN
    RETURN xlibOS.X2C_RemoveDirectory(filename);
END Delete;

END OSDir.