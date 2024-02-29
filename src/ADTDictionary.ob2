(**
Dictionary which implementes an extensible hash table.

Two types are implemented
 * `DictionaryStrInt` (`STRING` key and `LONGINT` value)
 * `DictionaryStrStr` (`STRING` key and `STRING` value)

Other types can be implemented by method of type
extension. Note that this solution comes with a
overhead (~2x) and if speed is needed it should be
implemented as stand alone.

Adapted from `Ben Hoyt` article about hash tables. License is `MIT`.
*)
MODULE ADTDictionary;

IMPORT SYSTEM, S := String, Str := ArrayOfChar, Vector := ADTVector, Type;

CONST
    INITIAL_CAPACITY* = 32;

TYPE
    CARD32 = Type.CARD32;

    (** Abstract dictionary class *)
    DictionaryEntry* = POINTER TO DictionaryEntryDesc;
    DictionaryEntryDesc* = RECORD
        deleted* : BOOLEAN;
    END;
    DictionaryEntryStorage* = POINTER TO ARRAY OF DictionaryEntry;
    Dictionary* = POINTER TO DictionaryDesc;
    DictionaryDesc* = RECORD
        storage : DictionaryEntryStorage;
        capacity : LONGINT;
        size : LONGINT;
    END;

    (** Abstract dictionary iterator class *)
    DictionaryIterator* = POINTER TO DictionaryIteratorDesc;
    DictionaryIteratorDesc* = RECORD
        dictionary* : Dictionary;
        entry* : DictionaryEntry;
        index* : LONGINT;
    END;

    (** String key and integer value  entry *)
    StringIntEntry* = POINTER TO StringIntEntryDesc;
    StringIntEntryDesc = RECORD(DictionaryEntryDesc)
        key* : S.STRING;
        value* : LONGINT;
    END;

    (** String key and integer value dictionary *)
    DictionaryStrInt* = POINTER TO DictionaryStrIntDesc;
    DictionaryStrIntDesc = RECORD (DictionaryDesc) END;

    (** String key and integer value iterator *)
    DictionaryStrIntIterator* = POINTER TO DictionaryStrIntIteratorDesc;
    DictionaryStrIntIteratorDesc = RECORD(DictionaryIteratorDesc) END;

    (** String key and String value  entry *)
    StrStrEntry* = POINTER TO StrStrEntryDesc;
    StrStrEntryDesc = RECORD(DictionaryEntryDesc)
        key* : S.STRING;
        value* : S.STRING;
    END;

    (** String key and String value dictionary *)
    DictionaryStrStr* = POINTER TO DictionaryStrStrDesc;
    DictionaryStrStrDesc = RECORD (DictionaryDesc) END;

    (** String key and String value iterator *)
    DictionaryStrStrIterator* = POINTER TO DictionaryStrStrIteratorDesc;
    DictionaryStrStrIteratorDesc = RECORD(DictionaryIteratorDesc) END;

(* http://graphics.stanford.edu/~seander/bithacks.html#RoundUpPowerOf2Float *)
PROCEDURE RoundUpPow2(value : LONGINT): LONGINT;
    VAR v : CARD32;
BEGIN
    value := VAL(CARD32, value - 1);
    value := value OR (value >> 1);
    value := value OR (value >> 2);
    value := value OR (value >> 4);
    value := value OR (value >> 8);
    value := value OR (value >> 8);
    RETURN VAL(LONGINT, value + 1)
END RoundUpPow2;

(**
Initialize dictionary storage to given capacity. Default to `INITIAL_CAPACITY`.
Capacity will be rounded up to nearest exponent of 2 size, 64, 256, 512 etc. 
*)
PROCEDURE (this : Dictionary) Init*(capacity := INITIAL_CAPACITY : LONGINT);
    VAR
        storage : DictionaryEntryStorage;
BEGIN
    IF capacity < 2 THEN capacity := 2 END;
    capacity := RoundUpPow2(capacity);
    NEW(storage, capacity);
    this.storage := storage;
    this.size := 0;
    this.capacity := capacity;
END Init;

(**
Compare dictionary entries.
Abstract method which must be implemented in subclass.
*)
PROCEDURE (this : Dictionary) EntryEqual(VAR left : DictionaryEntryDesc; VAR right : DictionaryEntryDesc): BOOLEAN;
BEGIN RETURN FALSE
END EntryEqual;

(**
Compute hash value of entry key.
Abstract method which must be implemented in subclass.
*)
PROCEDURE (this : Dictionary) EntryHash(VAR entry : DictionaryEntryDesc): CARD32;
BEGIN RETURN 0
END EntryHash;

(**
New Entry
Abstract method which must be implemented in subclass.
*)
PROCEDURE (this : Dictionary) EntryNew(VAR dst : DictionaryEntry);
BEGIN END EntryNew;

(**
Assign Entry `src` to `dst`.
Abstract method which must be implemented in subclass.
*)
PROCEDURE (this : Dictionary) EntryAssign(VAR dst : DictionaryEntryDesc; VAR src : DictionaryEntryDesc);
BEGIN END EntryAssign;

(**
Internal HasKey method.
Implemented with concrete entry types in subclass.
*)
PROCEDURE (this : Dictionary) IHasKey*(VAR entry : DictionaryEntryDesc): BOOLEAN;
    VAR
        current : DictionaryEntry;
        index, hash : CARD32;
BEGIN
    hash := this.EntryHash(entry);
    index := hash AND (VAL(CARD32, this.capacity) - 1);
    LOOP
        current := this.storage[index];
        IF (current = NIL) THEN EXIT END;
        IF ~current.deleted THEN
            IF this.EntryEqual(entry, current^) THEN RETURN TRUE END
        END;
        index := (index + 1) AND (VAL(CARD32, this.capacity) - 1);
    END;
    RETURN FALSE;
END IHasKey;

(**
Internal get method.
Implemented with concrete entry types in subclass.
*)
PROCEDURE (this : Dictionary) IGet*(VAR entry : DictionaryEntryDesc): BOOLEAN;
    VAR
        current : DictionaryEntry;
        index, hash : CARD32;
BEGIN
    hash := this.EntryHash(entry);
    index := hash AND (VAL(CARD32, this.capacity) - 1);
    LOOP
        current := this.storage[index];
        IF (current = NIL) THEN EXIT END;
        IF ~current.deleted THEN
            IF this.EntryEqual(entry, current^) THEN
                this.EntryAssign(entry, current^);
                RETURN TRUE
            END
        END;
        index := (index + 1) AND (VAL(CARD32, this.capacity) - 1);
    END;
    RETURN FALSE;
END IGet;

(** Internal method to set entry *)
PROCEDURE (this : Dictionary) ISetEntry(VAR entry : DictionaryEntryDesc; duplicates := TRUE : BOOLEAN);
    VAR
        index, deleted, hash : CARD32;
        current : DictionaryEntry;
BEGIN
    deleted := MAX(CARD32);
    hash := this.EntryHash(entry);
    index := hash AND (VAL(CARD32, this.capacity) - 1);
    LOOP
        current := this.storage[index];
        IF (current = NIL) THEN
            IF deleted # MAX(CARD32) THEN index := deleted END;
            EXIT
        END;
        IF current.deleted THEN
            IF deleted = MAX(CARD32) THEN deleted := index END;
        ELSIF duplicates & this.EntryEqual(entry, this.storage[index]^) THEN
            (* Entry exists. Update and return *)
            this.EntryAssign(current^, entry);
            RETURN
        END;
        index := (index + 1) AND (VAL(CARD32, this.capacity) - 1);
    END;
    INC(this.size);
    IF deleted = MAX(CARD32) THEN this.EntryNew(this.storage[index])
    ELSE this.storage[index].deleted := FALSE END;
    this.EntryAssign(this.storage[index]^, entry)
END ISetEntry;

(** Clear entries without deallocation *)
PROCEDURE (this : Dictionary) Clear*();
    VAR i : LONGINT;
BEGIN
    FOR i := 0 TO this.capacity - 1 DO
        IF this.storage[i] # NIL THEN this.storage[i].deleted := TRUE END
    END;
    this.size := 0
END Clear;

(** Resize dictionary storage. Called automatic *)
PROCEDURE (this : Dictionary) Resize(capacity : LONGINT): BOOLEAN;
    VAR
        storage : DictionaryEntryStorage;
        current : DictionaryEntry;
        i, len : LONGINT;
BEGIN
    IF capacity < 2 THEN capacity := 2 END;
    capacity := RoundUpPow2(capacity);
    storage := this.storage;
    NEW(this.storage, capacity);
    IF this.storage = NIL THEN RETURN FALSE END;
    len := this.capacity;
    this.size := 0;
    this.capacity := capacity;
    FOR i := 0 TO len - 1 DO
        current := storage[i];
        IF (current # NIL) THEN
            IF ~current.deleted THEN
                this.ISetEntry(current^, FALSE)
            END;
        END;
    END;
    RETURN TRUE;
END Resize;

(**
Internal set method.
Implemented with concrete entry types in subclass.
*)
PROCEDURE (this : Dictionary) ISet*(VAR entry : DictionaryEntryDesc): BOOLEAN;
BEGIN
    (* Expand size of load factor is >= 0.75 *)
    IF this.size >= (this.capacity DIV 2 + this.capacity DIV 4) THEN
        IF ~this.Resize(this.capacity * 2) THEN RETURN FALSE END;
    END;
    this.ISetEntry(entry);
    RETURN TRUE;
END ISet;

(**
Internal delete method.
Implemented with concrete entry types in subclass.
https://en.wikipedia.org/wiki/Linear_probing#Deletion
*)
PROCEDURE (this : Dictionary) IDeleteEntry*(VAR entry : DictionaryEntryDesc): BOOLEAN;
    VAR
        current : DictionaryEntry;
        i, j, k, hash : CARD32;
BEGIN
    hash := this.EntryHash(entry);
    i := hash AND (VAL(CARD32, this.capacity) - 1);
    LOOP
        current := this.storage[i];
        IF (current = NIL) THEN RETURN FALSE END;
        IF ~current.deleted THEN
            IF this.EntryEqual(entry, current^) THEN
                EXIT
            END
        END;
        i := (i + 1) AND (VAL(CARD32, this.capacity) - 1)
    END;
    j := i;
    LOOP (* Possible shift entries back to earlier deleted position if we have a hash collision *)
        j := (j + 1) AND (VAL(CARD32, this.capacity) - 1);
        current := this.storage[j];
        IF (current = NIL) THEN EXIT END;
        hash := this.EntryHash(current^);
        k := hash AND (VAL(CARD32, this.capacity) - 1);
        IF ((j > i) & ((k <= i) OR (k > j))) OR ((j < i) & ((k <= i) & (k > j))) THEN
           this.storage[i] := this.storage[j];
           i := j;
        END;
    END;
    DEC(this.size);
    this.storage[i].deleted := TRUE;
    IF this.size <= this.capacity DIV 10 THEN (* Resize if loadfactor is 0.1 or less *)
        IF ~this.Resize(this.capacity DIV 2) THEN RETURN FALSE END;
    END;
    RETURN TRUE;
END IDeleteEntry;

(** Advance iterator. Return `FALSE` if end is reached. *)
PROCEDURE (this : DictionaryIterator) Next*() : BOOLEAN;
    VAR
        entry : DictionaryEntry;
        i : LONGINT;
BEGIN
    WHILE this.index < this.dictionary.capacity DO
        i := this.index;
        INC(this.index);
        entry := this.dictionary.storage[i];
        IF (entry # NIL) THEN
            IF ~entry.deleted THEN
                this.entry := entry;
                RETURN TRUE
            END
        END
    END;
    RETURN FALSE
END Next;

(** Reset iterator to start of dictionary. *)
PROCEDURE (this : DictionaryIterator) Reset*();
BEGIN this.index := 0 END Reset;

--
-- DictionaryStrInt. (`STRING` key and `LONGINT` value)
--

(** Calculate hash value of key *)
PROCEDURE (this : DictionaryStrInt) EntryHash(VAR entry : DictionaryEntryDesc): CARD32;
BEGIN
    RETURN Str.Hash(entry(StringIntEntryDesc).key^);
END EntryHash;

(** Compare keys *)
PROCEDURE (this : DictionaryStrInt) EntryEqual(VAR left: DictionaryEntryDesc; VAR right : DictionaryEntryDesc): BOOLEAN;
BEGIN RETURN Str.Compare(left(StringIntEntryDesc).key^, right(StringIntEntryDesc).key^) = 0;
END EntryEqual;

(** New Entry *)
PROCEDURE (this : DictionaryStrInt) EntryNew(VAR dst : DictionaryEntry);
    VAR entry : StringIntEntry;
BEGIN
    NEW(entry);
    dst := entry;
END EntryNew;

(** Assign Entry `src` to `dst` *)
PROCEDURE (this : DictionaryStrInt) EntryAssign(VAR dst : DictionaryEntryDesc; VAR src : DictionaryEntryDesc);
BEGIN
    dst(StringIntEntryDesc).key := src(StringIntEntryDesc).key;
    dst(StringIntEntryDesc).value := src(StringIntEntryDesc).value;
END EntryAssign;

(** Return `TRUE` if dictionary has given key *)
PROCEDURE (this : DictionaryStrInt) HasKey*(key- : ARRAY OF CHAR): BOOLEAN;
    VAR entry : StringIntEntryDesc;
BEGIN
    S.Assign(entry.key, key);
    RETURN this.IGet(entry);
END HasKey;

(** Set or update entry *)
PROCEDURE (this : DictionaryStrInt) SetEntry*(entry : StringIntEntry): BOOLEAN;
BEGIN RETURN this.ISet(entry^) END SetEntry;

(** Set or update key with value *)
PROCEDURE (this : DictionaryStrInt) Set*(key- : ARRAY OF CHAR; value : LONGINT): BOOLEAN;
    VAR entry : StringIntEntryDesc;
BEGIN
    S.Assign(entry.key, key);
    entry.value := value;
    RETURN this.ISet(entry);
END Set;

(** Get entry. Return `TRUE` if entry exists*)
PROCEDURE (this : DictionaryStrInt) GetEntry*(entry : StringIntEntry): BOOLEAN;
BEGIN RETURN this.IGet(entry^) END GetEntry;

(** Get value from key. Return `TRUE` if entry exists*)
PROCEDURE (this : DictionaryStrInt) Get*(key- : ARRAY OF CHAR; VAR value : LONGINT): BOOLEAN;
    VAR entry : StringIntEntryDesc;
BEGIN
    S.Assign(entry.key, key);
    IF ~this.IGet(entry) THEN RETURN FALSE END;
    value := entry.value;
    RETURN TRUE
END Get;

(** Mark entry as deleted. Return `TRUE` if entry exists *)
PROCEDURE (this : DictionaryStrInt) Delete*(key- : ARRAY OF CHAR): BOOLEAN;
    VAR entry : StringIntEntryDesc;
BEGIN
    S.Assign(entry.key, key);
    RETURN this.IDeleteEntry(entry);
END Delete;

(** Get dictionary iterator *)
PROCEDURE (this : DictionaryStrInt) Iterator*(): DictionaryStrIntIterator;
    VAR ret : DictionaryStrIntIterator;
BEGIN
    NEW(ret);
    ret.dictionary := this;
    ret.index := 0;
    RETURN ret
END Iterator;

(** Get current iterator entry's key *)
PROCEDURE (this : DictionaryStrIntIterator) Key*(): S.STRING;
BEGIN
    RETURN this.entry(StringIntEntry).key;
END Key;

(** Get current iterator entry's value *)
PROCEDURE (this : DictionaryStrIntIterator) Value*(): LONGINT;
BEGIN
    RETURN this.entry(StringIntEntry).value;
END Value;

(** Return Vector of keys *)
PROCEDURE (this : DictionaryStrInt) Keys*(): Vector.VectorOfString;
    VAR
        it : DictionaryStrIntIterator;
        ret : Vector.VectorOfString;
BEGIN
    NEW(ret);
    ret.Init();
    it := this.Iterator();
    WHILE it.Next() DO ret.Append(it.Key()^) END;
    RETURN ret
END Keys;

--
-- DictionaryStrStr. (`STRING` key and `STRING` value)
--

(** Calculate hash value of key *)
PROCEDURE (this : DictionaryStrStr) EntryHash(VAR entry : DictionaryEntryDesc): CARD32;
BEGIN
    RETURN Str.Hash(entry(StrStrEntryDesc).key^);
END EntryHash;

(** Compare keys *)
PROCEDURE (this : DictionaryStrStr) EntryEqual(VAR left: DictionaryEntryDesc; VAR right : DictionaryEntryDesc): BOOLEAN;
BEGIN RETURN Str.Compare(left(StrStrEntryDesc).key^, right(StrStrEntryDesc).key^) = 0;
END EntryEqual;

(** New Entry *)
PROCEDURE (this : DictionaryStrStr) EntryNew(VAR dst : DictionaryEntry);
    VAR entry : StrStrEntry;
BEGIN
    NEW(entry);
    dst := entry;
END EntryNew;

(** Assign Entry `src` to `dst` *)
PROCEDURE (this : DictionaryStrStr) EntryAssign(VAR dst : DictionaryEntryDesc; VAR src : DictionaryEntryDesc);
BEGIN
    dst(StrStrEntryDesc).key := src(StrStrEntryDesc).key;
    dst(StrStrEntryDesc).value := src(StrStrEntryDesc).value;
END EntryAssign;

(** Return `TRUE` if dictionary has given key *)
PROCEDURE (this : DictionaryStrStr) HasKey*(key- : ARRAY OF CHAR): BOOLEAN;
    VAR entry : StrStrEntryDesc;
BEGIN
    S.Assign(entry.key, key);
    RETURN this.IGet(entry);
END HasKey;

(** Set or update entry *)
PROCEDURE (this : DictionaryStrStr) SetEntry*(entry : StrStrEntry): BOOLEAN;
BEGIN RETURN this.ISet(entry^) END SetEntry;

(** Set or update key with value *)
PROCEDURE (this : DictionaryStrStr) Set*(key- : ARRAY OF CHAR; value- : ARRAY OF CHAR): BOOLEAN;
    VAR entry : StrStrEntryDesc;
BEGIN
    S.Assign(entry.key, key);
    S.Assign(entry.value, value);
    RETURN this.ISet(entry);
END Set;

(** Get entry. Return `TRUE` if entry exists*)
PROCEDURE (this : DictionaryStrStr) GetEntry*(entry : StrStrEntry): BOOLEAN;
BEGIN RETURN this.IGet(entry^) END GetEntry;

(** Get value from key. Return `TRUE` if entry exists*)
PROCEDURE (this : DictionaryStrStr) Get*(key- : ARRAY OF CHAR; VAR value : S.STRING): BOOLEAN;
    VAR entry : StrStrEntryDesc;
BEGIN
    S.Assign(entry.key, key);
    IF ~this.IGet(entry) THEN RETURN FALSE END;
    S.Assign(value, entry.value^);
    RETURN TRUE
END Get;

(** Mark entry as deleted. Return `TRUE` if entry exists *)
PROCEDURE (this : DictionaryStrStr) Delete*(key- : ARRAY OF CHAR): BOOLEAN;
    VAR entry : StrStrEntryDesc;
BEGIN
    S.Assign(entry.key, key);
    RETURN this.IDeleteEntry(entry);
END Delete;

(** Get dictionary iterator *)
PROCEDURE (this : DictionaryStrStr) Iterator*(): DictionaryStrStrIterator;
    VAR ret : DictionaryStrStrIterator;
BEGIN
    NEW(ret);
    ret.dictionary := this;
    ret.index := 0;
    RETURN ret
END Iterator;

(** Get current iterator entry's key *)
PROCEDURE (this : DictionaryStrStrIterator) Key*(): S.STRING;
BEGIN
    RETURN this.entry(StrStrEntry).key;
END Key;

(** Get current iterator entry's value *)
PROCEDURE (this : DictionaryStrStrIterator) Value*(): S.STRING;
BEGIN
    RETURN this.entry(StrStrEntry).value;
END Value;

(** Return Vector of keys *)
PROCEDURE (this : DictionaryStrStr) Keys*(): Vector.VectorOfString;
    VAR
        it : DictionaryStrStrIterator;
        ret : Vector.VectorOfString;
BEGIN
    NEW(ret);
    ret.Init();
    it := this.Iterator();
    WHILE it.Next() DO ret.Append(it.Key()^) END;
    RETURN ret
END Keys;

END ADTDictionary.