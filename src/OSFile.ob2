(** Module for operating on OS files *)
MODULE OSFile;

IMPORT SYSTEM, DateTime, xlibOS;

(** Check if file exists *)
PROCEDURE Exists*(filename-: ARRAY OF CHAR): BOOLEAN;
BEGIN
    RETURN xlibOS.X2C_Exists(filename);
END Exists;

(** Try to delete file. Return `TRUE` on success *)
PROCEDURE Delete*(filename-: ARRAY OF CHAR): BOOLEAN;
BEGIN
    RETURN xlibOS.X2C_Remove(filename) = 0;
END Delete;

(** Try to rename file. Return `TRUE` on success *)
PROCEDURE Rename*(oldname-, newname-: ARRAY OF CHAR): BOOLEAN;
BEGIN
    RETURN xlibOS.X2C_Rename(oldname, newname) = 0;
END Rename;

(** Try to get file access time. Return `TRUE` on success *)
PROCEDURE ModifyTime*(VAR time : DateTime.DATETIME; filename-: ARRAY OF CHAR): BOOLEAN;
    VAR
        xtime: SYSTEM.CARD32;
        exists: BOOLEAN;
BEGIN
    xlibOS.X2C_ModifyTime(filename, xtime, exists);
    IF exists THEN
        time := DateTime.EncodeDate(1970, 1, 1);
        DateTime.Inc(time, DateTime.Sec, VAL(LONGINT, xtime));
    END;
    RETURN exists
END ModifyTime;

END OSFile.
