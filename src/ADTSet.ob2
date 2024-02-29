(**
Set which s a hash table for values based on :ref:`ADTDictionary`

Two set types are implemented
 * `SetInt` (`LONGINT` value)
 * `SetStr` (`STRING` value)

Other types can be implemented by method of type
extension. Note that this solution comes with a
overhead (~2x) and if speed is needed it should be
implemented as stand alone.

Adapted from Ben Hoyt article about hash tables. License is MIT.
*)
MODULE ADTSet;

IMPORT SYSTEM, D := ADTDictionary, S := String, Str := ArrayOfChar,
       Vector := ADTVector, Word, Type;

TYPE
    CARD32 = Type.CARD32;

    (** Integer entry *)
    IntEntry* = POINTER TO IntEntryDesc;
    IntEntryDesc = RECORD(D.DictionaryEntryDesc)
        value : LONGINT;
    END;

    (** Integer value set *)
    SetInt* = POINTER TO SetIntDesc;
    SetIntDesc = RECORD (D.DictionaryDesc) END;

    (** Integer value set iterator *)
    SetIntIterator* = POINTER TO SetIntIteratorDesc;
    SetIntIteratorDesc = RECORD(D.DictionaryIteratorDesc) END;

    (** String entry *)
    StrEntry* = POINTER TO StrEntryDesc;
    StrEntryDesc = RECORD(D.DictionaryEntryDesc)
        value : S.STRING;
    END;

    (** String value set *)
    SetStr* = POINTER TO SetStrDesc;
    SetStrDesc = RECORD (D.DictionaryDesc) END;

    (** String value set iterator *)
    SetStrIterator* = POINTER TO SetStrIteratorDesc;
    SetStrIteratorDesc = RECORD(D.DictionaryIteratorDesc) END;

--
-- SetInt (Integer value)
--

(** Calculate hash value *)
PROCEDURE (this : SetInt) EntryHash(VAR entry : D.DictionaryEntryDesc): CARD32;
BEGIN
    <* PUSH *>
    <* CHECKRANGE- *>
    RETURN Word.Hash(VAL(CARD32, entry(IntEntryDesc).value));
    <* POP *>
END EntryHash;

(** Compare *)
PROCEDURE (this : SetInt) EntryEqual(VAR left: D.DictionaryEntryDesc; VAR right : D.DictionaryEntryDesc): BOOLEAN;
BEGIN RETURN left(IntEntryDesc).value = right(IntEntryDesc).value ;
END EntryEqual;

(** New Entry *)
PROCEDURE (this : SetInt) EntryNew(VAR dst : D.DictionaryEntry);
    VAR entry : IntEntry;
BEGIN
    NEW(entry);
    dst := entry;
END EntryNew;

(** Assign Entry src to dst *)
PROCEDURE (this : SetInt) EntryAssign(VAR dst : D.DictionaryEntryDesc; VAR src : D.DictionaryEntryDesc);
BEGIN
    dst(IntEntryDesc).value := src(IntEntryDesc).value;
    dst(IntEntryDesc).deleted := FALSE;
END EntryAssign;

(** Return TRUE if set has given value *)
PROCEDURE (this : SetInt) In*(value : LONGINT): BOOLEAN;
    VAR entry : IntEntryDesc;
BEGIN
    entry.value := value;
    RETURN this.IHasKey(entry);
END In;

(** Add value to set *)
PROCEDURE (this : SetInt) Add*(value : LONGINT): BOOLEAN;
    VAR entry : IntEntryDesc;
BEGIN
    entry.value := value;
    RETURN this.ISet(entry);
END Add;

(** Mark entry as deleted. Return TRUE if entry exists *)
PROCEDURE (this : SetInt) Remove*(value : LONGINT): BOOLEAN;
    VAR entry : IntEntryDesc;
BEGIN
    entry.value := value;
    RETURN this.IDeleteEntry(entry);
END Remove;

(** Get set iterator *)
PROCEDURE (this : SetInt) Iterator*(): SetIntIterator;
    VAR ret : SetIntIterator;
BEGIN
    NEW(ret);
    ret.dictionary := this;
    ret.index := 0;
    RETURN ret
END Iterator;

(** Get current iterator entry's value *)
PROCEDURE (this : SetIntIterator) Value*(): LONGINT;
BEGIN
    RETURN this.entry(IntEntry).value;
END Value;

(** Return Vector of values *)
PROCEDURE (this : SetInt) Values*(): Vector.VectorOfLongInt;
    VAR
        it : SetIntIterator;
        ret : Vector.VectorOfLongInt;
BEGIN
    NEW(ret);
    ret.Init();
    it := this.Iterator();
    WHILE it.Next() DO ret.Append(it.Value()) END;
    RETURN ret
END Values;

--
-- SetStr (String value)
--

(** Calculate hash value *)
PROCEDURE (this : SetStr) EntryHash(VAR entry : D.DictionaryEntryDesc): CARD32;
BEGIN
    RETURN Str.Hash(entry(StrEntryDesc).value^);
END EntryHash;

(** Compare *)
PROCEDURE (this : SetStr) EntryEqual(VAR left: D.DictionaryEntryDesc; VAR right : D.DictionaryEntryDesc): BOOLEAN;
BEGIN RETURN Str.Compare(left(StrEntryDesc).value^, right(StrEntryDesc).value^) = 0;
END EntryEqual;

(** New Entry *)
PROCEDURE (this : SetStr) EntryNew(VAR dst : D.DictionaryEntry);
    VAR entry : StrEntry;
BEGIN
    NEW(entry);
    dst := entry;
END EntryNew;

(** Assign Entry src to dst *)
PROCEDURE (this : SetStr) EntryAssign(VAR dst : D.DictionaryEntryDesc; VAR src : D.DictionaryEntryDesc);
BEGIN
    dst(StrEntryDesc).value := src(StrEntryDesc).value;
END EntryAssign;

(** Return TRUE if set has given value *)
PROCEDURE (this : SetStr) In*(value : ARRAY OF CHAR): BOOLEAN;
    VAR entry : StrEntryDesc;
BEGIN
    S.Assign(entry.value, value);
    RETURN this.IHasKey(entry);
END In;

(** Add value to set *)
PROCEDURE (this : SetStr) Add*(value : ARRAY OF CHAR): BOOLEAN;
    VAR entry : StrEntryDesc;
BEGIN
    S.Assign(entry.value, value);
    RETURN this.ISet(entry);
END Add;

(** Mark entry as deleted. Return TRUE if entry exists *)
PROCEDURE (this : SetStr) Remove*(value : ARRAY OF CHAR): BOOLEAN;
    VAR entry : StrEntryDesc;
BEGIN
    S.Assign(entry.value, value);
    RETURN this.IDeleteEntry(entry);
END Remove;

(** Get set iterator *)
PROCEDURE (this : SetStr) Iterator*(): SetStrIterator;
    VAR ret : SetStrIterator;
BEGIN
    NEW(ret);
    ret.dictionary := this;
    ret.index := 0;
    RETURN ret
END Iterator;

(** Get current iterator entry's value *)
PROCEDURE (this : SetStrIterator) Value*(): S.STRING;
BEGIN
    RETURN this.entry(StrEntry).value;
END Value;

(** Return Vector of values *)
PROCEDURE (this : SetStr) Values*(): Vector.VectorOfString;
    VAR
        it : SetStrIterator;
        ret : Vector.VectorOfString;
BEGIN
    NEW(ret);
    ret.Init();
    it := this.Iterator();
    WHILE it.Next() DO ret.Append(it.Value()^) END;
    RETURN ret
END Values;

END ADTSet.