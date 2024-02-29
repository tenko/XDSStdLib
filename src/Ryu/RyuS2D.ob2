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
<* IF ~ DEFINED(OPTIMIZE_SIZE) THEN *> <* NEW OPTIMIZE_SIZE- *>  <* END *>
<* IF ~ DEFINED(RYU_DEBUG) THEN *> <* NEW RYU_DEBUG- *>  <* END *>
MODULE RyuS2D;

IMPORT SYSTEM, Char, Type, LongWord, LongInt, ArrayOfByte, ArrayOfChar;
IMPORT RyuCommon, RyuD2SIntrinsics, RyuTable;

<* IF RYU_DEBUG THEN *>
IMPORT Printf;
<* END *>

CONST
    Log2Pow5                = RyuCommon.Log2Pow5;
    CeilLog2Pow5            = RyuCommon.CeilLog2Pow5;

    UMul128                 = RyuD2SIntrinsics.UMul128;
    ShiftRight128           = RyuD2SIntrinsics.ShiftRight128;
    MulShift64              = RyuD2SIntrinsics.MulShift64;
    Pow5Factor              = RyuD2SIntrinsics.Pow5Factor;
    MultipleOfPowerOf5      = RyuD2SIntrinsics.MultipleOfPowerOf5;
    MultipleOfPowerOf2      = RyuD2SIntrinsics.MultipleOfPowerOf2;
    
DoubleComputePow5           = RyuTable.DoubleComputePow5;
DoubleComputeInvPow5        = RyuTable.DoubleComputeInvPow5;

    DOUBLE_POW5_BITCOUNT        = RyuTable.DOUBLE_POW5_BITCOUNT;
    DOUBLE_POW5_INV_BITCOUNT    = RyuTable.DOUBLE_POW5_INV_BITCOUNT;
    DOUBLE_POW5_INV_TABLE_SIZE  = RyuTable.DOUBLE_POW5_INV_TABLE_SIZE;
    DOUBLE_POW5_SPLIT           = RyuTable.DOUBLE_POW5_SPLIT;
    DOUBLE_POW5_INV_SPLIT       = RyuTable.DOUBLE_POW5_INV_SPLIT;

    DOUBLE_MANTISSA_BITS = 52;
    DOUBLE_EXPONENT_BITS = 11;
    DOUBLE_EXPONENT_BIAS = 1023;

TYPE
    BYTE = Type.BYTE;
    WORD = Type.WORD;
    LONGWORD = SYSTEM.CARD64;
    INT32 = SYSTEM.INT32;
    CARD32 = SYSTEM.CARD32;
    CARD64 = SYSTEM.CARD64;

VAR
    INF : LONGREAL;

(** Bitwise shift n bits left instead of >> operator as compiler has a bug *)
PROCEDURE LSR(x : LONGWORD; n : INTEGER): LONGWORD;
VAR div : LONGWORD;
BEGIN
    IF n < 1 THEN RETURN x END;
    div := VAL(LONGWORD, 2) << (VAL(LONGWORD,n) - 1);
    IF div = 0 THEN RETURN x END;
    RETURN x DIV div
END LSR;

(* Work around 32bit limit of hex constants *)
PROCEDURE Combine(high, low : WORD): LONGWORD;
BEGIN
    RETURN (VAL(LONGWORD, high) << 32) OR VAL(LONGWORD, low);
END Combine;

PROCEDURE FloorLog2(x : CARD64): CARD32;
BEGIN
    RETURN 63 - LongWord.LZCnt(x);
END FloorLog2;

PROCEDURE Max32(x, y : INT32): CARD32;
BEGIN
    IF x > y THEN RETURN VAL(CARD32, x)
    ELSE RETURN VAL(CARD32, y) END;
END Max32;

PROCEDURE Int64Bits2Double(VAR dst : ARRAY OF BYTE; src- : ARRAY OF BYTE);
    VAR i: LONGINT ;
BEGIN
    i := 0;
    WHILE i < 8 DO dst[i] := src[i]; INC(i) END;
END Int64Bits2Double;

(** Convert string to LONGREAL *)
PROCEDURE S2D* (VAR result : LONGREAL; str- : ARRAY OF CHAR; start := 0 : LONGINT ; length := -1 : LONGINT): BOOLEAN;
    VAR
        pow5 : ARRAY 2 OF CARD64;
        i, j, len, m10digits, e10digits, dotIndex, eIndex : LONGINT;
        m10, m2, lastRemovedBit, ieee_m2, ieee : CARD64;
        e10, e2, shift : INT32;
        ieee_e2, val : CARD32;
        c : CHAR;
        signedM, signedE, trailingZeros, roundUp : BOOLEAN;
        <* IF RYU_DEBUG THEN *>
        s : ARRAY 64 OF CHAR;
        <* END *>
BEGIN
    len := length;
    IF len < 0 THEN len := ArrayOfChar.Length(str) END;
    IF len = 0 THEN RETURN FALSE END;
    m10digits := 0; e10digits := 0;
    dotIndex := len; eIndex := len;
    m10 := 0; e10 := 0;
    signedM := FALSE; signedE := FALSE;
    i := start;
    IF str[i] = '-' THEN signedM := TRUE; INC(i) END;
    LOOP
        IF i >= start + len THEN EXIT END;
        c := str[i];
        IF c = '.' THEN
            IF dotIndex # len THEN RETURN FALSE END;
            dotIndex := i;
        ELSE
            IF ~Char.IsDigit(c) THEN EXIT END;
            IF m10digits >= 17 THEN RETURN FALSE END;
            val := ORD(c) - ORD("0");
            m10 := 10 * m10 + val;
            IF m10 # 0 THEN INC(m10digits) END;
        END;
        INC(i)
    END;
    IF (i < len) & ((str[i] = 'e') OR (str[i] = 'E')) THEN
        eIndex := i; INC(i);
        IF (i < len) & ((str[i] = '-') OR (str[i] = '+')) THEN
            signedE := str[i] = '-'; INC(i);
        END;
        LOOP
            IF i >= len THEN EXIT END;
            c := str[i];
            IF ~Char.IsDigit(c) THEN RETURN FALSE END;
            IF e10digits > 3 THEN RETURN FALSE END; (* TODO: Be more lenient. Return +/-Infinity or +/-0 instead. *)
            e10 := 10 * e10 + VAL(INT32, ORD(c) - ORD("0"));
            IF e10 # 0 THEN INC(e10digits) END;
            INC(i)
        END;
    END;
    IF length < 0 THEN
        IF i < len THEN RETURN FALSE END
    ELSE
        IF i # length + start THEN RETURN FALSE END
    END;
    IF signedE THEN e10 := -e10 END;
    IF dotIndex < eIndex THEN e10 := e10 - (eIndex - dotIndex - 1) END;
    
    <* IF RYU_DEBUG THEN *>
    Printf.printf("Input=%s\n", str);
    Printf.printf("m10digits = %d\n", m10digits);
    Printf.printf("e10digits = %d\n", e10digits);
    LongWord.ToString(s, m10, 10);
    Printf.printf("m10 * 10^e10 = %s * 10^%d\n", s, e10);
    <* END *>

    IF m10 = 0 THEN
        IF signedM THEN result := -0.0
        ELSE result := 0.0 END;
        RETURN TRUE;
    END;
    IF (m10digits + e10 <= -324) OR (m10 = 0) THEN
        (* Number is less than 1e-324, which should be rounded down to 0; return +/-0.0. *)
        IF signedM THEN result := -0.0
        ELSE result := 0.0 END;
        RETURN TRUE;
    END;
    IF (m10digits + e10) >= 310 THEN
        IF signedM THEN result := -INF;
        ELSE result := INF END;
        RETURN TRUE;
    END;

    (* Convert to binary float m2 * 2^e2, while retaining information about whether the conversion
       was exact (trailingZeros).
    *)
    IF e10 >= 0 THEN
        (* The length of m * 10^e in bits is:
           log2(m10 * 10^e10) = log2(m10) + e10 log2(10) = log2(m10) + e10 + e10 * log2(5)
           We want to compute the DOUBLE_MANTISSA_BITS + 1 top-most bits (+1 for the implicit leading
           one in IEEE format). We therefore choose a binary output exponent of
           log2(m10 * 10^e10) - (DOUBLE_MANTISSA_BITS + 1).
           We use floor(log2(5^e10)) so that we get at least this many bits; better to
           have an additional bit than to not have enough bits.
        *)
        e2 := VAL(INT32, FloorLog2(m10)) + e10 + Log2Pow5(e10) - (DOUBLE_MANTISSA_BITS + 1);
        
        (* We now compute [m10 * 10^e10 / 2^e2] = [m10 * 5^e10 / 2^(e2-e10)].
           To that end, we use the DOUBLE_POW5_SPLIT table.
        *)

        (*
            #if defined(RYU_OPTIMIZE_SIZE)
                uint64_t pow5[2];
                double_computePow5(e10, pow5);
                m2 = mulShift64(m10, pow5, j);
            #else
                assert(e10 < DOUBLE_POW5_TABLE_SIZE);
                m2 = mulShift64(m10, DOUBLE_POW5_SPLIT[e10], j);
            #endif
        *)
        j := e2 - e10 - CeilLog2Pow5(e10) + DOUBLE_POW5_BITCOUNT;
        ASSERT(j >= 0);

        <* IF OPTIMIZE_SIZE THEN *>
        DoubleComputePow5(e10, pow5);
        <* ELSE *>
        pow5[0] := Combine(DOUBLE_POW5_SPLIT[e10][0], DOUBLE_POW5_SPLIT[e10][1]);
        pow5[1] := Combine(DOUBLE_POW5_SPLIT[e10][2], DOUBLE_POW5_SPLIT[e10][3]);
        <* END *>
        <* IF RYU_DEBUG THEN *>
        LongWord.ToString(s, pow5[0], 10);
        Printf.printf("pow5[0] = %s\n", s);
        LongWord.ToString(s, pow5[1], 10);
        Printf.printf("pow5[1] = %s\n", s);
        <* END *>
        m2 := MulShift64(m10, pow5, j);

        (* We also compute if the result is exact, i.e.,
           [m10 * 10^e10 / 2^e2] == m10 * 10^e10 / 2^e2.
           This can only be the case if 2^e2 divides m10 * 10^e10, which in turn requires that the
           largest power of 2 that divides m10 + e10 is greater than e2. If e2 is less than e10, then
           the result must be exact. Otherwise we use the existing multipleOfPowerOf2 function.
        *)
        trailingZeros := (e2 < e10) OR ((e2 - e10 < 64) & MultipleOfPowerOf2(m10, e2 - e10));
    ELSE    
        e2 := VAL(INT32, FloorLog2(m10)) + e10 - CeilLog2Pow5(-e10) - (DOUBLE_MANTISSA_BITS + 1);
        j := e2 - e10 + CeilLog2Pow5(-e10) - 1 + DOUBLE_POW5_INV_BITCOUNT;
        <* IF OPTIMIZE_SIZE THEN *>
        DoubleComputeInvPow5(-e10, pow5);
        <* ELSE *>
        ASSERT(-e10 < DOUBLE_POW5_INV_TABLE_SIZE);
        pow5[0] := Combine(DOUBLE_POW5_INV_SPLIT[-e10][0], DOUBLE_POW5_INV_SPLIT[-e10][1]);
        pow5[1] := Combine(DOUBLE_POW5_INV_SPLIT[-e10][2], DOUBLE_POW5_INV_SPLIT[-e10][3]);
        <* END *>
        m2 := MulShift64(m10, pow5, j);
        trailingZeros := MultipleOfPowerOf5(m10, -e10);
    END;
    
    <* IF RYU_DEBUG THEN *>
    LongWord.ToString(s, m2, 10);
    Printf.printf("m2 * 2^e2 = %s * 2^%d\n", s, e2);
    <* END *>

    (* Compute the final IEEE exponent. *)
    ieee_e2 := Max32(0, e2 + DOUBLE_EXPONENT_BIAS + VAL(INT32, FloorLog2(m2)));
    IF ieee_e2 > 07feH THEN
        IF signedM THEN result := -INF
        ELSE result := INF END;
        RETURN TRUE;
    END;

    (* We need to figure out how much we need to shift m2. The tricky part is that we need to take
       the final IEEE exponent into account, so we need to reverse the bias and also special-case
       the value 0.
    *)
    IF ieee_e2 = 0 THEN
        shift := 1 - e2 - DOUBLE_EXPONENT_BIAS - DOUBLE_MANTISSA_BITS;
    ELSE
        shift :=  VAL(INT32, ieee_e2) - e2 - DOUBLE_EXPONENT_BIAS - DOUBLE_MANTISSA_BITS;
    END;
    ASSERT(shift >= 0);
    
    <* IF RYU_DEBUG THEN *>
    Printf.printf("ieee_e2 = %d\n", ieee_e2);
    Printf.printf("shift = %d\n", shift);
    <* END *>

    (* We need to round up if the exact value is more than 0.5 above the value we computed. That's
       equivalent to checking if the last removed bit was 1 and either the value was not just
       trailing zeros or the result would otherwise be odd.
       
       We need to update trailingZeros given that we have the exact output exponent ieee_e2 now.
    *)
    trailingZeros := trailingZeros & ((m2 AND ((VAL(CARD64, 1) << (VAL(CARD64, shift) - 1)) - 1)) = 0); 
    lastRemovedBit := LSR(m2, VAL(INTEGER, shift - 1)) AND 1;
    roundUp := (lastRemovedBit # 0) & (~trailingZeros OR ((LSR(m2, VAL(INTEGER, shift)) AND 1) # 0));
    
    <* IF RYU_DEBUG THEN *>
    Printf.printf("roundUp = %d\n", ORD(roundUp));
    LongWord.ToString(s, LSR(m2, VAL(INTEGER, shift)) + VAL(CARD64, ORD(roundUp)), 10);
    Printf.printf("ieee_m2 = %s\n", s);
    <* END *>

    ieee_m2 := LSR(m2, VAL(INTEGER, shift)) + VAL(CARD64, ORD(roundUp));
    ASSERT(ieee_m2 <= (VAL(CARD64, 1) << (DOUBLE_MANTISSA_BITS + 1)));
    ieee_m2 := ieee_m2 AND (VAL(CARD64, 1) << DOUBLE_MANTISSA_BITS - VAL(CARD64, 1));
    IF (ieee_m2 = 0) & roundUp THEN ieee_e2 := ieee_e2 + 1 END;

    ieee := ((VAL(CARD64, ORD(signedM)) << DOUBLE_EXPONENT_BITS) OR VAL(CARD64, ieee_e2)) << DOUBLE_MANTISSA_BITS OR ieee_m2;
    Int64Bits2Double(result, ieee);
    RETURN TRUE;
END S2D;

(* Convert hi & lo 32bit numbers to LONGREAL *)
PROCEDURE WordsToLongReal*(VAR dst : LONGREAL; hi, lo : Type.WORD);
    VAR tmp : Type.CARD64;
BEGIN
    tmp := LongWord.Combine(hi, lo);
    Int64Bits2Double(dst, tmp);
END WordsToLongReal;

BEGIN
    WordsToLongReal(INF, 07FF00000H, 0H);
END RyuS2D.
<* POP *>