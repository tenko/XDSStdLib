(** 
Double linked list class.
*)
MODULE ADTList;

IMPORT SYSTEM, ADT, String, ArrayOfChar, Const;

CONST
    EQUAL       = Const.EQUAL;
    GREATER     = Const.GREATER;
    LESS        = Const.LESS;
    NONCOMPARED = Const.NONCOMPARED;

TYPE
    ListNode* = POINTER TO ListNodeDesc;
    ListNodeDesc* = RECORD
        element-: ADT.Element;
        next, prev: ListNode;
    END;
    List * = POINTER TO ListDesc;
    ListDesc* = RECORD (ListNodeDesc)
        size: LONGINT;
    END;
    ListIterator* = POINTER TO ListIteratorDesc;
    ListIteratorDesc* = RECORD
        list : List;
        current : ListNode;
        reverse : BOOLEAN;
    END;

(** Next node or NIL if last *)
PROCEDURE (this : ListNode) Next*() : ListNode;
BEGIN RETURN this.next
END Next;

(** Prev node or NIL if first *)
PROCEDURE (this : ListNode) Prev*() : ListNode;
BEGIN RETURN this.prev
END Prev;

(** Clear tree content*)
PROCEDURE (this : List) Clear*;
BEGIN
    this.element:= NIL;
    this.next:= NIL;
    this.prev:= NIL;
    this.size := 0;
END Clear;

(** Initialize  *)
PROCEDURE (this : List) Init*;
BEGIN
    this.Clear();
END Init;

(** Return TRUE if list is empty *)
PROCEDURE (this: List) IsEmpty*(): BOOLEAN;
BEGIN RETURN this.next = NIL;
END IsEmpty;

(** Return list size *)
PROCEDURE (this: List) Size*(): LONGINT;
BEGIN RETURN this.size;
END Size;

(** Return first node *)
PROCEDURE (this: List) First*(): ListNode;
BEGIN RETURN this.next;
END First;

(** Return last node *)
PROCEDURE (this: List) Last*(): ListNode;
BEGIN RETURN this.prev;
END Last;

(** Get tree iterator *)
PROCEDURE (this : List) Iterator*(reverse := FALSE : BOOLEAN): ListIterator;
    VAR ret : ListIterator;
BEGIN
    NEW(ret);
    ret.list := this;
    ret.current := NIL;
    ret.reverse := reverse;
    RETURN ret
END Iterator;

(** Advance iterator. Return `FALSE` if end is reached. *)
PROCEDURE (this : ListIterator) Next*() : BOOLEAN;
BEGIN
    IF this.current = NIL THEN
        IF this.reverse THEN
            this.current := this.list.Last()
        ELSE
            this.current := this.list.First()
        END
    ELSE
        IF this.reverse THEN
            this.current := this.current.prev;
        ELSE
            this.current := this.current.next;
        END
    END;
    RETURN this.current # NIL 
END Next;

(** Current element or NIL *)
PROCEDURE (this : ListIterator) Element*() : ADT.Element;
BEGIN
    IF this.current # NIL THEN RETURN this.current.element END;
    RETURN NIL 
END Element;

(** Reset iterator to start of tree. *)
PROCEDURE (this : ListIterator) Reset*();
BEGIN this.current := NIL END Reset;

(** Insert element before current iterator position *)
PROCEDURE (this : ListIterator) Insert*(e : ADT.Element) ;
    VAR node : ListNode;
BEGIN
    IF e = NIL THEN RETURN END;
    NEW(node);
    IF this.current = NIL THEN SYSTEM.EVAL(this.Next()) END;
    IF this.current = NIL THEN
        this.list.prev := node;
        this.list.next := node;
    ELSE
        IF this.list.next = this.current THEN
            this.list.next := node;
        END;
        node.next := this.current;
        node.prev := this.current.prev;
        this.current.prev := node;
    END;
    node.element := e;
    INC(this.list.size);
END Insert;

(** Append element to tail of list *)
PROCEDURE (this: List) Append*(e: ADT.Element);
    VAR node : ListNode;
BEGIN
    IF e = NIL THEN RETURN END;
    NEW(node);
    node.next := NIL;
    node.prev := this.prev;
    IF this.prev = NIL THEN
        this.prev := node;
        this.next := node;
    ELSE
        this.prev.next := node;
        this.prev := node;
    END;
    node.element := e;
    INC(this.size);
END Append;

(** Append element to head of list *)
PROCEDURE (this: List) AppendHead*(e: ADT.Element);
    VAR node : ListNode;
BEGIN
    IF e = NIL THEN RETURN END;
    NEW(node);
    node.next := this.next;
    node.prev := NIL;
    IF this.next = NIL THEN
        this.prev := node;
        this.next := node;
    ELSE
        this.next.prev := node;
        this.next := node;
    END;
    node.element := e;
    INC(this.size);
END AppendHead;

(** Remove and return element at tail of list *)
PROCEDURE (this: List) Pop*(): ADT.Element;
    VAR ret : ADT.Element;
BEGIN
    IF this.prev = NIL THEN RETURN NIL END;
    ret := this.prev.element;
    IF this.prev = this.next THEN
        this.prev := NIL;
        this.next := NIL;
    ELSE
        this.prev := this.prev.prev;
        this.prev.next := NIL;
    END;
    DEC(this.size);
    RETURN ret
END Pop;

(** Remove and return element at head of list *)
PROCEDURE (this: List) PopHead*(): ADT.Element;
    VAR ret : ADT.Element;
BEGIN
    IF this.next = NIL THEN RETURN NIL END;
    ret := this.next.element;
    IF this.next = this.prev THEN
        this.prev := NIL;
        this.next := NIL;
    ELSE
        this.next := this.next.next;
        this.next.prev := NIL;
    END;
    DEC(this.size);
    RETURN ret
END PopHead;

END ADTList.