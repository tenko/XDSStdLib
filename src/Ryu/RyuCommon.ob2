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
MODULE RyuCommon;

IMPORT SYSTEM;

TYPE
    INT32 = SYSTEM.INT32;
    CARD32 = SYSTEM.CARD32;

(* Returns e == 0 ? 1 : [log_2(5^e)]; requires 0 <= e <= 3528. *)
PROCEDURE Log2Pow5*(e : INT32): INT32;
BEGIN
    (* This approximation works up to the point that the multiplication overflows at e = 3529.
       If the multiplication were done in 64 bits, it would fail at 5^4004 which is just greater
       than 2^9297.
    *)
    ASSERT(e >= 0);
    ASSERT(e <= 3528);
    RETURN VAL(INT32, ((VAL(CARD32, e) * 1217359) >> 19));
END Log2Pow5;

(* Returns e == 0 ? 1 : ceil(log_2(5^e)); requires 0 <= e <= 3528. *)
PROCEDURE Pow5Bits*(e : INT32): INT32;
BEGIN
    (* This approximation works up to the point that the multiplication overflows at e = 3529.
       If the multiplication were done in 64 bits, it would fail at 5^4004 which is just greater
       than 2^9297.
    *)
    ASSERT(e >= 0);
    ASSERT(e <= 3528);
    RETURN VAL(INT32, (VAL(CARD32, e) * 1217359) >> 19 + 1);
END Pow5Bits;

(* Returns e == 0 ? 1 : ceil(log_2(5^e)); requires 0 <= e <= 3528. *)
PROCEDURE CeilLog2Pow5*(e : INT32): INT32;
BEGIN
    RETURN Log2Pow5(e) + 1;
END CeilLog2Pow5;

END RyuCommon.
<* POP *>
