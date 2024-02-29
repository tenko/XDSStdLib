(**
The `Vector` module implements resizable container.
It is fast to append to end of array. Insert data
at random locations then this container is not suitable for.

WARNING: The `VectorOfByte` implementation is not type safe and
the developer must ensure that no `GC` data is placed in the array.
Any data can be pushed to this Vector. `VectorOfByte` should be
extended with a concrete type safe interface.

The follow classes are defined
 * `VectorOfByte` (Ref. warning above.)
 * `VectorOfLongInt`
 * `VectorOfLongReal`
 * `VectorOfString`

Other types can be implemented by method of type
extension without much overhead.
*)
MODULE ADTVector;

IMPORT SYSTEM, ArrayOfByte, ArrayOfChar, Type, Word, String;

TYPE
    (** Abstract vector *)
    VectorValue* = RECORD END;
    Vector* = POINTER TO VectorDesc;
    VectorDesc* = RECORD
        last : LONGINT;
    END;

    (** Vectory of BYTE *)
    VectorByteValue* = RECORD (VectorValue) byte- : SYSTEM.BYTE END;
    VectorOfByteStorage = POINTER TO ARRAY OF SYSTEM.BYTE;
    VectorOfByte* = POINTER TO VectorOfByteDesc;
    VectorOfByteDesc = RECORD (VectorDesc)
        itemSize- : LONGINT;
        storage- : VectorOfByteStorage;
    END;

    (** Vector of LONGINT *)
    VectorLongIntValue* = RECORD (VectorValue) longint- : LONGINT END;
    VectorOfLongIntStorage = POINTER TO ARRAY OF LONGINT;
    VectorOfLongInt* = POINTER TO VectorOfLongIntDesc;
    VectorOfLongIntDesc = RECORD (VectorDesc)
        storage- : VectorOfLongIntStorage;
    END;

    (** Vector of LONGREAL *)
    VectorLongRealValue* = RECORD (VectorValue) longreal- : LONGREAL END;
    VectorOfLongRealStorage = POINTER TO ARRAY OF LONGREAL;
    VectorOfLongReal* = POINTER TO VectorOfLongRealDesc;
    VectorOfLongRealDesc = RECORD (VectorDesc)
        storage- : VectorOfLongRealStorage;
    END;

    (** Vector of STRING *)
    VectorStringValue* = RECORD (VectorValue) string- : String.STRING END;
    VectorOfStringStorage = POINTER TO ARRAY OF String.STRING;
    VectorOfString* = POINTER TO VectorOfStringDesc;
    VectorOfStringDesc = RECORD (VectorDesc)
        storage- : VectorOfStringStorage;
    END;

CONST
    INIT_SIZE* = 64;

(** Length of array *)
PROCEDURE (this : Vector) Size*(): LONGINT;
BEGIN RETURN this.last;
END Size;

(**
Capacity of array.
Must be reimplemented. *)
PROCEDURE (this : Vector) Capacity*(): LONGINT;
BEGIN RETURN 0;
END Capacity;

(**
Resize storage to accomodate capacity.
Must be reimplemented. *)
PROCEDURE (this : Vector) Reserve*(capacity  : LONGINT);
BEGIN END Reserve;

(** Resize vector potential discarding data *)
PROCEDURE (this : Vector) Resize*(capacity  : LONGINT);
BEGIN
    ASSERT(capacity > 0);
    this.Reserve(capacity);
    IF capacity < this.last THEN this.last := capacity END;
END Resize;

(**
Shrink storage.
Must be reimplemented. *)
PROCEDURE (this : Vector) Shrink*();
BEGIN END Shrink;

(** Clear Vector to zero size *)
PROCEDURE (this : Vector) Clear*();
BEGIN this.last := 0;
END Clear;

(**
Compare array data at i and j.
Must be reimplemented. *)
PROCEDURE (this : Vector) Compare(i, j: LONGINT): INTEGER;
BEGIN RETURN 0
END Compare;

(**
Compare array data at i to value.
Must be reimplemented. *)
PROCEDURE (this : Vector) CompareValue(i: LONGINT; VAR value : VectorValue): INTEGER;
BEGIN RETURN 0
END CompareValue;

(**
Swap array data at i and j.
Must be reimplemented. *)
PROCEDURE (this : Vector) Swap(i, j: LONGINT);
BEGIN END Swap;

(** Reverse array in-place *)
PROCEDURE (this : Vector) Reverse*();
    VAR start, end: LONGINT;
BEGIN
    start := 0;
    end := this.Size() - 1;
    WHILE start < end DO
       this.Swap(start, end);
       INC(start); DEC(end)
    END;
END Reverse;

(** Random shuffle array in-place *)
PROCEDURE (this : Vector) Shuffle*();
    VAR i, j: LONGINT;
BEGIN
    i := this.Size() - 1;
    WHILE i >= 1 DO
        j := Word.Random(i + 1);
        this.Swap(i, j);
        DEC(i)
    END;
END Shuffle;

(** Sort array in-place (QuickSort) *)
PROCEDURE (this : Vector) Sort*;
    VAR N: LONGINT;

    PROCEDURE ISort (l, r: LONGINT);
    VAR i, j: LONGINT;
    BEGIN
        WHILE r > l DO
            i := l + 1;
            j := r;
            WHILE i <= j DO
                WHILE (i <= j) AND NOT (this.Compare(l,i) > 0) DO
                    INC(i);
                END;
                WHILE (i <= j) AND (this.Compare(l,j) > 0) DO
                    DEC(j);
                END;
                IF i <= j THEN
                    IF i # j THEN
                        this.Swap (i, j);
                    END;
                    INC(i);
                    DEC(j)
                END;
            END;
            IF j # l THEN
                this.Swap(j, l)
            END;
            IF j + j > r + l THEN
                ISort(j + 1, r);
                r := j - 1;
            ELSE
                ISort(l, j - 1);
                l := j + 1;
            END;
        END;
    END ISort;
BEGIN
    N := this.Size();
    IF N > 0 THEN
        ISort(0, N-1);
    END
END Sort;

(**
Find position in array. Expect array to be sorted in ascending order.
Return -1 if not found. Must be called from concrete Vector.
*)
PROCEDURE (this : Vector) IBinaryFind(VAR value : VectorValue): LONGINT;
VAR N, i, j: LONGINT;
BEGIN
    N := this.Size();
    j := 0;
    WHILE j < N DO
        i := (j + N) DIV 2;
        CASE this.CompareValue(i, value) OF
            | -1 : j := i + 1;
            |  0 : RETURN i;
            | +1 : N := i;
        ELSE
            ASSERT(FALSE);
        END;
    END;
    RETURN -1
END IBinaryFind;

(**
Find position in array where value should be inserted to keep array sorted.
Expect array to be sorted in ascending order. Must be called from concrete Vector.
*)
PROCEDURE (this : Vector) IBinarySearch(VAR value : VectorValue): LONGINT;
VAR N, i, j: LONGINT;
BEGIN
    N := this.Size();
    j := 0;
    WHILE j < N DO
        i := (j + N) DIV 2;
        CASE this.CompareValue(i, value) OF
            | -1 : j := i + 1;
            |  0 : RETURN i;
            | +1 : N := i;
        ELSE
            ASSERT(FALSE);
        END;
    END;
    IF j = 0 THEN RETURN 0
    ELSE RETURN j - 1 END;
END IBinarySearch;

--
-- VectorOfByte
--

(** Initialize  *)
PROCEDURE (this : VectorOfByte) InitRaw*(size : LONGINT; itemSize := 1 : LONGINT);
BEGIN
    ASSERT((size > 0) & (itemSize > 0));
    IF size < INIT_SIZE THEN size := INIT_SIZE END;
    NEW(this.storage, size * itemSize);
    this.last := 0;
    this.itemSize := itemSize;
END InitRaw;

(** Item capacity of vector *)
PROCEDURE (this : VectorOfByte) Capacity*(): LONGINT;
BEGIN RETURN LEN(this.storage^) DIV this.itemSize;
END Capacity;

(** Resize storage to accomodate capacity *)
PROCEDURE (this : VectorOfByte) Reserve*(capacity  : LONGINT);
    VAR
        storage : VectorOfByteStorage;
        cap : LONGINT;
BEGIN
    ASSERT(capacity > 0);
    cap := this.Capacity();
    IF capacity > cap THEN
        WHILE cap < capacity DO cap := cap * 2 END;
        NEW(storage, cap * this.itemSize);
        IF this.last > 0 THEN
            ArrayOfByte.Copy(storage^, this.storage^, this.last * this.itemSize)
        END;
        this.storage := storage
    END;
END Reserve;

(** Shrink storage *)
PROCEDURE (this : VectorOfByte) Shrink*();
    VAR
        storage : VectorOfByteStorage;
        cap : LONGINT;
BEGIN
    cap := this.Capacity();
    IF cap > this.last + 1 THEN
        WHILE (cap > this.last) & (cap > INIT_SIZE) DO cap := cap DIV 2 END;
        IF cap < this.last THEN cap := cap * 2 END;
        NEW(storage, cap * this.itemSize);
        IF this.last > 0 THEN
            ArrayOfByte.Copy(storage^, this.storage^, this.last * this.itemSize)
        END;
        this.storage := storage
    END;
END Shrink;

(** Fill vector with capacity values, overwriting content and possible resize vector *)
PROCEDURE (this : VectorOfByte) FillRaw*(capacity : LONGINT; value := 0 : SYSTEM.BYTE);
BEGIN
    ASSERT(capacity > 0);
    this.Reserve(capacity);
    ArrayOfByte.Fill(this.storage^, value, capacity);
    this.last := capacity;
END FillRaw;

(** Get raw data from array *)
PROCEDURE (this : VectorOfByte) GetRaw*(idx : LONGINT; VAR dst : ARRAY OF SYSTEM.BYTE);
    VAR i : LONGINT;
BEGIN
    ASSERT((idx >= 0) & (idx <= this.last) & (LEN(dst) = this.itemSize));
    FOR i := 0 TO this.itemSize - 1 DO
        dst[i] := this.storage^[idx * this.itemSize + i]
    END;
END GetRaw;

(** Set raw data from src *)
PROCEDURE (this : VectorOfByte) SetRaw*(idx : LONGINT; src- : ARRAY OF SYSTEM.BYTE);
    VAR i : LONGINT;
BEGIN
    ASSERT((idx >= 0) & (idx <= this.last) & (LEN(src) = this.itemSize));
    FOR i := 0 TO this.itemSize - 1 DO
        this.storage^[idx * this.itemSize + i] := src[i];
    END;
END SetRaw;

(** Append raw data *)
PROCEDURE (this : VectorOfByte) AppendRaw*(src- : ARRAY OF SYSTEM.BYTE);
    VAR capacity : LONGINT;
BEGIN
    ASSERT(LEN(src) = this.itemSize);
    capacity := this.Capacity();
    IF this.last >= capacity THEN
        this.Reserve(capacity + 1)
    END;
    this.SetRaw(this.last, src);
    INC(this.last)
END AppendRaw;

(** Compare array data at i and j. *)
PROCEDURE (this : VectorOfByte) Compare(i, j: LONGINT): INTEGER;
    VAR
        left, right : CHAR;
        k : LONGINT;
BEGIN
    k := 0; left := 00X; right := 00X;
    LOOP
        IF k >= this.itemSize THEN EXIT END;
        left := VAL(CHAR, this.storage[this.itemSize*i + k]);
        right := VAL(CHAR, this.storage[this.itemSize*j + k]);
        IF left # right THEN EXIT END;
        INC(k)
    END;
    IF left < right THEN RETURN -1
    ELSIF left > right THEN RETURN 1
    ELSE RETURN 0 END;
END Compare;

(** Compare array data at i to value. *)
PROCEDURE (this : VectorOfByte) CompareValue(i: LONGINT; VAR value : VectorValue): INTEGER;
    VAR
        left, right : CHAR;
        k : LONGINT;
BEGIN
    k := 0;
    left := 00X;
    right := VAL(CHAR, value(VectorByteValue).byte);
    LOOP
        IF k >= this.itemSize THEN EXIT END;
        left := VAL(CHAR, this.storage[this.itemSize*i + k]);
        IF left # right THEN EXIT END;
        INC(k)
    END;
    IF left < right THEN RETURN -1
    ELSIF left > right THEN RETURN 1
    ELSE RETURN 0 END;
END CompareValue;

(** Swap array data at i and j. *)
PROCEDURE (this : VectorOfByte) Swap(i, j: LONGINT);
    VAR
        left, right: SYSTEM.BYTE;
        k : LONGINT;
BEGIN
    FOR k := 0 TO this.itemSize - 1 DO
        left := this.storage[this.itemSize*i + k];
        right := this.storage[this.itemSize*j + k];
        this.storage[this.itemSize*i + k] := right;
        this.storage[this.itemSize*j + k] := left;
    END
END Swap;

--
-- VectorOfLongInt
--

(** Initialize  *)
PROCEDURE (this : VectorOfLongInt) Init*(size := INIT_SIZE : LONGINT);
BEGIN
    ASSERT(size > 0);
    IF size < INIT_SIZE THEN size := INIT_SIZE END;
    NEW(this.storage, size);
    this.last := 0;
END Init;

(** Item capacity of vector *)
PROCEDURE (this : VectorOfLongInt) Capacity*(): LONGINT;
BEGIN RETURN LEN(this.storage^);
END Capacity;

(** Resize storage to accomodate capacity *)
PROCEDURE (this : VectorOfLongInt) Reserve*(capacity  : LONGINT);
    VAR
        storage : VectorOfLongIntStorage;
        cap : LONGINT;
BEGIN
    ASSERT(capacity > 0);
    cap := this.Capacity();
    IF capacity > cap THEN
        WHILE cap < capacity DO cap := cap * 2 END;
        NEW(storage, cap);
        IF this.last > 0 THEN
            ArrayOfByte.Copy(storage^, this.storage^, this.last * SYSTEM.BYTES(LONGINT))
        END;
        this.storage := storage
    END;
END Reserve;

(** Shrink storage *)
PROCEDURE (this : VectorOfLongInt) Shrink*();
    VAR
        storage : VectorOfLongIntStorage;
        cap : LONGINT;
BEGIN
    cap := this.Capacity();
    IF cap > this.last + 1 THEN
        WHILE (cap > this.last) & (cap > INIT_SIZE) DO cap := cap DIV 2 END;
        IF cap < this.last THEN cap := cap * 2 END;
        NEW(storage, cap);
        IF this.last > 0 THEN
            ArrayOfByte.Copy(storage^, this.storage^, this.last * SYSTEM.BYTES(LONGINT))
        END;
        this.storage := storage
    END;
END Shrink;

(** Compare array data at i and j. *)
PROCEDURE (this : VectorOfLongInt) Compare(i, j: LONGINT): INTEGER;
    VAR left, right : LONGINT;
BEGIN
    left := this.storage[j];
    right := this.storage[i];
    IF left < right THEN RETURN -1
    ELSIF left > right THEN RETURN 1
    ELSE RETURN 0 END;
END Compare;

(** Compare array data at i to value. *)
PROCEDURE (this : VectorOfLongInt) CompareValue(i: LONGINT; VAR value : VectorValue): INTEGER;
    VAR left, right : LONGINT;
BEGIN
    left := this.storage[i];
    right := value(VectorLongIntValue).longint;
    IF left < right THEN RETURN -1
    ELSIF left > right THEN RETURN 1
    ELSE RETURN 0 END;
END CompareValue;

(** Swap array data at i and j. *)
PROCEDURE (this : VectorOfLongInt) Swap(i, j: LONGINT);
    VAR left, right: LONGINT;
BEGIN
    left := this.storage[i];
    right := this.storage[j];
    this.storage[i] := right;
    this.storage[j] := left;
END Swap;

(**
Find position in array. Expect array to be sorted in ascending order.
Return -1 if not found.
*)
PROCEDURE (this : VectorOfLongInt) BinaryFind*(value : LONGINT): LONGINT;
    VAR val : VectorLongIntValue;
BEGIN
    val.longint := value;
    RETURN this.IBinaryFind(val);
END BinaryFind;

(** Find position in array where value should be inserted to keep array sorted.
Expect array to be sorted in ascending order.
*)
PROCEDURE (this : VectorOfLongInt) BinarySearch*(value : LONGINT): LONGINT;
    VAR val : VectorLongIntValue;
BEGIN
    val.longint := value;
    RETURN this.IBinarySearch(val);
END BinarySearch;

(** Fill vector with capacity values, overwriting content and possible resize vector *)
PROCEDURE (this : VectorOfLongInt) Fill*(capacity : LONGINT; value := 0 : LONGINT);
BEGIN
    ASSERT(capacity > 0);
    this.Reserve(capacity);
    ArrayOfByte.FillWord(this.storage^, value, capacity);
    this.last := capacity;
END Fill;

(** Append raw data *)
PROCEDURE (this : VectorOfLongInt) Append*(value : LONGINT);
    VAR capacity : LONGINT;
BEGIN
    capacity := this.Capacity();
    IF this.last >= capacity THEN
        this.Reserve(capacity + 1)
    END;
    this.storage[this.last] := value;
    INC(this.last)
END Append;

(* Return value at idx *)
PROCEDURE (this : VectorOfLongInt) At*(idx : LONGINT) : LONGINT;
BEGIN RETURN this.storage[idx] END At;

(* Set value at idx *)
PROCEDURE (this : VectorOfLongInt) Set*(idx, value : LONGINT);
BEGIN this.storage[idx] := value END Set;

(** Pop last value *)
PROCEDURE (this : VectorOfLongInt) Pop*(VAR value : LONGINT) : BOOLEAN;
BEGIN
    IF this.Size() = 0 THEN RETURN FALSE END;
    value := this.storage[this.last - 1];
    DEC(this.last);
    RETURN TRUE;
END Pop;

--
-- VectorOfLongReal
--

(** Initialize  *)
PROCEDURE (this : VectorOfLongReal) Init*(size := INIT_SIZE : LONGINT);
BEGIN
    ASSERT(size > 0);
    IF size < INIT_SIZE THEN size := INIT_SIZE END;
    NEW(this.storage, size);
    this.last := 0;
END Init;

(** Item capacity of vector *)
PROCEDURE (this : VectorOfLongReal) Capacity*(): LONGINT;
BEGIN RETURN LEN(this.storage^);
END Capacity;

(** Resize storage to accomodate capacity *)
PROCEDURE (this : VectorOfLongReal) Reserve*(capacity  : LONGINT);
    VAR
        storage : VectorOfLongRealStorage;
        cap : LONGINT;
BEGIN
    ASSERT(capacity > 0);
    cap := this.Capacity();
    IF capacity > cap THEN
        WHILE cap < capacity DO cap := cap * 2 END;
        NEW(storage, cap);
        IF this.last > 0 THEN
            ArrayOfByte.Copy(storage^, this.storage^, this.last * SYSTEM.BYTES(LONGREAL))
        END;
        this.storage := storage
    END;
END Reserve;

(** Shrink storage *)
PROCEDURE (this : VectorOfLongReal) Shrink*();
    VAR
        storage : VectorOfLongRealStorage;
        cap : LONGINT;
BEGIN
    cap := this.Capacity();
    IF cap > this.last + 1 THEN
        WHILE (cap > this.last) & (cap > INIT_SIZE) DO cap := cap DIV 2 END;
        IF cap < this.last THEN cap := cap * 2 END;
        NEW(storage, cap);
        IF this.last > 0 THEN
            ArrayOfByte.Copy(storage^, this.storage^, this.last * SYSTEM.BYTES(LONGREAL))
        END;
        this.storage := storage
    END;
END Shrink;

(** Compare array data at i and j. *)
PROCEDURE (this : VectorOfLongReal) Compare(i, j: LONGINT): INTEGER;
    VAR left, right : LONGREAL;
BEGIN
    left := this.storage[j];
    right := this.storage[i];
    IF left < right THEN RETURN -1
    ELSIF left > right THEN RETURN 1
    ELSE RETURN 0 END;
END Compare;

(** Compare array data at i to value. *)
PROCEDURE (this : VectorOfLongReal) CompareValue(i: LONGINT; VAR value : VectorValue): INTEGER;
    VAR left, right : LONGREAL;
BEGIN
    left := this.storage[i];
    right := value(VectorLongRealValue).longreal;
    IF left < right THEN RETURN -1
    ELSIF left > right THEN RETURN 1
    ELSE RETURN 0 END;
END CompareValue;

(** Swap array data at i and j. *)
PROCEDURE (this : VectorOfLongReal) Swap(i, j: LONGINT);
    VAR left, right: LONGREAL;
BEGIN
    left := this.storage[i];
    right := this.storage[j];
    this.storage[i] := right;
    this.storage[j] := left;
END Swap;

(**
Find position in array where value should be inserted to keep array sorted.
Expect array to be sorted in ascending order.
*)
PROCEDURE (this : VectorOfLongReal) BinarySearch*(value : LONGREAL): LONGINT;
    VAR val : VectorLongRealValue;
BEGIN
    val.longreal := value;
    RETURN this.IBinarySearch(val);
END BinarySearch;

(** Fill vector with capacity values, overwriting content and possible resize vector *)
PROCEDURE (this : VectorOfLongReal) Fill*(capacity : LONGINT; value := 0.0 : LONGREAL);
    VAR i : LONGINT;
BEGIN
    ASSERT(capacity > 0);
    this.Reserve(capacity);
    FOR i := 0 TO capacity - 1 DO this.storage[i] := value END;
    this.last := capacity;
END Fill;

(** Append value to end of vector *)
PROCEDURE (this : VectorOfLongReal) Append*(value : LONGREAL);
    VAR capacity : LONGINT;
BEGIN
    capacity := this.Capacity();
    IF this.last >= capacity THEN
        this.Reserve(capacity + 1)
    END;
    this.storage[this.last] := value;
    INC(this.last)
END Append;

(* Return value at idx *)
PROCEDURE (this : VectorOfLongReal) At*(idx : LONGINT) : LONGREAL;
    VAR ret : LONGINT;
BEGIN RETURN this.storage[idx]
END At;

(* Set value at idx *)
PROCEDURE (this : VectorOfLongReal) Set*(idx : LONGINT; value : LONGREAL);
BEGIN
    ASSERT(idx < this.last);
    this.storage[idx] := value
END Set;

(** Pop last value *)
PROCEDURE (this : VectorOfLongReal) Pop*(VAR value : LONGREAL) : BOOLEAN;
BEGIN
    IF this.Size() = 0 THEN RETURN FALSE END;
    value := this.storage[this.last - 1];
    DEC(this.last);
    RETURN TRUE;
END Pop;

--
-- VectorOfString
--

(** Initialize  *)
PROCEDURE (this : VectorOfString) Init*(size := INIT_SIZE : LONGINT);
BEGIN
    ASSERT(size > 0);
    IF size < INIT_SIZE THEN size := INIT_SIZE END;
    NEW(this.storage, size);
    this.last := 0;
END Init;

(** Item capacity of vector *)
PROCEDURE (this : VectorOfString) Capacity*(): LONGINT;
BEGIN RETURN LEN(this.storage^);
END Capacity;

(** Resize storage to accomodate capacity *)
PROCEDURE (this : VectorOfString) Reserve*(capacity  : LONGINT);
    VAR
        storage : VectorOfStringStorage;
        i, cap : LONGINT;
BEGIN
    ASSERT(capacity > 0);
    cap := this.Capacity();
    IF capacity > cap THEN
        WHILE cap < capacity DO cap := cap * 2 END;
        NEW(storage, cap);
        FOR i := 0 TO this.last - 1 DO
            storage[i] := this.storage[i];
            this.storage[i] := NIL;
        END;
        this.storage := storage
    END;
END Reserve;

(** Shrink storage *)
PROCEDURE (this : VectorOfString) Shrink*();
    VAR
        storage : VectorOfStringStorage;
        i, cap : LONGINT;
BEGIN
    cap := this.Capacity();
    IF cap > this.last + 1 THEN
        WHILE (cap > this.last) & (cap > INIT_SIZE) DO cap := cap DIV 2 END;
        IF cap < this.last THEN cap := cap * 2 END;
        NEW(storage, cap);
        FOR i := 0 TO this.last - 1 DO
            storage[i] := this.storage[i];
            this.storage[i] := NIL;
        END;
        this.storage := storage
    END;
END Shrink;

(** Compare array data at i and j. *)
PROCEDURE (this : VectorOfString) Compare(i, j: LONGINT): INTEGER;
BEGIN
    RETURN ArrayOfChar.Compare(this.storage[j]^, this.storage[i]^)
END Compare;

(** Compare array data at i to value. *)
PROCEDURE (this : VectorOfString) CompareValue(i: LONGINT; VAR value : VectorValue): INTEGER;
BEGIN
    RETURN ArrayOfChar.Compare(this.storage[i]^, value(VectorStringValue).string^)
END CompareValue;

(** Swap array data at i and j. *)
PROCEDURE (this : VectorOfString) Swap(i, j: LONGINT);
    VAR left, right: String.STRING;
BEGIN
    left := this.storage[i];
    right := this.storage[j];
    this.storage[i] := right;
    this.storage[j] := left;
END Swap;

(**
Find position in array where value should be inserted to keep array sorted.
Expect array to be sorted in ascending order.
*)
PROCEDURE (this : VectorOfString) BinarySearch*(value : ARRAY OF CHAR): LONGINT;
    VAR val : VectorStringValue;
BEGIN
    String.Assign(val.string, value);
    RETURN this.IBinarySearch(val);
END BinarySearch;

(** Fill vector with capacity values, overwriting content and possible resize vector *)
PROCEDURE (this : VectorOfString) Fill*(capacity : LONGINT; value : ARRAY OF CHAR);
    VAR i : LONGINT;
BEGIN
    ASSERT(capacity > 0);
    this.Reserve(capacity);
    FOR i := 0 TO capacity - 1 DO String.Assign(this.storage[i], value) END;
    this.last := capacity;
END Fill;

(** Append string to end of vector *)
PROCEDURE (this : VectorOfString) Append*(value : ARRAY OF CHAR);
    VAR capacity : LONGINT;
BEGIN
    capacity := this.Capacity();
    IF this.last >= capacity THEN
        this.Reserve(capacity + 1)
    END;
    String.Assign(this.storage[this.last], value);
    INC(this.last)
END Append;

(* Return value at idx *)
PROCEDURE (this : VectorOfString) At*(idx : LONGINT) : String.STRING;
BEGIN
    ASSERT(idx < this.last);
    RETURN this.storage[idx]
END At;

(* Set value at idx *)
PROCEDURE (this : VectorOfString) Set*(idx : LONGINT; value : ARRAY OF CHAR);
BEGIN
    ASSERT(idx < this.last);
    String.Assign(this.storage[idx], value);
END Set;

(** Pop last value *)
PROCEDURE (this : VectorOfString) Pop*(VAR value : String.STRING) : BOOLEAN;
BEGIN
    IF this.Size() = 0 THEN RETURN FALSE END;
    value := this.storage[this.last - 1];
    DEC(this.last);
    RETURN TRUE;
END Pop;

END ADTVector.