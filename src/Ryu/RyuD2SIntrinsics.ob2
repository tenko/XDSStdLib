(* Copyright 2018 Ulf Adams
   
   The contents of this file may be used under the terms of the Apache License,
   Version 2.0.
   
      (See accompanying file LICENSE-Apache or copy at
       http://www.apache.org/licenses/LICENSE-2.0)
   
   Alternatively, the contents of this file may be used under the terms of
   the Boost Software License, Version 1.0.
      (See accompanying file LICENSE-Boost or copy at
       https://www.boost.org/LICENSE_1_0.txt)
   
   Unless required by applicable law or agreed to in writing, this software
   is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
   KIND, either express or implied.

   Adapted from Ulf Adams original Ryu repo on github.
   LICENSE : Boost Software License - Version 1.0 - August 17th, 2003
*)
<* PUSH *>
<* doreorder- *>
MODULE RyuD2SIntrinsics;

IMPORT SYSTEM, Type, RyuCommon, LongWord;

TYPE
    WORD = Type.WORD;
    LONGWORD = SYSTEM.CARD64;
    CARD32 = SYSTEM.CARD32;
    CARD64 = SYSTEM.CARD64;

(** Bitwise shift n bits left instead of >> operator as compiler has a bug *)
PROCEDURE LSR(x : LONGWORD; n : INTEGER): LONGWORD;
VAR div : LONGWORD;
BEGIN
    div := VAL(LONGWORD, 2) << (VAL(LONGWORD,n) - 1);
    IF div = 0 THEN RETURN x END;
    RETURN x DIV div
END LSR;

(* Work around 32bit limit of hex constants *)
PROCEDURE Combine(high, low : WORD): LONGWORD;
BEGIN
    RETURN (VAL(LONGWORD, high) << 32) OR VAL(LONGWORD, low);
END Combine;

(* Work around 32bit limit of hex constants *)
PROCEDURE Split(x : LONGWORD; VAR high, low : WORD);
BEGIN
    high := VAL(WORD, LSR(x, 32) AND 0FFFFFFFFH);
    low := VAL(WORD, x AND 0FFFFFFFFH);
END Split;

PROCEDURE UMul128*(a, b : CARD64; VAR productHi : CARD64): CARD64;
    VAR
        aLo, aHi, bLo, bHi : CARD32;
        b00, b01, b10, b11 : CARD64;
        b00Lo, b00Hi : CARD32;
        mid1Hi, mid1Lo : CARD32;
        mid2Hi, mid2Lo : CARD32;
        mid1, mid2, pHi, pLo : CARD64;
BEGIN
    Split(a, aHi, aLo);
    Split(b, bHi, bLo);
    b00 := VAL(CARD64, aLo) * VAL(CARD64, bLo);
    b01 := VAL(CARD64, aLo) * VAL(CARD64, bHi);
    b10 := VAL(CARD64, aHi) * VAL(CARD64, bLo);
    b11 := VAL(CARD64, aHi) * VAL(CARD64, bHi);
    Split(b00, b00Hi, b00Lo);
    mid1 := b10 + b00Hi;
    Split(mid1, mid1Hi, mid1Lo);
    mid2 := b01 + mid1Lo;
    Split(mid2, mid2Hi, mid2Lo);
    pHi := b11 + mid1Hi + mid2Hi;
    pLo := Combine(mid2Lo, b00Lo);
    productHi := pHi;
    RETURN pLo;
END UMul128;

PROCEDURE ShiftRight128*(lo, hi : CARD64; dist : CARD32): CARD64;
BEGIN
    (* We don't need to handle the case dist >= 64 here (see above). *)
    ASSERT(dist < 64);
    ASSERT(dist > 0);
    RETURN (hi << (64 - dist)) OR LSR(lo, VAL(INTEGER, dist));
END ShiftRight128;

PROCEDURE MulShift64*(m : CARD64; mul : ARRAY OF CARD64; j : CARD32): CARD64;
    VAR
        high0, low1, high1, sum, tmp : CARD64;
BEGIN
    (* m is maximum 55 bits *)
    <* PUSH *>
    <* COVERFLOW - *>
    low1 := UMul128(m, mul[1], high1); 
    tmp := UMul128(m, mul[0], high0);
    sum := high0 + low1;
    IF sum < high0 THEN high1 := high1 + 1 END; (* overflow into high1 *)
    RETURN ShiftRight128(sum, high1, j - 64);
    <* POP *>
END MulShift64;

PROCEDURE Pow5Factor*(value : CARD64): CARD32;
    VAR
        m_inv_5, n_div_5: CARD64;
        count : CARD32;
BEGIN
    m_inv_5 := Combine(0CCCCCCCCH, 0CCCCCCCDH);
    n_div_5 := Combine(033333333H, 033333333H);
    count := 0;
    LOOP
        --ASSERT(value # 0);
        value := value * m_inv_5;
        IF value > n_div_5 THEN EXIT END;
        count := count + 1
    END;
    RETURN count;
END Pow5Factor;

(* Returns true if value is divisible by 5^p. *)
PROCEDURE MultipleOfPowerOf5*(value : CARD64; p : CARD32): BOOLEAN;
BEGIN
    RETURN Pow5Factor(value) >= p;
END MultipleOfPowerOf5;

(* Returns true if value is divisible by 2^p. *)
PROCEDURE MultipleOfPowerOf2*(value : CARD64; p : CARD32): BOOLEAN;
BEGIN
    ASSERT(value # 0);
    ASSERT(p < 64);
    RETURN (value AND ((VAL(CARD32, 1) << p) - 1)) = 0;
END MultipleOfPowerOf2;

END RyuD2SIntrinsics.
<* POP *>
