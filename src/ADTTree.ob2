(** 
AVL tree (Adelson-Velsky and Landis) is a self-balancing binary
search tree.

AVL trees keep the order of nodes on insertion/delete and allow
for fast find operations (average and worst case O(log n))

Copyright (c) 1993 xTech Ltd, Russia. All Rights Reserved.
Tenko : Modified for inclusion in library.
*)
MODULE ADTTree;

IMPORT ADT, ArrayOfChar, String, Const;

CONST
    EQUAL       = Const.EQUAL;
    GREATER     = Const.GREATER;
    LESS        = Const.LESS;
    NONCOMPARED = Const.NONCOMPARED;

TYPE
    TreeNode* = POINTER TO TreeNodeDesc;
    TreeNodeDesc* = RECORD
        element-: ADT.Element;
        left, right, up: TreeNode;
        bal: LONGINT;
    END;
    Tree * = POINTER TO TreeDesc;
    TreeDesc* = RECORD (TreeNodeDesc)
        minimum: TreeNode;
        size: LONGINT;
    END;
    TreeIterator* = POINTER TO TreeIteratorDesc;
    TreeIteratorDesc* = RECORD
        tree : Tree;
        current : TreeNode;
        reverse : BOOLEAN;
    END;

(** Next node or NIL if last *)
PROCEDURE (this : TreeNode) Next*() : TreeNode;
    VAR node, ret : TreeNode;
BEGIN
    IF this.right # NIL THEN
        ret := this.right;
        WHILE ret.left # NIL DO ret := ret.left END;
    ELSE
        node := this;
        ret := node.up;
        WHILE (ret # NIL) & (node = ret.right) DO
            node := ret;
            ret := ret.up;
        END;
    END;
    RETURN ret;
END Next;

(** Prev node or NIL if first *)
PROCEDURE (this : TreeNode) Prev*() : TreeNode;
    VAR node, ret : TreeNode;
BEGIN
    IF this.left # NIL THEN
        ret := this.left;
        WHILE ret.right # NIL DO ret := ret.right END;
    ELSE
        node := this;
        ret := node.up;
        WHILE (ret # NIL) & (node = ret.left) DO
            node := ret;
            ret := ret.up;
        END;
    END;
    RETURN ret;
END Prev;

(** Clear tree content*)
PROCEDURE (this : Tree) Clear*;
BEGIN
    this.minimum := NIL;
    this.size := 0;
    this.element:= NIL;
    this.right:= NIL;
    this.left:= NIL;
    this.up:= NIL;
    this.bal:= 0;
END Clear;

(** Initialize  *)
PROCEDURE (this : Tree) Init*;
BEGIN
    this.Clear();
END Init;

(** Return TRUE if tree is empty *)
PROCEDURE (this: Tree) IsEmpty*(): BOOLEAN;
BEGIN RETURN this.up = NIL;
END IsEmpty;

(** Return tree size *)
PROCEDURE (this: Tree) Size*(): LONGINT;
BEGIN RETURN this.size;
END Size;

(** Return first node *)
PROCEDURE (this: Tree) First*(): TreeNode;
BEGIN RETURN this.minimum;
END First;

(** Return last node *)
PROCEDURE (this: Tree) Last*(): TreeNode;
    VAR node: TreeNode;
BEGIN
    node := this.up;
    IF node # NIL THEN
        WHILE node.right # NIL DO node := node.right END
    END;
    RETURN node;
END Last;

(** Get tree iterator *)
PROCEDURE (this : Tree) Iterator*(reverse := FALSE : BOOLEAN): TreeIterator;
    VAR ret : TreeIterator;
BEGIN
    NEW(ret);
    ret.tree := this;
    ret.current := NIL;
    ret.reverse := reverse;
    RETURN ret
END Iterator;

(** Advance iterator. Return `FALSE` if end is reached. *)
PROCEDURE (this : TreeIterator) Next*() : BOOLEAN;
BEGIN
    IF this.current = NIL THEN
        IF this.reverse THEN
            this.current := this.tree.Last()
        ELSE
            this.current := this.tree.First()
        END
    ELSE
        IF this.reverse THEN
            this.current := this.current.Prev();
        ELSE
            this.current := this.current.Next();
        END

    END;
    RETURN this.current # NIL 
END Next;

(** Current element or NIL *)
PROCEDURE (this : TreeIterator) Element*() : ADT.Element;
BEGIN
    IF this.current # NIL THEN RETURN this.current.element END;
    RETURN NIL 
END Element;

(** Reset iterator to start of tree. *)
PROCEDURE (this : TreeIterator) Reset*();
BEGIN this.current := NIL END Reset;

(** Find node equal to element argument. Return NIL if no node is found. *)
PROCEDURE (this: Tree) FindNode*(element: ADT.Element) : TreeNode;
    VAR node: TreeNode;
BEGIN
    IF (element = NIL) OR (this.up = NIL) THEN RETURN NIL END;
    node := this.up;
    WHILE node # NIL DO
        CASE element.Compare(node.element) OF
             EQUAL  : RETURN node;
            |GREATER: node:= node.right;
            |LESS   : node:= node.left;
        ELSE RETURN NIL;
      END;
    END;
    RETURN NIL
END FindNode;

(** Find element equal to argument. Return NIL if no element is found. *)
PROCEDURE (this: Tree) Find*(element: ADT.Element) : ADT.Element;
    VAR node: TreeNode;
BEGIN
    node := this.FindNode(element);
    IF node # NIL THEN RETURN node.element END;
    RETURN NIL
END Find;

PROCEDURE (this: Tree) SimpleInsert(e: ADT.Element) : TreeNode;
    VAR
        p, h: TreeNode;
        direction: BOOLEAN;
BEGIN
    IF this.up # NIL THEN
        h := this.up;
        REPEAT
            p := h;
            CASE e.Compare(h.element) OF
                 EQUAL  : RETURN NIL;
                |GREATER: h := h.right; direction := TRUE;
                |LESS   : h := h.left;  direction := FALSE;
            ELSE RETURN NIL
            END;
        UNTIL h = NIL;
        NEW(h);
        h.left:= NIL; h.right:= NIL; h.up:= p;
        h.element:= e;      h.bal:= 0;
        IF direction THEN p.right:= h;
        ELSE p.left:= h;
        END;
        INC(this.size);
        IF this.up.left = h THEN this.minimum := h END;
        RETURN h
    ELSE
        NEW(this.up);
        this.up.right := NIL;
        this.up.left := NIL;
        this.up.up := NIL;
        this.up.bal := 0;
        this.up.element := e;
        this.size := 1;
        this.minimum := this.up;
        RETURN this.up;
    END;
END SimpleInsert;

(** Insert element *)
PROCEDURE (this: Tree) Insert*(e: ADT.Element);
    VAR cur, p, p2: TreeNode;
BEGIN
    IF e = NIL THEN RETURN END;
    cur := this.SimpleInsert(e);
    WHILE ( cur # NIL ) & ( cur # this.up )  DO
        p:= cur.up;
        IF p.left = cur THEN (* left branch grows up   *)
            CASE p.bal OF
                1 : p.bal:= 0;  RETURN;
                |0 : p.bal:= -1;
                |-1: (* balance *)
                IF cur.bal = -1 THEN (* single LL turn *)
                    p.left:= cur.right;
                    IF cur.right # NIL THEN  cur.right.up:= p  END;
                    cur.right:= p; cur.up:= p.up; p.up:= cur;
                    p.bal:= 0;
                    IF p = this.up THEN this.up:= cur;
                    ELSIF cur.up.left = p THEN cur.up.left:= cur;
                    ELSE cur.up.right:= cur;
                    END;
                    p:= cur;
                ELSE (* double LR turn *)
                    p2:= cur.right;
                    cur.right:= p2.left;
                    IF p2.left # NIL THEN  p2.left.up:= cur  END;
                    p2.left:= cur; cur.up:= p2;
                    p.left:= p2.right;
                    IF p2.right # NIL THEN p2.right.up:= p   END;
                    p2.right:= p; p2.up:= p.up; p.up:= p2;
                    IF p2.bal = -1 THEN  p.bal:= 1     ELSE  p.bal:= 0    END;
                    IF p2.bal =  1 THEN  cur.bal:= -1  ELSE  cur.bal:= 0  END;
                    IF p = this.up THEN this.up:= p2
                    ELSIF p2.up.left = p THEN p2.up.left:= p2;
                    ELSE p2.up.right:= p2;
                    END;
                    p:= p2;
                END;
                p.bal:= 0;
                RETURN;
            END;
        ELSE  (* right branch grows up   *)
            CASE p.bal OF
                -1: p.bal:= 0;  RETURN;
                |0 : p.bal:= 1;
                |1 : (* balance *)
                IF cur.bal = 1 THEN  (* single RR turn *)
                    p.right:= cur.left;
                    IF cur.left # NIL THEN cur.left.up:= p END;
                    cur.left:= p; cur.up:= p.up; p.up:= cur;
                    p.bal:= 0;
                    IF p = this.up THEN this.up:= cur
                    ELSIF cur.up.left = p THEN cur.up.left:= cur;
                    ELSE  cur.up.right:= cur;
                    END;
                    p:= cur;
                ELSE  (* double RL turn *)
                    p2:= cur.left;
                    cur.left:= p2.right;
                    IF p2.right # NIL THEN  p2.right.up:= cur END;
                    p2.right:= cur; cur.up:= p2;
                    p.right:= p2.left;
                    IF p2.left # NIL THEN  p2.left.up:= p    END;
                    p2.left:= p; p2.up:= p.up; p.up:= p2;
                    IF p2.bal =  1 THEN  p.bal:= -1   ELSE  p.bal:= 0    END;
                    IF p2.bal = -1 THEN  cur.bal:= 1  ELSE  cur.bal:= 0  END;
                    IF p = this.up THEN this.up:= p2
                    ELSIF p2.up.left = p THEN p2.up.left:= p2;
                    ELSE p2.up.right:= p2;
                    END;
                    p:= p2;
                END;
                p.bal:= 0;
                RETURN;
            END;
        END;
        cur:= cur.up;
    END;
END Insert;

(* left branch grows down *)
PROCEDURE BalanceL(VAR p: TreeNode; t: TreeNode; VAR h: BOOLEAN);
    VAR p1, p2: TreeNode;
        b1, b2: LONGINT;
BEGIN
    CASE p.bal OF
        -1: p.bal:= 0;
        |0 : p.bal:= 1;  h:= FALSE;
        |1 : (* balance *)
            p1:= p.right; b1:= p1.bal;
            IF b1 >= 0 THEN  (* single RR turn *)
                p.right:= p1.left;
                IF p1.left # NIL THEN p1.left.up:= p END;
                p1.left:= p; p1.up:= p.up; p.up:= p1;
                IF b1 = 0 THEN p.bal:= 1; p1.bal:= -1; h:= FALSE;
                ELSE p.bal:= 0; p1.bal:= 0;
                END;
                IF p = t.up THEN t.up:= p1;
                ELSIF p1.up.left = p THEN p1.up.left:= p1;
                ELSE  p1.up.right:= p1;
                END;
                p:= p1;
            ELSE  (* double RL turn *)
                p2:= p1.left;  b2:= p2.bal;
                p1.left:= p2.right;
                IF p2.right # NIL THEN  p2.right.up:= p1 END;
                p2.right:= p1; p1.up:= p2;
                p.right:= p2.left;
                IF p2.left # NIL THEN  p2.left.up:= p END;
                p2.left:= p; p2.up:= p.up; p.up:= p2;
                IF b2 =  1 THEN  p.bal:= -1   ELSE  p.bal:= 0    END;
                IF b2 = -1 THEN  p1.bal:= 1   ELSE  p1.bal:= 0   END;
                IF p = t.up THEN t.up:= p2
                ELSIF p2.up.left = p THEN p2.up.left:= p2;
                ELSE p2.up.right:= p2;
                END;
                p:= p2;
                p2.bal:= 0;
            END;
    END;
END BalanceL;

(* right branch grows down *)
PROCEDURE BalanceR(VAR p: TreeNode; t: TreeNode; VAR h: BOOLEAN);
    VAR p1, p2: TreeNode;
        b1, b2: LONGINT;
BEGIN
    CASE p.bal OF
     1 : p.bal:= 0;
    |0 : p.bal:= -1; h:= FALSE;
    |-1: (* balance *)
        p1:= p.left; b1:= p1.bal;
        IF b1 <= 0 THEN (* single LL turn *)
            p.left:= p1.right;
            IF p1.right # NIL THEN p1.right.up:= p END;
            p1.right:= p; p1.up:= p.up; p.up:= p1;
            IF b1 = 0 THEN p.bal:= -1; p1.bal:= 1; h:= FALSE;
            ELSE p.bal:= 0; p1.bal:= 0;
            END;
            IF p = t.up THEN t.up:= p1;
            ELSIF p1.up.left = p THEN p1.up.left:= p1;
            ELSE p1.up.right:= p1;
            END;
            p:= p1;
        ELSE (* double LR turn *)
            p2:= p1.right; b2:= p2.bal;
            p1.right:= p2.left;
            IF p2.left # NIL THEN p2.left.up:= p1 END;
            p2.left:= p1; p1.up:= p2;
            p.left:= p2.right;
            IF p2.right # NIL THEN p2.right.up:= p END;
            p2.right:= p; p2.up:= p.up; p.up:= p2;
            IF b2 = -1 THEN  p.bal:= 1     ELSE  p.bal:= 0    END;
            IF b2 =  1 THEN  p1.bal:= -1   ELSE  p1.bal:= 0   END;
            IF p = t.up THEN t.up:= p2
            ELSIF p2.up.left = p THEN p2.up.left:= p2;
            ELSE p2.up.right:= p2;
            END;
            p:= p2;
            p2.bal:= 0;
        END;
    END;
END BalanceR;

(** Remove element from tree if found *)
PROCEDURE (this: Tree) Remove*(e: ADT.Element);
    CONST root  = 0;
          right = 1;
          left  = 2;
    VAR p: TreeNode;
        h: BOOLEAN;
        direction: LONGINT;

    PROCEDURE Del(r: TreeNode; VAR h: BOOLEAN);
    BEGIN
        WHILE r.right # NIL DO r:= r.right END;
        p.element:= r.element;
        IF r.up = p THEN p.left:= r.left;
        ELSE r.up.right:= r.left;
        END;
        IF r.left # NIL THEN r.left.up:= r.up END;
        h:= TRUE;
        r:= r.up; (* balance *)
        WHILE ( h ) & ( r # p ) DO
            BalanceR( r, this, h );
            r:= r.up;
        END;
    END Del;
BEGIN
    IF(e = NIL) OR (this.up = NIL) THEN RETURN END;
    p:= this.up;
    direction:= root;
    LOOP
        IF p = NIL THEN RETURN END;
        CASE e.Compare(p.element) OF
         EQUAL  : EXIT;
        |GREATER: p:= p.right;    direction:= right;
        |LESS   : p:= p.left;     direction:= left;
        ELSE RETURN;
        END;
    END;
    DEC(this.size);
    this.minimum := p.Next();
    IF this.up.up = p THEN this.up.up:= NIL END;
    IF p.right = NIL THEN
        h:= TRUE;
        IF p.left # NIL THEN p.left.up:= p.up  END;
        CASE direction OF
         root : this.up:= p.left;
                RETURN;
        |right: p.up.right:= p.left;
                p:= p.up;
                BalanceR(p, this, h);
        |left : p.up.left:= p.left;
                p:= p.up;
                BalanceL(p, this, h);
        END;
    ELSIF p.left = NIL THEN
        h:= TRUE;
        p.right.up:= p.up;
        CASE direction OF
        root : this.up:= p.right;
                RETURN;
        |right: p.up.right:= p.right;
                p:= p.up;
                BalanceR(p, this, h);
        |left : p.up.left:= p.right;
                p:= p.up;
                BalanceL(p, this, h);
        END;
    ELSE
        Del(p.left, h);
        IF h THEN BalanceL(p, this, h) END;
    END;
    (* balance *)
    WHILE (h) & (p # this.up) DO
        IF p.up.left = p THEN
            p:= p.up;
            BalanceL(p, this, h);
        ELSE
            p:= p.up;
            BalanceR(p, this, h);
        END;
    END;
END Remove;

END ADTTree.