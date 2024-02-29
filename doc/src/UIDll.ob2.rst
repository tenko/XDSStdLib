.. index::
    single: UIDll

.. _UIDll:

*****
UIDll
*****

Const
=====

.. code-block:: modula2

    ForEachContinue* 		        = 0;

.. code-block:: modula2

    ForEachStop*                    = 1;

.. code-block:: modula2

    AlignFill*                      = 0;

.. code-block:: modula2

    AlignStart*                     = 1;

.. code-block:: modula2

    AlignCenter*                    = 2;

.. code-block:: modula2

    AlignEnd*                       = 3;

.. code-block:: modula2

    AtLeading*                      = 0;

.. code-block:: modula2

    AtTop*                          = 1;

.. code-block:: modula2

    AtTrailing*                     = 2;

.. code-block:: modula2

    AtBottom*                       = 3;

.. code-block:: modula2

    WindowResizeEdgeLeft*           = 0;

.. code-block:: modula2

    WindowResizeEdgeTop*            = 1;

.. code-block:: modula2

    WindowResizeEdgeRight*          = 2;

.. code-block:: modula2

    WindowResizeEdgeBottom*         = 3;

.. code-block:: modula2

    WindowResizeEdgeTopLeft*        = 4;

.. code-block:: modula2

    WindowResizeEdgeTopRight*       = 5;

.. code-block:: modula2

    WindowResizeEdgeBottomLeft*     = 6;

.. code-block:: modula2

    WindowResizeEdgeBottomRight*    = 7;

.. code-block:: modula2

    DrawBrushTypeSolid*             = 0;

.. code-block:: modula2

    DrawBrushTypeLinearGradient*    = 1;

.. code-block:: modula2

    DrawBrushTypeRadialGradient*    = 2;

.. code-block:: modula2

    DrawBrushTypeImage*             = 3;

.. code-block:: modula2

    DrawLineCapFlat*                = 0;

.. code-block:: modula2

    DrawLineCapRound*               = 1;

.. code-block:: modula2

    DrawLineCapSquare*              = 2;

.. code-block:: modula2

    DrawLineJoinMiter*              = 0;

.. code-block:: modula2

    DrawLineJoinRound*              = 1;

.. code-block:: modula2

    DrawLineJoinBevel*              = 2;

.. code-block:: modula2

    DrawFillModeWinding*            = 0;

.. code-block:: modula2

    DrawFillModeAlternate*          = 1;

.. code-block:: modula2

    TableValueTypeString*           = 0;

.. code-block:: modula2

    TableValueTypeImage*            = 1;

.. code-block:: modula2

    TableValueTypeInt*              = 2;

.. code-block:: modula2

    TableValueTypeColor*            = 3;

.. code-block:: modula2

    TableModelColumnNeverEditable*  = -1;

.. code-block:: modula2

    TableModelColumnAlwaysEditable* = -2;

.. code-block:: modula2

    TableSelectionModeNone*         = 0;

.. code-block:: modula2

    TableSelectionModeZeroOrOne*    = 1;

.. code-block:: modula2

    TableSelectionModeOne*          = 3;

.. code-block:: modula2

    TableSelectionModeZeroOrMany*   = 4;

.. code-block:: modula2

    SortIndicatorNone*              = 0;

.. code-block:: modula2

    SortIndicatorAscending*         = 1;

.. code-block:: modula2

    SortIndicatorDescending*        = 2;

Vars
====

.. code-block:: modula2

    x : INT;

.. code-block:: modula2

    y : INT);

.. code-block:: modula2

    width : INT;

.. code-block:: modula2

    height : INT);

.. code-block:: modula2

    time : TM);

.. code-block:: modula2

    time : TM);

.. code-block:: modula2

    x : LONGREAL;

.. code-block:: modula2

    y : LONGREAL);

.. code-block:: modula2

    x : LONGREAL;

.. code-block:: modula2

    y : LONGREAL);

.. code-block:: modula2

    r : LONGREAL;

.. code-block:: modula2

    g : LONGREAL;

.. code-block:: modula2

    bl : LONGREAL;

.. code-block:: modula2

    a : LONGREAL);

.. code-block:: modula2

    r : LONGREAL;

.. code-block:: modula2

    g : LONGREAL;

.. code-block:: modula2

    b : LONGREAL;

.. code-block:: modula2

    a : LONGREAL);

.. code-block:: modula2

    textParams : TableTextColumnOptionalParams);

.. code-block:: modula2

    textParams : TableTextColumnOptionalParams);

.. code-block:: modula2

    textParams : TableTextColumnOptionalParams);

Procedures
==========

.. _UIDll.CStringLength:

CStringLength
-------------

.. code-block:: modula2

    PROCEDURE CStringLength*(adr : ADDRESS): LONGINT;

.. _UIDll.CStringCopy:

CStringCopy
-----------

.. code-block:: modula2

    PROCEDURE CStringCopy*(VAR dst : ARRAY OF CHAR; adr : ADDRESS);

.. _UIDll.CopyText:

CopyText
--------

.. code-block:: modula2

    PROCEDURE CopyText*(VAR dst : String.STRING; src :PCHAR);

