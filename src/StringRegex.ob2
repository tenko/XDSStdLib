(**
This module is the RegCom module from the XDS compiler.
Copyright (c) 1993 xTech Ltd, Russia. All Rights Reserved.
Modified for inclusion in library.

A regular expression is a string which may contain certain special symbols:

* `"*"` - an arbitrary sequence of any characters, possibly empty.
* `"?"` - any single character.
* `"[...]"` - one of the listed characters.
* `"{...}"` - an arbitrary sequence of the listed characters, possibly empty.
* `"\nnn"` - the ASCII character with octal code nnn, where n is [0-7].
* `"&"` - the logical operation AND.
* `"|"` - the logical operation OR.
* `"^"` - the logical operation NOT.
* `"(...)"` - the priority of operations.
* `"$digit"` - subexpression number (see below).

A sequence of the form `a-b` used within either `[]` or `{}` brackets
denotes all characters from `a` to `b`.

`$digit` may follow `*`, `?`, `[]`, `{}` or `()` subexpression.
For a string matching a regular expression, it represents the
corresponding substring.

If you need to use any special symbol as an ordinary symbol, you should precede
it with a backslash (`\`), which suppresses interpretation of the following symbol.
*)
MODULE StringRegex;
IMPORT ArrayOfChar;

CONST
  str = 0;
  any = 1; -- "?"
  set = 2; -- "[]"
  bra = 3; -- "{}"
  seq = 4; -- "*"
  and = 5; -- "&"
  or  = 6; -- "|"
  not = 7; -- "^"
  par = 8; -- "()"

CONST ok = 0;  badParm = 1;

TYPE
  Pattern* = POINTER TO PatternDesc;
  char_set  = POINTER TO ARRAY 8 OF SET;
  RESULT    = RECORD pos,len: ARRAY 10 OF LONGINT END;
  PatternDesc  = RECORD
    next: Pattern;
    nres: INTEGER;
    res : POINTER TO RESULT;
    kind: INTEGER;
    left: Pattern; (* right=next *)
    pat : POINTER TO ARRAY OF CHAR;
    leg : char_set;
  END;

PROCEDURE pars_reg(expr-: ARRAY OF CHAR; VAR reg: Pattern;
                   VAR    i: LONGINT;
                   VAR  res: LONGINT);

  PROCEDURE app(VAR reg: Pattern; r: Pattern);
    VAR t: Pattern;
  BEGIN
    IF reg=NIL THEN reg:=r; RETURN END;
    t:=reg;
    WHILE t^.next#NIL DO t:=t^.next END;
    IF (t^.kind=seq) & (r^.kind=seq) THEN
      res:=badParm
    ELSE
      t^.next:=r
    END;
  END app;

  PROCEDURE new(kind: INTEGER): Pattern;
    VAR n: Pattern;
  BEGIN
    NEW(n);
    n.kind:=kind;
    n.nres:=-1;
    n.next:=NIL;
    n.res:=NIL;
    n.left:=NIL;
    n.pat :=NIL;
    n.leg :=NIL;
    RETURN n
  END new;

  PROCEDURE app_new(VAR reg: Pattern; kind: INTEGER): Pattern;
    VAR n: Pattern;
  BEGIN
    n:=new(kind);
    app(reg,n);
    RETURN n
  END app_new;

  PROCEDURE dollar(n: Pattern);
    VAR ch: CHAR;
  BEGIN
    IF res#ok THEN RETURN END;
    IF (i>=LEN(expr)-1) OR (expr[i]#'$') THEN RETURN END;
    ch:=expr[i+1];
    IF ("0"<=ch) & (ch<="9") THEN
      n^.nres:=ORD(ch)-ORD("0"); INC(i,2)
    ELSE
      res:=badParm
    END
  END dollar;

  PROCEDURE char_code(c: CHAR; VAR j: LONGINT): CHAR;
    VAR n: INTEGER;
  BEGIN
    c:=CHR(ORD(c)-ORD('0'));
    FOR n:=0 TO 1 DO
      IF (j<LEN(expr)) & ('0'<=expr[j]) & (expr[j]<='7') THEN
        c:=CHR( ORD(c)*8+ORD(expr[j])-ORD('0') );
        INC(j)
      ELSE
        res:=badParm;
        RETURN c
      END;
    END;
    RETURN c
  END char_code;

  PROCEDURE esc(VAR j: LONGINT): CHAR;
    VAR c: CHAR;
  BEGIN
    INC(j); c:=expr[j]; INC(j);
    IF ('0'<=c) & (c<='7') THEN RETURN char_code(c,j)
    ELSE RETURN c
    END;
  END esc;

  PROCEDURE fill_set(n: Pattern);

    VAR from: CHAR;
       range: BOOLEAN;

    PROCEDURE incl(ch: CHAR);
      VAR i: INTEGER;
    BEGIN
      IF NOT range THEN
        INCL(n^.leg^[ORD(ch) DIV 32],ORD(ch) MOD 32); RETURN
      END;
      IF from>ch THEN res:=badParm; RETURN END;
      FOR i:=ORD(from) TO ORD(ch) DO
        INCL(n^.leg^[i DIV 32],i MOD 32);
      END;
      range:=FALSE;
    END incl;

    VAR j: INTEGER;
     q,ch: CHAR;
      inv: BOOLEAN;

  BEGIN
    IF res#0 THEN RETURN END;
    NEW(n^.leg);
    FOR j:=0 TO LEN(n^.leg^)-1 DO n^.leg^[j]:={} END;
    range:=FALSE; from:=0X; ch:=0X; (* !!!!? Sem *)
    IF expr[i]='[' THEN q:=']' ELSE q:='}'; n^.kind:=bra END;
    INC(i);
    inv:=(i<LEN(expr)) & (expr[i]="^");
    IF inv THEN INC(i) END;
    IF (i<LEN(expr)) & (expr[i]=q) THEN
      res:=badParm; RETURN
    END;
    WHILE (i<LEN(expr)) & (expr[i]#q) & (expr[i]#0C) & (res=ok) DO
      IF (expr[i]='\') & (i<LEN(expr)-1) & (expr[i+1]#0C) THEN
        ch:=esc(i);
        incl(ch);
      ELSIF (expr[i]='-') & (i<LEN(expr)-1) & (expr[i+1]#q) THEN
        from:=ch;    (* save pred char *)
        range:=TRUE; (* next char will be right bound of the range *)
        INC(i);
      ELSE
        ch:=expr[i];
        incl(ch);
        INC(i);
      END;
    END;
    IF res#ok THEN RETURN END;
    IF (i>=LEN(expr)) OR (expr[i]#q) OR range THEN
      res:=badParm
    ELSE
      INC(i);
      IF NOT inv THEN RETURN END;
      FOR j:=0 TO LEN(n^.leg^)-1 DO n^.leg^[j]:=n^.leg^[j]/{0..31} END;
    END;
  END fill_set;

  PROCEDURE fill_str(n: Pattern);

    PROCEDURE scan(put: BOOLEAN): LONGINT;
      VAR ch: CHAR;
         c,j: LONGINT;
    BEGIN
      j:=i; c:=0;
      WHILE j<LEN(expr) DO
        ch:=expr[j];
        IF (ch= 0C) OR (ch='[') OR (ch='*') OR (ch='?') OR (ch='{')
        OR (ch=')') OR (ch='&') OR (ch='|') OR (ch='^') OR (ch='$')
        THEN
          IF put THEN i:=j END;
          RETURN c
        ELSIF (ch='\') & (j<LEN(expr)-1) & (expr[j+1]#0C) THEN
          ch:=esc(j);
          IF put THEN n^.pat[c]:=ch END;
          INC(c);
        ELSE
          IF put THEN n^.pat[c]:=expr[j] END;
          INC(c);
          INC(j);
        END;
      END;
      IF put THEN i:=j END;
      RETURN c
    END scan;

  BEGIN
    IF res#ok THEN RETURN END;
    NEW(n^.pat,scan(FALSE)+1);
    n^.pat[scan(TRUE)]:=0C;
  END fill_str;

  PROCEDURE simple(VAR reg: Pattern): LONGINT;
    VAR n: Pattern;
       ch: CHAR;
  BEGIN
    IF res#ok THEN RETURN res END;
    IF (i>LEN(expr)-1) OR (expr[i]=0C) THEN RETURN badParm END;
    LOOP
      IF (res#ok) OR (i>LEN(expr)-1) THEN EXIT END;
      ch:=expr[i];
      IF (ch= 0C) OR (ch=')') OR (ch='(')
      OR (ch='|') OR (ch='&') OR (ch='^') THEN EXIT END;
      IF    ch='*' THEN n:=app_new(reg,seq); INC(i);
      ELSIF ch='?' THEN n:=app_new(reg,any); INC(i);
      ELSIF ch='{' THEN n:=app_new(reg,set); fill_set(n);
      ELSIF ch='[' THEN n:=app_new(reg,set); fill_set(n);
      ELSE
        n:=app_new(reg,str); fill_str(n);
      END;
      dollar(n)
    END;
    RETURN res
  END simple;

  PROCEDURE ^ re(VAR reg: Pattern): LONGINT;

  PROCEDURE factor(VAR reg: Pattern): LONGINT;
  VAR last: Pattern;
  BEGIN
    reg:=NIL;
    IF res#ok THEN RETURN res END;
    IF (i>LEN(expr)-1) OR (expr[i]=0C) THEN RETURN badParm END;
    IF expr[i]='(' THEN INC(i);
      reg:=new(par);            IF res#ok THEN RETURN res END;
      res:=re(reg^.next);       IF res#ok THEN RETURN res END;
      IF expr[i]=')' THEN INC(i); dollar(reg)
      ELSE res:=badParm
      END;
    ELSIF expr[i]='^' THEN
      INC(i);
      reg:=new(not);            IF res#ok THEN RETURN res END;
      res:=factor(reg^.next);   IF res#ok THEN RETURN res END;
      IF reg^.next^.nres>=0 THEN
        reg^.nres:=reg^.next^.nres; reg^.next^.nres:=-1
      END
    ELSE
      res:=simple(reg);
      IF (res = ok) & (i < LEN(expr)) & ((expr[i] = '^') OR (expr[i] = '(')) THEN
        last := reg;
        WHILE (last.next # NIL) & (last.kind IN {str,any,set,bra}) DO
          last := last.next
        END;
        res := factor(last.next);
      END;
    END;
    RETURN res
  END factor;

  PROCEDURE term(VAR reg: Pattern): LONGINT;
    VAR t: Pattern;
  BEGIN
    reg:=NIL;
    IF res#ok THEN RETURN res END;
    IF (i>LEN(expr)-1) OR (expr[i]=0C) THEN RETURN badParm END;
    res:=factor(reg);
    IF (i<LEN(expr)-1) & (expr[i]='&') & (res=ok) THEN
      t:=new(and);      INC(i);
      t^.left:=reg; reg:=t;
      res:=term(t^.next);
    END;
    RETURN res
  END term;

  PROCEDURE re(VAR reg: Pattern): LONGINT;
    VAR t: Pattern;
  BEGIN
    reg:=NIL;
    IF res#ok THEN RETURN res END;
    IF (i>LEN(expr)-1) OR (expr[i]=0C) THEN RETURN badParm END;
    res:=term(reg);
    IF (i<LEN(expr)-1) & (expr[i]='|') & (res=ok) THEN
      t:=new(or);       INC(i);
      t^.left:=reg; reg:=t;
      res:=re(t^.next);
    END;
    RETURN res
  END re;

BEGIN
  reg:=NIL;
  res:=ok;
  res:=re(reg);
END pars_reg;

PROCEDURE match0(reg: Pattern;           s-: ARRAY OF CHAR;
                   p: LONGINT;  VAR stop: LONGINT; VAR rs: RESULT
                ): BOOLEAN;

  VAR n: INTEGER; (* reg^.nres *)

  PROCEDURE bra_seq_end(): BOOLEAN;
  BEGIN
    WHILE (reg#NIL) & (reg^.kind IN {bra,seq}) DO reg:=reg^.next END;
    IF reg#NIL THEN RETURN FALSE END;
    IF n>=0 THEN rs.len[n]:=p-rs.pos[n] END; stop:=p;
    RETURN TRUE
  END bra_seq_end;

  VAR i: LONGINT;

BEGIN
  stop:=p;
  IF reg=NIL THEN RETURN (p>LEN(s)-1) OR (s[p]=0C) END;
  n:=reg^.nres;
  IF (p>LEN(s)-1) OR (s[p]=0C) THEN
    RETURN (reg=NIL) OR ((reg^.kind IN {seq,bra}) & (reg^.next=NIL))
  END;
  IF reg^.kind=any THEN
    IF n>=0 THEN rs.pos[n]:=p; rs.len[n]:=1 END;
    RETURN match0(reg^.next,s,p+1,stop,rs);
  ELSIF reg^.kind=seq THEN
    IF n>=0 THEN rs.pos[n]:=p END;
    WHILE (p<LEN(s)) & (s[p]#0C) DO
      IF match0(reg^.next,s,p,stop,rs) THEN
        IF n>=0 THEN rs.len[n]:=p-rs.pos[n] END;
        RETURN TRUE
      END;
      p:=p+1
    END;
    RETURN bra_seq_end()
  ELSIF reg^.kind=set THEN
    i:=ORD(s[p]);
    IF NOT (i MOD 32 IN reg^.leg^[i DIV 32]) THEN RETURN FALSE END;
    IF n>=0 THEN rs.pos[n]:=p; rs.len[n]:=1 END;
    RETURN match0(reg^.next,s,p+1,stop,rs);
  ELSIF reg^.kind=bra THEN
    IF n>=0 THEN rs.pos[n]:=p END;
    WHILE (p<LEN(s)-1) & (s[p]#0C) DO
      IF match0(reg^.next,s,p,stop,rs) THEN
        IF n>=0 THEN rs.len[n]:=p-rs.pos[n] END;
        RETURN TRUE
      END;
      i:=ORD(s[p]);
      IF NOT (i MOD 32 IN reg^.leg^[i DIV 32]) THEN RETURN FALSE END;
      p:=p+1
    END;
    RETURN bra_seq_end()
  ELSIF reg^.kind=str THEN
    IF n>=0 THEN rs.pos[n]:=p END;
    FOR i:=0 TO LEN(reg^.pat^)-2 DO
      IF s[p]#reg^.pat[i] THEN RETURN FALSE END;
      INC(p)
    END;
    IF n>=0 THEN rs.len[n]:=p-rs.pos[n] END;
    RETURN match0(reg^.next,s,p,stop,rs);
  ELSIF reg^.kind=and THEN
    RETURN match0(reg^.left,s,p,stop,rs)
         & match0(reg^.next,s,p,stop,rs)
  ELSIF reg^.kind=or THEN
    RETURN match0(reg^.left,s,p,stop,rs)
        OR match0(reg^.next,s,p,stop,rs)
  ELSIF reg^.kind=not THEN
    IF n>=0 THEN rs.pos[n]:=p END;
    IF match0(reg^.next,s,p,stop,rs) THEN
      RETURN FALSE
    ELSE
      WHILE (p<LEN(s)-1) & (s[p]#0C) DO INC(p) END; stop:=p;
      IF n>=0 THEN rs.len[n]:=stop-rs.pos[n] END;
      RETURN TRUE
    END
  ELSIF reg^.kind=par THEN
    IF n>=0 THEN rs.pos[n]:=p END;
    IF match0(reg^.next,s,p,stop,rs) THEN
      IF n>=0 THEN rs.len[n]:=stop-rs.pos[n] END;
      RETURN TRUE
    END;
    RETURN FALSE
  ELSE
    ASSERT(FALSE,4Fh)
  END
END match0;

(**
Compile the regular expression expr and return status:

* `res` <= 0 : error at position `ABS(res)` in expr;
* `res` >  0 : no error.
*)
PROCEDURE Compile*(VAR reg: Pattern; expr-: ARRAY OF CHAR; VAR res: LONGINT);
  VAR i,code: LONGINT;
BEGIN
  IF reg = NIL THEN NEW(reg) END;
  i:=0;
  pars_reg(expr,reg,i,code);
  IF code#ok THEN res:=-i; RETURN END;
  IF (i<LEN(expr)) & (expr[i]#0C) THEN
    res:=-i;
  ELSE
    res:=i;
    NEW(reg^.res);
    FOR i:=0 TO LEN(reg^.res^.len)-1 DO reg^.res^.len[i]:=0 END;
    reg^.res^.pos:=reg^.res^.len;
  END;
END Compile;

(**
Returns `TRUE`, if expression matches with string `s` starting
from position `pos`.
*)
PROCEDURE (re : Pattern) Match*(s-: ARRAY OF CHAR; pos := 0 : LONGINT): BOOLEAN;
  VAR
    i: LONGINT;
    ret : BOOLEAN;
BEGIN
  FOR i:=0 TO LEN(re^.res^.len)-1 DO re^.res^.len[i]:=0 END;
  re^.res^.pos:=re^.res^.len;
  ret := match0(re,s,pos,i,re^.res^);
  IF re.nres = -1 THEN
    re^.res^.pos[0] := pos;
    re^.res^.len[0] := i;
  END;
  RETURN ret;
END Match;

(**
Returns `TRUE`, if expression matches with whole string `s`.
*)
PROCEDURE (re : Pattern) FullMatch*(s-: ARRAY OF CHAR): BOOLEAN;
  VAR
    i: LONGINT;
    ret : BOOLEAN;
BEGIN
  FOR i:=0 TO LEN(re^.res^.len)-1 DO re^.res^.len[i]:=0 END;
  re^.res^.pos:=re^.res^.len;
  ret := match0(re,s,0,i,re^.res^);
  IF re.nres = -1 THEN
    re^.res^.pos[0] := 0;
    re^.res^.len[0] := i;
  END;
  RETURN ret & (i = ArrayOfChar.Length(s))
END FullMatch;

(**
Returns the length of  the  substring matched to `$n`
at last call of match procedure with parameter `re`.
*)
PROCEDURE (re : Pattern) MatchLength*(n := 0 : INTEGER): LONGINT;
BEGIN
  RETURN re^.res^.len[n]
END MatchLength;

(**
Returns the position of the  beginning  of  the  substring
matched to `$n` at last call of match procedure with
parameter `re`.
*)
PROCEDURE (re : Pattern) MatchPos*(n := 0 : INTEGER): LONGINT;
BEGIN
  RETURN re^.res^.pos[n]
END MatchPos;

END StringRegex.

Date Example
------------

.. code-block:: modula2
    
    <* +MAIN *>
    MODULE TestRegex;
    IMPORT String, Re := StringRegex, 
    VAR   
        s : String.STRING;
        str : ARRAY 32 OF CHAR;
        re : Re.Pattern;
        res : LONGINT;
        ret : BOOLEAN;
        PROCEDURE Assert(b: BOOLEAN; id: LONGINT) ;
        BEGIN
            ASSERT(b);
        END Assert ;
    BEGIN
        Re.Compile(re, "(([0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9])|([0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]))", res);
        Assert(res > 0, 1);
        ret := re.FullMatch("01-01-2023");
        Assert(ret, 2);
        Assert(re.MatchPos() = 0, 3);
        Assert(re.MatchLength() = 10, 4);
    END TestRegex;
