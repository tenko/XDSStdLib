MODULE UIDll;

IMPORT SYSTEM,  dllRTS, String;

CONST
    ForEachContinue* 		        = 0;
    ForEachStop*                    = 1;
    AlignFill*                      = 0;
	AlignStart*                     = 1;
	AlignCenter*                    = 2;
	AlignEnd*                       = 3;
    AtLeading*                      = 0;
	AtTop*                          = 1;
	AtTrailing*                     = 2;
	AtBottom*                       = 3;
    WindowResizeEdgeLeft*           = 0;
	WindowResizeEdgeTop*            = 1;
	WindowResizeEdgeRight*          = 2;
	WindowResizeEdgeBottom*         = 3;
	WindowResizeEdgeTopLeft*        = 4;
	WindowResizeEdgeTopRight*       = 5;
	WindowResizeEdgeBottomLeft*     = 6;
	WindowResizeEdgeBottomRight*    = 7;
    DrawBrushTypeSolid*             = 0;
	DrawBrushTypeLinearGradient*    = 1;
	DrawBrushTypeRadialGradient*    = 2;
	DrawBrushTypeImage*             = 3;
    DrawLineCapFlat*                = 0;
	DrawLineCapRound*               = 1;
	DrawLineCapSquare*              = 2;
    DrawLineJoinMiter*              = 0;
	DrawLineJoinRound*              = 1;
	DrawLineJoinBevel*              = 2;
    DrawFillModeWinding*            = 0;
	DrawFillModeAlternate*          = 1;
    TableValueTypeString*           = 0;
	TableValueTypeImage*            = 1;
	TableValueTypeInt*              = 2;
	TableValueTypeColor*            = 3;
    TableModelColumnNeverEditable*  = -1;
    TableModelColumnAlwaysEditable* = -2;
    TableSelectionModeNone*         = 0;
    TableSelectionModeZeroOrOne*    = 1;
    TableSelectionModeOne*          = 3;
    TableSelectionModeZeroOrMany*   = 4;
    SortIndicatorNone*              = 0;
	SortIndicatorAscending*         = 1;
	SortIndicatorDescending*        = 2;

TYPE
    INT* = SYSTEM.int;
    SIZE_T* = SYSTEM.size_t;
    ADDRESS* = SYSTEM.ADDRESS;
    PCHAR* = POINTER TO ARRAY OF CHAR;
    VOID* = POINTER TO RECORD END;

    TM* = RECORD ["C"]
        tm_sec*    : INT;
        tm_min*    : INT;
        tm_hour*   : INT;
        tm_mday*   : INT;
        tm_mon*    : INT;
        tm_year*   : INT;
        tm_wday*   : INT;
        tm_yday*   : INT;
        tm_isdst*  : INT;
    END;

    InitOptions* = POINTER TO InitOptionsDesc;
    InitOptionsDesc = RECORD
        size* : SIZE_T;
    END;

    Control* = POINTER TO RECORD END;
    Window* = POINTER TO RECORD END;
    Image* = POINTER TO RECORD END;

    ControlCallBack             = PROCEDURE ["C"] (sender : Control; senderData : VOID);
    WindowCallBack              = PROCEDURE ["C"] (sender : Window; senderData : VOID);
    WindowExitCallBack          = PROCEDURE ["C"] (sender : Window; senderData : VOID) : INT;

    -- Area definitions
    DrawCallBack            = PROCEDURE ["C"] (areaHandler : VOID; area : VOID; areaDrawParams : VOID);
    MouseEventCallBack      = PROCEDURE ["C"] (areaHandler : VOID; area : VOID; areaMouseEvent : VOID);
    MouseCrossedCallBack    = PROCEDURE ["C"] (areaHandler : VOID; area : VOID; left : INT);
    DragBrokenCallBack      = PROCEDURE ["C"] (areaHandler : VOID; area : VOID);
    KeyEventCallBack        = PROCEDURE ["C"] (areaHandler : VOID; area : VOID; areaKeyEvent : VOID): INT;

    AreaHandlerPtr* = POINTER TO AreaHandler;
    AreaHandler* = RECORD ["C"]
        Draw*           : DrawCallBack;
        MouseEvent*     : MouseEventCallBack;
        MouseCrossed*   : MouseCrossedCallBack;
        DragBroken*     : DragBrokenCallBack;
        KeyEvent*       : KeyEventCallBack;
        Area*           : ADDRESS;
    END;

    AreaDrawParamsPtr* = POINTER TO AreaDrawParams;
    AreaDrawParams* = RECORD ["C"]
        Context*        : ADDRESS;
        AreaWidth*      : LONGREAL;
        AreaHeight*     : LONGREAL;
        ClipX*          : LONGREAL;
        ClipY*          : LONGREAL;
        ClipWidth*      : LONGREAL;
        ClipHeight*     : LONGREAL;
    END;

    AreaMouseEventPtr* = POINTER TO AreaMouseEvent;
    AreaMouseEvent* = RECORD ["C"]
        X*              : LONGREAL;
        Y*              : LONGREAL;
        AreaWidth*      : LONGREAL;
        AreaHeight*     : LONGREAL;
        Down*           : INT;
        Up*             : INT;
        Count*          : INT;
        Modifiers       : INT;
        Held1To64       : SYSTEM.INT64;
    END;

    AreaKeyEventPtr* = POINTER TO AreaKeyEvent;
    AreaKeyEvent* = RECORD ["C"]
        Key*            : CHAR;
        ExtKey*         : INT;
        Modifier*       : INT;
        Modifiers*      : INT;
        Up*             : INT;
    END;

    DrawBrushPtr* = POINTER TO DrawBrush;
    DrawBrush* = RECORD ["C"]
        Type*           : SYSTEM.INT64; (* TODO : Not sure why this is needed*)
        R*              : LONGREAL;
        G*              : LONGREAL;
        B*              : LONGREAL;
        A*              : LONGREAL;
        X0*             : LONGREAL;
        Y0*             : LONGREAL;
        X1*             : LONGREAL;
        Y1*             : LONGREAL;
        OuterRadius*    : LONGREAL;
        Stops*          : ADDRESS;
        NumStops*       : INT;
    END;

    DrawStrokeParamsPtr* = POINTER TO DrawStrokeParams;
    DrawStrokeParams* = RECORD ["C"]
        Cap*            : SYSTEM.INT;
        Join*           : SYSTEM.INT;
        Thickness*      : LONGREAL;
        MiterLimit*     : LONGREAL;
        Dashes*         : ADDRESS;
        NumDashes*      : SYSTEM.INT;
        DashPhase*      : LONGREAL;
    END;

    DrawMatrixPtr* = POINTER TO DrawMatrix;
    DrawMatrix* = RECORD ["C"]
        M11*            : LONGREAL;
        M12*            : LONGREAL;
        M21*            : LONGREAL;
        M22*            : LONGREAL;
        M31*            : LONGREAL;
        M32*            : LONGREAL;
    END;

    -- Table definition
    TableRowCallBack            = PROCEDURE ["C"] (sender : Control; row : INT; senderData : VOID);
    TableColumnCallBack         = PROCEDURE ["C"] (sender : Control; column : INT; senderData : VOID);

    NumColumnsCallBack          = PROCEDURE ["C"] (tableModelHandler : VOID; tableModel : VOID): INT;
    ColumnTypeCallBack          = PROCEDURE ["C"] (tableModelHandler : VOID; tableModel : VOID; column : INT): INT;
    NumRowsCallBack             = PROCEDURE ["C"] (tableModelHandler : VOID; tableModel : VOID): INT;
    CellValueCallBack           = PROCEDURE ["C"] (tableModelHandler : VOID; tableModel : VOID; row : INT; col : INT): ADDRESS;
    SetCellValueCallBack        = PROCEDURE ["C"] (tableModelHandler : VOID; tableModel : VOID; row : INT; col : INT; value : ADDRESS);

    TableModelHandlerPtr* = POINTER TO TableModelHandler;
    TableModelHandler* = RECORD ["C"]
        NumColumns*     : NumColumnsCallBack;
        ColumnType*     : ColumnTypeCallBack;
        NumRows*        : NumRowsCallBack;
        CellValue*      : CellValueCallBack;
        SetCellValue*   : SetCellValueCallBack;
        Model*          : ADDRESS;
    END;

    TableSelectionPtr* = POINTER TO TableSelection;
    TableSelection* = RECORD ["C"]
        NumRows*  : INT;
        Rows*     : ADDRESS;
    END;
    TableTextColumnOptionalParams* = RECORD ["C"]
        ColorModelColumn*     : INT;
    END;

    TableParams* = RECORD ["C"]
        Model*                              : ADDRESS;
        RowBackgroundColorModelColumn*      : INT;
    END;

    -- Function types
    uiInit                          = PROCEDURE ["C"] (options : InitOptions) : PCHAR;
    uiUninit                        = PROCEDURE ["C"] ();
    uiFreeInitError                 = PROCEDURE ["C"] (err : PCHAR);
    uiMain                          = PROCEDURE ["C"] ();
    uiQuit                          = PROCEDURE ["C"] ();
    uiFreeText                      = PROCEDURE ["C"] (text : PCHAR);
    -- Control  
    uiControlDestroy                = PROCEDURE ["C"] (c : ADDRESS);
    uiControlToplevel               = PROCEDURE ["C"] (c : ADDRESS) : INT;
    uiControlVisible                = PROCEDURE ["C"] (c : ADDRESS) : INT;
    uiControlShow                   = PROCEDURE ["C"] (c : ADDRESS);
    uiControlHide                   = PROCEDURE ["C"] (c : ADDRESS);
    uiControlEnabled                = PROCEDURE ["C"] (c : ADDRESS) : INT;
    uiControlEnable                 = PROCEDURE ["C"] (c : ADDRESS);
    uiControlDisable                = PROCEDURE ["C"] (c : ADDRESS);
    -- Window   
    uiNewWindow                     = PROCEDURE ["C"] (title : PCHAR; width, height, hasMenubar : INT) : Window;
    uiWindowTitle                   = PROCEDURE ["C"] (w : ADDRESS) : PCHAR;
    uiWindowSetTitle                = PROCEDURE ["C"] (w : ADDRESS; title : PCHAR);
    uiWindowPosition                = PROCEDURE ["C"] (w : ADDRESS; VAR x : INT; VAR y : INT);
    uiWindowSetPosition             = PROCEDURE ["C"] (w : ADDRESS; x : INT; y : INT);
    uiWindowOnPositionChanged       = PROCEDURE ["C"] (w : ADDRESS; callback : WindowCallBack; data : ADDRESS);
    uiWindowContentSize             = PROCEDURE ["C"] (w : ADDRESS; VAR width : INT; VAR height : INT);
    uiWindowSetContentSize          = PROCEDURE ["C"] (w : ADDRESS; width : INT; height : INT);
    uiWindowFullscreen              = PROCEDURE ["C"] (w : ADDRESS) : INT;
    uiWindowSetFullscreen           = PROCEDURE ["C"] (w : ADDRESS; fullscreen : INT);
    uiWindowOnContentSizeChanged    = PROCEDURE ["C"] (w : ADDRESS; callback : WindowCallBack; data : ADDRESS);
    uiWindowOnClosing               = PROCEDURE ["C"] (w : ADDRESS; callback : WindowExitCallBack; data : ADDRESS);
    uiWindowOnFocusChanged          = PROCEDURE ["C"] (w : ADDRESS; callback : WindowCallBack; data : ADDRESS);
    uiWindowFocused                 = PROCEDURE ["C"] (w : ADDRESS) : INT;
    uiWindowBorderless              = PROCEDURE ["C"] (w : ADDRESS) : INT;
    uiWindowSetBorderless           = PROCEDURE ["C"] (w : ADDRESS; borderless : INT);
    uiWindowSetChild                = PROCEDURE ["C"] (w : ADDRESS; child : ADDRESS);
    uiWindowMargined                = PROCEDURE ["C"] (w : ADDRESS) : INT;
    uiWindowSetMargined             = PROCEDURE ["C"] (w : ADDRESS; margined : INT);
    uiWindowResizeable              = PROCEDURE ["C"] (w : ADDRESS) : INT;
    uiWindowSetResizeable           = PROCEDURE ["C"] (w : ADDRESS; resizeable : INT);
    -- Button   
    uiNewButton                     = PROCEDURE ["C"] (text : PCHAR): Control;
    uiButtonText                    = PROCEDURE ["C"] (b : ADDRESS) : PCHAR;
    uiButtonSetText                 = PROCEDURE ["C"] (b : ADDRESS; title : PCHAR);
    uiButtonOnClicked               = PROCEDURE ["C"] (b : ADDRESS; callback : ControlCallBack; data : ADDRESS);
    -- Box  
    uiNewVerticalBox                = PROCEDURE ["C"] (): Control;
    uiNewHorizontalBox              = PROCEDURE ["C"] (): Control;
    uiBoxAppend                     = PROCEDURE ["C"] (b : ADDRESS; child : ADDRESS; stretchy : INT);
    uiBoxNumChildren                = PROCEDURE ["C"] (b : ADDRESS) : INT;
    uiBoxDelete                     = PROCEDURE ["C"] (b : ADDRESS; index : INT);
    uiBoxPadded                     = PROCEDURE ["C"] (b : ADDRESS) : INT;
    uiBoxSetPadded                  = PROCEDURE ["C"] (b : ADDRESS; padded : INT);
    -- Checkbox 
    uiNewCheckbox                   = PROCEDURE ["C"] (text : PCHAR): Control;
    uiCheckboxText                  = PROCEDURE ["C"] (c : ADDRESS) : PCHAR;
    uiCheckboxSetText               = PROCEDURE ["C"] (c : ADDRESS; title : PCHAR);
    uiCheckboxOnToggled             = PROCEDURE ["C"] (c : ADDRESS; callback : ControlCallBack; data : ADDRESS);
    uiCheckboxChecked               = PROCEDURE ["C"] (c : ADDRESS) : INT;
    uiCheckboxSetChecked            = PROCEDURE ["C"] (c : ADDRESS; checked : INT);
    -- Entry    
    uiNewEntry                      = PROCEDURE ["C"] (): Control;
    uiNewPasswordEntry              = PROCEDURE ["C"] (): Control;
    uiNewSearchEntry                = PROCEDURE ["C"] (): Control;
    uiEntryText                     = PROCEDURE ["C"] (e : ADDRESS) : PCHAR;
    uiEntrySetText                  = PROCEDURE ["C"] (e : ADDRESS; text : PCHAR);
    uiEntryOnChanged                = PROCEDURE ["C"] (e : ADDRESS; callback : ControlCallBack; data : ADDRESS);
    uiEntryReadOnly                 = PROCEDURE ["C"] (e : ADDRESS) : INT;
    uiEntrySetReadOnly              = PROCEDURE ["C"] (e : ADDRESS; readonly : INT);
    -- Label    
    uiNewLabel                      = PROCEDURE ["C"] (text : PCHAR): Control;
    uiLabelText                     = PROCEDURE ["C"] (l : ADDRESS) : PCHAR;
    uiLabelSetText                  = PROCEDURE ["C"] (l : ADDRESS; text : PCHAR);
    -- Tab  
    uiNewTab                        = PROCEDURE ["C"] (): Control;
    uiTabAppend                     = PROCEDURE ["C"] (t : ADDRESS; name : PCHAR; control : ADDRESS);
    uiTabInsertAt                   = PROCEDURE ["C"] (t : ADDRESS; name : PCHAR; index : INT; control : ADDRESS);
    uiTabDelete                     = PROCEDURE ["C"] (t : ADDRESS; index : INT);
    uiTabNumPages                   = PROCEDURE ["C"] (t : ADDRESS) : INT;
    uiTabMargined                   = PROCEDURE ["C"] (t : ADDRESS; index : INT) : INT;
    uiTabSetMargined                = PROCEDURE ["C"] (t : ADDRESS; index : INT; margined : INT);
    -- Group    
    uiNewGroup                      = PROCEDURE ["C"] (): Control;
    uiGroupTitle                    = PROCEDURE ["C"] (g : ADDRESS) : PCHAR;
    uiGroupSetTitle                 = PROCEDURE ["C"] (g : ADDRESS; title : PCHAR);
    uiGroupSetChild                 = PROCEDURE ["C"] (g : ADDRESS; control : ADDRESS);
    uiGroupMargined                 = PROCEDURE ["C"] (g : ADDRESS) : INT;
    uiGroupSetMargined              = PROCEDURE ["C"] (g : ADDRESS; margined : INT);
    -- Spinbox  
    uiNewSpinbox                    = PROCEDURE ["C"] (min, max : INT): Control;
    uiSpinboxValue                  = PROCEDURE ["C"] (s : ADDRESS) : INT;
    uiSpinboxSetValue               = PROCEDURE ["C"] (s : ADDRESS; value : INT);
    uiSpinboxOnChanged              = PROCEDURE ["C"] (s : ADDRESS; callback : ControlCallBack; data : ADDRESS);
    -- Slider   
    uiNewSlider                     = PROCEDURE ["C"] (min, max : INT): Control;
    uiSliderValue                   = PROCEDURE ["C"] (s : ADDRESS) : INT;
    uiSliderSetValue                = PROCEDURE ["C"] (s : ADDRESS; value : INT);
    uiSliderHasToolTip              = PROCEDURE ["C"] (s : ADDRESS) : INT;
    uiSliderSetHasToolTip           = PROCEDURE ["C"] (s : ADDRESS; hasToolTip : INT);
    uiSliderOnChanged               = PROCEDURE ["C"] (s : ADDRESS; callback : ControlCallBack; data : ADDRESS);
    uiSliderOnReleased              = PROCEDURE ["C"] (s : ADDRESS; callback : ControlCallBack; data : ADDRESS);
    uiSliderSetRange                = PROCEDURE ["C"] (s : ADDRESS; min, max : INT);
    -- ProgressBar  
    uiNewProgressBar                = PROCEDURE ["C"] (): Control;
    uiProgressBarValue              = PROCEDURE ["C"] (p : ADDRESS) : INT;
    uiProgressBarSetValue           = PROCEDURE ["C"] (p : ADDRESS; value : INT);
    -- Separator    
    uiNewHorizontalSeparator        = PROCEDURE ["C"] (): Control;
    uiNewVerticalSeparator          = PROCEDURE ["C"] (): Control;
    -- Combobox 
    uiNewCombobox                   = PROCEDURE ["C"] (): Control;
    uiComboboxAppend                = PROCEDURE ["C"] (c : ADDRESS; text : PCHAR);
    uiComboboxInsertAt              = PROCEDURE ["C"] (c : ADDRESS; index : INT; text : PCHAR);
    uiComboboxDelete                = PROCEDURE ["C"] (c : ADDRESS; index : INT);
    uiComboboxClear                 = PROCEDURE ["C"] (c : ADDRESS);
    uiComboboxNumItems              = PROCEDURE ["C"] (c : ADDRESS): INT;
    uiComboboxSelected              = PROCEDURE ["C"] (c : ADDRESS): INT;
    uiComboboxSetSelected           = PROCEDURE ["C"] (c : ADDRESS; index : INT);
    uiComboboxOnSelected            = PROCEDURE ["C"] (c : ADDRESS; callback : ControlCallBack; data : ADDRESS);
    -- EditableCombobox 
    uiNewEditableCombobox           = PROCEDURE ["C"] (): Control;
    uiEditableComboboxAppend        = PROCEDURE ["C"] (c : ADDRESS; text : PCHAR);
    uiEditableComboboxText          = PROCEDURE ["C"] (c : ADDRESS) : PCHAR;
    uiEditableComboboxSetText       = PROCEDURE ["C"] (c : ADDRESS; text : PCHAR);
    uiEditableComboboxOnChanged     = PROCEDURE ["C"] (c : ADDRESS; callback : ControlCallBack; data : ADDRESS);
    -- RadioButtons 
    uiNewRadioButtons               = PROCEDURE ["C"] (): Control;
    uiRadioButtonsAppend            = PROCEDURE ["C"] (r : ADDRESS; text : PCHAR);
    uiRadioButtonsSelected          = PROCEDURE ["C"] (r : ADDRESS): INT;
    uiRadioButtonsSetSelected       = PROCEDURE ["C"] (r : ADDRESS; index : INT);
    uiRadioButtonsOnSelected        = PROCEDURE ["C"] (r : ADDRESS; callback : ControlCallBack; data : ADDRESS);
    -- DateTimePicker   
    uiNewDateTimePicker             = PROCEDURE ["C"] (): Control;
    uiNewDatePicker                 = PROCEDURE ["C"] (): Control;
    uiNewTimePicker                 = PROCEDURE ["C"] (): Control;
    uiDateTimePickerTime            = PROCEDURE ["C"] (d : ADDRESS; VAR time : TM);
    uiDateTimePickerSetTime         = PROCEDURE ["C"] (d : ADDRESS; VAR time : TM);
    uiDateTimePickerOnChanged       = PROCEDURE ["C"] (d : ADDRESS; callback : ControlCallBack; data : ADDRESS);
    -- MultilineEntry
    uiNewMultilineEntry             = PROCEDURE ["C"] (): Control;
    uiNewNonWrappingMultilineEntry  = PROCEDURE ["C"] (): Control;
    uiMultilineEntryText            = PROCEDURE ["C"] (e : ADDRESS) : PCHAR;
    uiMultilineEntrySetText         = PROCEDURE ["C"] (e : ADDRESS; text : PCHAR);
    uiMultilineEntryAppend          = PROCEDURE ["C"] (e : ADDRESS; text : PCHAR);
    uiMultilineEntryOnChanged       = PROCEDURE ["C"] (e : ADDRESS; callback : ControlCallBack; data : ADDRESS);
    uiMultilineEntryReadOnly        = PROCEDURE ["C"] (e : ADDRESS): INT;
    uiMultilineEntrySetReadOnly     = PROCEDURE ["C"] (e : ADDRESS; readonly : INT);
    -- MenuItem
    uiMenuItemEnable                = PROCEDURE ["C"] (c : ADDRESS);
    uiMenuItemDisable               = PROCEDURE ["C"] (c : ADDRESS);
    uiMenuItemOnClicked             = PROCEDURE ["C"] (i : ADDRESS; callback : ControlCallBack; data : ADDRESS);
    uiMenuItemChecked               = PROCEDURE ["C"] (i : ADDRESS): INT;
    uiMenuItemSetChecked            = PROCEDURE ["C"] (i : ADDRESS; checked : INT);
    -- Menu 
    uiNewMenu                       = PROCEDURE ["C"] (name : PCHAR): Control;
    uiMenuAppendItem                = PROCEDURE ["C"] (m : ADDRESS; name : PCHAR): Control;
    uiMenuAppendCheckItem           = PROCEDURE ["C"] (m : ADDRESS; name : PCHAR): Control;
    uiMenuAppendQuitItem            = PROCEDURE ["C"] (m : ADDRESS): Control;
    uiMenuAppendPreferencesItem     = PROCEDURE ["C"] (m : ADDRESS): Control;
    uiMenuAppendAboutItem           = PROCEDURE ["C"] (m : ADDRESS): Control;
    uiMenuAppendSeparator           = PROCEDURE ["C"] (m : ADDRESS);
    -- Standard Dialogs 
    uiOpenFile                      = PROCEDURE ["C"] (w : ADDRESS): PCHAR;
    uiOpenFolder                    = PROCEDURE ["C"] (w : ADDRESS): PCHAR;
    uiSaveFile                      = PROCEDURE ["C"] (w : ADDRESS): PCHAR;
    uiMsgBox                        = PROCEDURE ["C"] (w : ADDRESS; title : PCHAR; description : PCHAR);
    uiMsgBoxError                   = PROCEDURE ["C"] (w : ADDRESS; title : PCHAR; description : PCHAR);
    -- Area
    uiNewArea                       = PROCEDURE ["C"] (VAR ah : AreaHandler): ADDRESS;
    uiNewScrollingArea              = PROCEDURE ["C"] (VAR ah : AreaHandler; width : INT; height : INT): ADDRESS;
    uiAreaSetSize                   = PROCEDURE ["C"] (a : ADDRESS; width : INT; height : INT);
    uiAreaQueueRedrawAll            = PROCEDURE ["C"] (a : ADDRESS);
    uiAreaScrollTo                  = PROCEDURE ["C"] (a : ADDRESS; x : LONGREAL; y : LONGREAL; width : LONGREAL; height : LONGREAL);
    -- DrawPath
    uiDrawNewPath                   = PROCEDURE ["C"] (fillMode : INT): ADDRESS;
    uiDrawFreePath                  = PROCEDURE ["C"] (p : ADDRESS);
    uiDrawPathNewFigure             = PROCEDURE ["C"] (p : ADDRESS; x : LONGREAL; y  : LONGREAL);
    uiDrawPathNewFigureWithArc      = PROCEDURE ["C"] (p : ADDRESS; xCenter : LONGREAL; yCenter  : LONGREAL; radius : LONGREAL; startAngle : LONGREAL; sweep : LONGREAL; negative : INT);
    uiDrawPathLineTo                = PROCEDURE ["C"] (p : ADDRESS; x : LONGREAL; y  : LONGREAL);
    uiDrawPathArcTo                 = PROCEDURE ["C"] (p : ADDRESS; xCenter : LONGREAL; yCenter  : LONGREAL; radius : LONGREAL; startAngle : LONGREAL; sweep : LONGREAL; negative : INT);
    uiDrawPathBezierTo              = PROCEDURE ["C"] (p : ADDRESS; c1x : LONGREAL; c1y  : LONGREAL; c2x : LONGREAL; c2y  : LONGREAL; endX : LONGREAL; endY : LONGREAL);
    uiDrawPathCloseFigure           = PROCEDURE ["C"] (p : ADDRESS);
    uiDrawPathAddRectangle          = PROCEDURE ["C"] (p : ADDRESS; x : LONGREAL; y  : LONGREAL; width : LONGREAL; height : LONGREAL);
    uiDrawPathEnded                 = PROCEDURE ["C"] (p : ADDRESS) : INT;
    uiDrawPathEnd                   = PROCEDURE ["C"] (p : ADDRESS);
    -- Matrix
    uiDrawMatrixSetIdentity         = PROCEDURE ["C"] (m : ADDRESS);
    uiDrawMatrixTranslate           = PROCEDURE ["C"] (m : ADDRESS; x, y : LONGREAL);
    uiDrawMatrixScale               = PROCEDURE ["C"] (m : ADDRESS; xCenter, yCenter, x, y : LONGREAL);
    uiDrawMatrixRotate              = PROCEDURE ["C"] (m : ADDRESS; x, y, amount : LONGREAL);
    uiDrawMatrixSkew                = PROCEDURE ["C"] (m : ADDRESS; x, y, xamount, yamount : LONGREAL);
    uiDrawMatrixMultiply            = PROCEDURE ["C"] (dst, src : ADDRESS);
    uiDrawMatrixInvertible          = PROCEDURE ["C"] (m : ADDRESS) : INT;
    uiDrawMatrixInvert              = PROCEDURE ["C"] (m : ADDRESS) : INT;
    uiDrawMatrixTransformPoint      = PROCEDURE ["C"] (m : ADDRESS; VAR x : LONGREAL; VAR y : LONGREAL);
    uiDrawMatrixTransformSize       = PROCEDURE ["C"] (m : ADDRESS; VAR x : LONGREAL; VAR y : LONGREAL);
    -- DrawContext
    uiDrawSave                      = PROCEDURE ["C"] (c : ADDRESS);
    uiDrawRestore                   = PROCEDURE ["C"] (c : ADDRESS);
    uiDrawTransform                 = PROCEDURE ["C"] (c : ADDRESS; m : ADDRESS);
    uiDrawClip                      = PROCEDURE ["C"] (c : ADDRESS; path : ADDRESS);
    uiDrawStroke                    = PROCEDURE ["C"] (c : ADDRESS; path : ADDRESS; b : ADDRESS; s : ADDRESS);
    uiDrawFill                      = PROCEDURE ["C"] (c : ADDRESS; path : ADDRESS; b : DrawBrushPtr);
    -- ColorButton  
    uiNewColorButton                = PROCEDURE ["C"] (): Control;
    uiColorButtonColor              = PROCEDURE ["C"] (b : ADDRESS; VAR r : LONGREAL; VAR g : LONGREAL; VAR bl : LONGREAL; VAR a : LONGREAL);
    uiColorButtonSetColor           = PROCEDURE ["C"] (b : ADDRESS; r, g, bl, a : LONGREAL);
    uiColorButtonOnChanged          = PROCEDURE ["C"] (b : ADDRESS; callback : ControlCallBack; data : ADDRESS);
    -- Form 
    uiNewForm                       = PROCEDURE ["C"] (): Control;
    uiFormAppend                    = PROCEDURE ["C"] (f : ADDRESS; name : PCHAR; control : ADDRESS; stretchy : INT);
    uiFormNumChildren               = PROCEDURE ["C"] (f : ADDRESS): INT;
    uiFormDelete                    = PROCEDURE ["C"] (f : ADDRESS; index : INT);
    uiFormPadded                    = PROCEDURE ["C"] (f : ADDRESS) : INT;
    uiFormSetPadded                 = PROCEDURE ["C"] (f : ADDRESS; padded : INT);
    -- Grid 
    uiNewGrid                       = PROCEDURE ["C"] (): Control;
    uiGridAppend                    = PROCEDURE ["C"] (g : ADDRESS; control : ADDRESS; left, top, xpan, yspan, hexpand, halign, vexpand, valign : INT);
    uiGridInsertAt                  = PROCEDURE ["C"] (g : ADDRESS; control, existing : ADDRESS; at, xpan, yspan, hexpand, halign, vexpand, valign : INT);
    uiGridPadded                    = PROCEDURE ["C"] (g : ADDRESS) : INT;
    uiGridSetPadded                 = PROCEDURE ["C"] (g : ADDRESS; padded : INT);
    -- Image    
    uiNewImage                      = PROCEDURE ["C"] (width, height : LONGREAL): Image;
    uiFreeImage                     = PROCEDURE ["C"] (i : ADDRESS);
    uiImageAppend                   = PROCEDURE ["C"] (i : ADDRESS; pixels : ADDRESS; pixelWidth, pixelHeight, byteStride : INT);
    -- TableValue   
    uiTableValueGetType             = PROCEDURE ["C"] (t : ADDRESS): INT;
    uiNewTableValueString           = PROCEDURE ["C"] (str : PCHAR) : ADDRESS;
    uiTableValueString              = PROCEDURE ["C"] (t : ADDRESS): PCHAR;
    uiNewTableValueImage            = PROCEDURE ["C"] (img : ADDRESS) : ADDRESS;
    uiTableValueImage               = PROCEDURE ["C"] (t : ADDRESS): ADDRESS;
    uiNewTableValueInt              = PROCEDURE ["C"] (i : INT) : ADDRESS;
    uiTableValueInt                 = PROCEDURE ["C"] (t : ADDRESS): INT;
    uiNewTableValueColor            = PROCEDURE ["C"] (r, g, b, a : LONGREAL) : ADDRESS;
    uiTableValueColor               = PROCEDURE ["C"] (t : ADDRESS; VAR r : LONGREAL; VAR g : LONGREAL; VAR b : LONGREAL; VAR a : LONGREAL);
    -- TableModel   
    uiNewTableModel                 = PROCEDURE ["C"] (mh : ADDRESS): ADDRESS;
    uiFreeTableModel                = PROCEDURE ["C"] (m : ADDRESS);
    uiTableModelRowInserted         = PROCEDURE ["C"] (m : ADDRESS; newIndex : INT);
    uiTableModelRowChanged          = PROCEDURE ["C"] (m : ADDRESS; newIndex : INT);
    uiTableModelRowDeleted          = PROCEDURE ["C"] (m : ADDRESS; newIndex : INT);
    -- Table    
    uiNewTable                      = PROCEDURE ["C"] (VAR params : TableParams): ADDRESS;
    uiTableAppendTextColumn         = PROCEDURE ["C"] (t : ADDRESS; name : PCHAR; textModelColumn : INT; textEditableModelColumn : INT; VAR textParams : TableTextColumnOptionalParams);
    uiTableAppendImageColumn        = PROCEDURE ["C"] (t : ADDRESS; name : PCHAR; imageModelColumn : INT);
    uiTableAppendImageTextColumn    = PROCEDURE ["C"] (t : ADDRESS; name : PCHAR; imageModelColumn : INT; textModelColumn : INT; textEditableModelColumn : INT; VAR textParams : TableTextColumnOptionalParams);
    uiTableAppendCheckboxColumn     = PROCEDURE ["C"] (t : ADDRESS; name : PCHAR; checkboxModelColumn : INT; checkboxEditableModelColumn : INT);
    uiTableAppendCheckboxTextColumn = PROCEDURE ["C"] (t : ADDRESS; name : PCHAR; checkboxModelColumn : INT; checkboxEditableModelColumn : INT; textModelColumn : INT; textEditableModelColumn : INT; VAR textParams : TableTextColumnOptionalParams);
    uiTableAppendProgressBarColumn  = PROCEDURE ["C"] (t : ADDRESS; name : PCHAR; progressModelColumn : INT);
    uiTableAppendButtonColumn       = PROCEDURE ["C"] (t : ADDRESS; name : PCHAR; buttonModelColumn : INT;  buttonClickableModelColumn : INT);
    uiTableHeaderVisible            = PROCEDURE ["C"] (t : ADDRESS): INT;
    uiTableHeaderSetVisible         = PROCEDURE ["C"] (t : ADDRESS; visible : INT);
    uiTableOnRowClicked             = PROCEDURE ["C"] (t : ADDRESS; callback : TableRowCallBack; data : ADDRESS);
    uiTableOnRowDoubleClicked       = PROCEDURE ["C"] (t : ADDRESS; callback : TableRowCallBack; data : ADDRESS);
    uiTableHeaderSetSortIndicator   = PROCEDURE ["C"] (t : ADDRESS; column : INT; indicator : INT);
    uiTableHeaderSortIndicator      = PROCEDURE ["C"] (t : ADDRESS; column : INT) : INT;
    uiTableHeaderOnClicked          = PROCEDURE ["C"] (t : ADDRESS; callback : TableColumnCallBack; data : ADDRESS);
    uiTableColumnWidth              = PROCEDURE ["C"] (t : ADDRESS; column : INT) : INT;
    uiTableColumnSetWidth           = PROCEDURE ["C"] (t : ADDRESS; column : INT; width : INT);
    uiTableGetSelectionMode         = PROCEDURE ["C"] (t : ADDRESS) : INT;
    uiTableSetSelectionMode         = PROCEDURE ["C"] (t : ADDRESS; mode : INT);
    uiTableOnSelectionChanged       = PROCEDURE ["C"] (t : ADDRESS; callback : ControlCallBack; data : ADDRESS);
    uiTableGetSelection             = PROCEDURE ["C"] (t : ADDRESS) : TableSelectionPtr;
    uiTableSetSelection             = PROCEDURE ["C"] (t : ADDRESS; selection : TableSelectionPtr);
    uiFreeTableSelection            = PROCEDURE ["C"] (selection : TableSelectionPtr);

VAR
    Init*                           : uiInit;
    Uninit*                         : uiUninit;
    FreeInitError*                  : uiFreeInitError;
    Main*                           : uiMain;
    Quit*                           : uiQuit;
    FreeText*                       : uiFreeText;
    -- Control  
    ControlDestroy*                 : uiControlDestroy;
    ControlToplevel*                : uiControlToplevel;
    ControlVisible*                 : uiControlVisible;
    ControlShow*                    : uiControlShow;
    ControlHide*                    : uiControlHide;
    ControlEnabled*                 : uiControlEnabled;
    ControlEnable*                  : uiControlEnable;
    ControlDisable*                 : uiControlDisable;
    -- Window   
    NewWindow*                      : uiNewWindow;
    WindowTitle*                    : uiWindowTitle;
    WindowSetTitle*                 : uiWindowSetTitle;
    WindowPosition*                 : uiWindowPosition;
    WindowSetPosition*              : uiWindowSetPosition;
    WindowOnPositionChanged*        : uiWindowOnPositionChanged;
    WindowContentSize*              : uiWindowContentSize;
    WindowSetContentSize*           : uiWindowSetContentSize;
    WindowFullscreen*               : uiWindowFullscreen;
    WindowSetFullscreen*            : uiWindowSetFullscreen;
    WindowOnContentSizeChanged*     : uiWindowOnContentSizeChanged;
    WindowOnClosing*                : uiWindowOnClosing;
    WindowOnFocusChanged*           : uiWindowOnFocusChanged;
    WindowFocused*                  : uiWindowFocused;
    WindowBorderless*               : uiWindowBorderless;
    WindowSetBorderless*            : uiWindowSetBorderless;
    WindowSetChild*                 : uiWindowSetChild;
    WindowMargined*                 : uiWindowMargined;
    WindowSetMargined*              : uiWindowSetMargined;
    WindowResizeable*               : uiWindowResizeable;
    WindowSetResizeable*            : uiWindowSetResizeable;
    -- Button   
    NewButton*                      : uiNewButton;
    ButtonText*                     : uiButtonText;
    ButtonSetText*                  : uiButtonSetText;
    ButtonOnClicked*                : uiButtonOnClicked;
    -- Box  
    NewVerticalBox*                 : uiNewVerticalBox;
    NewHorizontalBox*               : uiNewHorizontalBox;
    BoxAppend*                      : uiBoxAppend;
    BoxNumChildren*                 : uiBoxNumChildren;
    BoxDelete*                      : uiBoxDelete;
    BoxPadded*                      : uiBoxPadded;
    BoxSetPadded*                   : uiBoxSetPadded;
    -- Checkbox 
    NewCheckbox*                    : uiNewCheckbox;       
    CheckboxText*                   : uiCheckboxText;      
    CheckboxSetText*                : uiCheckboxSetText;   
    CheckboxOnToggled*              : uiCheckboxOnToggled; 
    CheckboxChecked*                : uiCheckboxChecked;   
    CheckboxSetChecked*             : uiCheckboxSetChecked;
    -- Entry    
    NewEntry*                       : uiNewEntry;         
    NewPasswordEntry*               : uiNewPasswordEntry; 
    NewSearchEntry*                 : uiNewSearchEntry;   
    EntryText*                      : uiEntryText;        
    EntrySetText*                   : uiEntrySetText;     
    EntryOnChanged*                 : uiEntryOnChanged;   
    EntryReadOnly*                  : uiEntryReadOnly;    
    EntrySetReadOnly*               : uiEntrySetReadOnly; 
    -- Label    
    NewLabel*                       : uiNewLabel;
    LabelText*                      : uiLabelText;
    LabelSetText*                   : uiLabelSetText;
    -- Tab  
    NewTab*                         : uiNewTab;        
    TabAppend*                      : uiTabAppend;     
    TabInsertAt*                    : uiTabInsertAt;   
    TabDelete*                      : uiTabDelete;     
    TabNumPages*                    : uiTabNumPages;   
    TabMargined*                    : uiTabMargined;   
    TabSetMargined*                 : uiTabSetMargined;
    -- Group    
    NewGroup*                       : uiNewGroup;        
    GroupTitle*                     : uiGroupTitle;      
    GroupSetTitle*                  : uiGroupSetTitle;   
    GroupSetChild*                  : uiGroupSetChild;   
    GroupMargined*                  : uiGroupMargined;   
    GroupSetMargined*               : uiGroupSetMargined;
    -- Spinbox  
    NewSpinbox*                     : uiNewSpinbox;
    SpinboxValue*                   : uiSpinboxValue;
    SpinboxSetValue*                : uiSpinboxSetValue;
    SpinboxOnChanged*               : uiSpinboxOnChanged;
    -- Slider   
    NewSlider*                      : uiNewSlider;
    SliderValue*                    : uiSliderValue;
    SliderSetValue*                 : uiSliderSetValue;     
    SliderHasToolTip*               : uiSliderHasToolTip;
    SliderSetHasToolTip*            : uiSliderSetHasToolTip;
    SliderOnChanged*                : uiSliderOnChanged;
    SliderOnReleased*               : uiSliderOnReleased;
    SliderSetRange*                 : uiSliderSetRange;
    -- ProgressBar  
    NewProgressBar*                 : uiNewProgressBar;
    ProgressBarValue*               : uiProgressBarValue;
    ProgressBarSetValue*            : uiProgressBarSetValue;
    -- Separator    
    NewHorizontalSeparator*         : uiNewHorizontalSeparator;
    NewVerticalSeparator*           : uiNewVerticalSeparator;
    -- Combobox 
    NewCombobox*                    : uiNewCombobox;
    ComboboxAppend*                 : uiComboboxAppend;
    ComboboxInsertAt*               : uiComboboxInsertAt;
    ComboboxDelete*                 : uiComboboxDelete;
    ComboboxClear*                  : uiComboboxClear;
    ComboboxNumItems*               : uiComboboxNumItems;
    ComboboxSelected*               : uiComboboxSelected;
    ComboboxSetSelected*            : uiComboboxSetSelected;
    ComboboxOnSelected*             : uiComboboxOnSelected;
    -- EditableCombobox 
    NewEditableCombobox*            : uiNewEditableCombobox;
    EditableComboboxAppend*         : uiEditableComboboxAppend;
    EditableComboboxText*           : uiEditableComboboxText;
    EditableComboboxSetText*        : uiEditableComboboxSetText;
    EditableComboboxOnChanged*      : uiEditableComboboxOnChanged;
    -- RadioButtons 
    NewRadioButtons*                : uiNewRadioButtons;
    RadioButtonsAppend*             : uiRadioButtonsAppend;
    RadioButtonsSelected*           : uiRadioButtonsSelected;
    RadioButtonsSetSelected*        : uiRadioButtonsSetSelected;
    RadioButtonsOnSelected*         : uiRadioButtonsOnSelected;
    -- DateTimePicker   
    NewDateTimePicker*              : uiNewDateTimePicker;
    NewDatePicker*                  : uiNewDatePicker;
    NewTimePicker*                  : uiNewTimePicker;
    DateTimePickerTime*             : uiDateTimePickerTime;
    DateTimePickerSetTime*          : uiDateTimePickerSetTime;
    DateTimePickerOnChanged*        : uiDateTimePickerOnChanged;
    -- MultilineEntry
    NewMultilineEntry*              : uiNewMultilineEntry;
    NewNonWrappingMultilineEntry*   : uiNewNonWrappingMultilineEntry;
    MultilineEntryText*             : uiMultilineEntryText;
    MultilineEntrySetText*          : uiMultilineEntrySetText;
    MultilineEntryAppend*           : uiMultilineEntryAppend;
    MultilineEntryOnChanged*        : uiMultilineEntryOnChanged;
    MultilineEntryReadOnly*         : uiMultilineEntryReadOnly;
    MultilineEntrySetReadOnly*      : uiMultilineEntrySetReadOnly;
    -- MenuItem
    MenuItemEnable*                 : uiMenuItemEnable;
    MenuItemDisable*                : uiMenuItemDisable;
    MenuItemOnClicked*              : uiMenuItemOnClicked;
    MenuItemChecked*                : uiMenuItemChecked;
    MenuItemSetChecked*             : uiMenuItemSetChecked;
    -- Menu 
    NewMenu*                        : uiNewMenu;
    MenuAppendItem*                 : uiMenuAppendItem;
    MenuAppendCheckItem*            : uiMenuAppendCheckItem;
    MenuAppendQuitItem*             : uiMenuAppendQuitItem;
    MenuAppendPreferencesItem*      : uiMenuAppendPreferencesItem;
    MenuAppendAboutItem*            : uiMenuAppendAboutItem;
    MenuAppendSeparator*            : uiMenuAppendSeparator;
    -- Standard Dialogs 
    OpenFile*                       : uiOpenFile;
    OpenFolder*                     : uiOpenFolder;
    SaveFile*                       : uiSaveFile;
    MsgBox*                         : uiMsgBox;
    MsgBoxError*                    : uiMsgBoxError;
    -- Area
    NewArea*                        : uiNewArea;
    NewScrollingArea*               : uiNewScrollingArea;
    AreaSetSize*                    : uiAreaSetSize;
    AreaQueueRedrawAll*             : uiAreaQueueRedrawAll;
    AreaScrollTo*                   : uiAreaScrollTo;
    -- DrawPath
    DrawNewPath*                    : uiDrawNewPath;
    DrawFreePath*                   : uiDrawFreePath;
    DrawPathNewFigure*              : uiDrawPathNewFigure;
    DrawPathNewFigureWithArc*       : uiDrawPathNewFigureWithArc;
    DrawPathLineTo*                 : uiDrawPathLineTo;
    DrawPathArcTo*                  : uiDrawPathArcTo;
    DrawPathBezierTo*               : uiDrawPathBezierTo;
    DrawPathCloseFigure*            : uiDrawPathCloseFigure;
    DrawPathAddRectangle*           : uiDrawPathAddRectangle;
    DrawPathEnded*                  : uiDrawPathEnded;
    DrawPathEnd*                    : uiDrawPathEnd;
    -- Matrix
    DrawMatrixSetIdentity*          : uiDrawMatrixSetIdentity;
    DrawMatrixTranslate*            : uiDrawMatrixTranslate;
    DrawMatrixScale*                : uiDrawMatrixScale;
    DrawMatrixRotate*               : uiDrawMatrixRotate;
    DrawMatrixSkew*                 : uiDrawMatrixSkew;
    DrawMatrixMultiply*             : uiDrawMatrixMultiply;
    DrawMatrixInvertible*           : uiDrawMatrixInvertible;
    DrawMatrixInvert*               : uiDrawMatrixInvert;
    DrawMatrixTransformPoint*       : uiDrawMatrixTransformPoint;
    DrawMatrixTransformSize*        : uiDrawMatrixTransformSize;
    -- DrawContext
    DrawSave*                       : uiDrawSave;
    DrawRestore*                    : uiDrawRestore;
    DrawTransform*                  : uiDrawTransform;
    DrawClip*                       : uiDrawClip;
    DrawStroke*                     : uiDrawStroke;
    DrawFill*                       : uiDrawFill;
    -- ColorButton  
    NewColorButton*                 : uiNewColorButton;
    ColorButtonColor*               : uiColorButtonColor;
    ColorButtonSetColor*            : uiColorButtonSetColor;
    ColorButtonOnChanged*           : uiColorButtonOnChanged;
    -- Form 
    NewForm*                        : uiNewForm;
    FormAppend*                     : uiFormAppend;
    FormNumChildren*                : uiFormNumChildren;
    FormDelete*                     : uiFormDelete;
    FormPadded*                     : uiFormPadded;
    FormSetPadded*                  : uiFormSetPadded;
    -- Grid 
    NewGrid*                        : uiNewGrid;
    GridAppend*                     : uiGridAppend;
    GridInsertAt*                   : uiGridInsertAt;
    GridPadded*                     : uiGridPadded;
    GridSetPadded*                  : uiGridSetPadded;
    -- Image    
    NewImage*                       : uiNewImage;
    FreeImage*                      : uiFreeImage;
    ImageAppend*                    : uiImageAppend;
    -- TableValue   
    TableValueGetType*              : uiTableValueGetType;
    NewTableValueString*            : uiNewTableValueString;
    TableValueString*               : uiTableValueString;
    NewTableValueImage*             : uiNewTableValueImage;
    TableValueImage*                : uiTableValueImage;
    NewTableValueInt*               : uiNewTableValueInt;
    TableValueInt*                  : uiTableValueInt;
    NewTableValueColor*             : uiNewTableValueColor;
    TableValueColor*                : uiTableValueColor;
    -- TableModel   
    NewTableModel*                  : uiNewTableModel;
    FreeTableModel*                 : uiFreeTableModel;
    TableModelRowInserted*          : uiTableModelRowInserted;
    TableModelRowChanged*           : uiTableModelRowChanged;
    TableModelRowDeleted*           : uiTableModelRowDeleted;
    -- Table    
    NewTable*                       : uiNewTable;
    TableAppendTextColumn*          : uiTableAppendTextColumn;
    TableAppendImageColumn*         : uiTableAppendImageColumn;  
    TableAppendImageTextColumn*     : uiTableAppendImageTextColumn;
    TableAppendCheckboxColumn*      : uiTableAppendCheckboxColumn;
    TableAppendCheckboxTextColumn*  : uiTableAppendCheckboxTextColumn;
    TableAppendProgressBarColumn*   : uiTableAppendProgressBarColumn;
    TableAppendButtonColumn*        : uiTableAppendButtonColumn;
    TableHeaderVisible*             : uiTableHeaderVisible;
    TableHeaderSetVisible*          : uiTableHeaderSetVisible;
    TableOnRowClicked*              : uiTableOnRowClicked;
    TableOnRowDoubleClicked*        : uiTableOnRowDoubleClicked;
    TableHeaderSetSortIndicator*    : uiTableHeaderSetSortIndicator; 
    TableHeaderSortIndicator*       : uiTableHeaderSortIndicator;
    TableHeaderOnClicked*           : uiTableHeaderOnClicked;
    TableColumnWidth*               : uiTableColumnWidth;
    TableColumnSetWidth*            : uiTableColumnSetWidth;
    TableGetSelectionMode*          : uiTableGetSelectionMode;
    TableSetSelectionMode*          : uiTableSetSelectionMode;
    TableOnSelectionChanged*        : uiTableOnSelectionChanged;
    TableGetSelection*              : uiTableGetSelection;
    TableSetSelection*              : uiTableSetSelection;
    FreeTableSelection*             : uiFreeTableSelection;

PROCEDURE CStringLength*(adr : ADDRESS): LONGINT;
VAR
    i : LONGINT;
    ch : CHAR;
BEGIN
    IF adr = NIL THEN RETURN 0 END;
    i := 0; ch := 00X;
    LOOP
        SYSTEM.MOVE(adr, SYSTEM.ADR(ch), 1);
        IF ch = 00X THEN EXIT END;
        INC(i);
        adr := SYSTEM.ADDADR(adr, 1);
    END;
    RETURN i
END CStringLength;

PROCEDURE CStringCopy*(VAR dst : ARRAY OF CHAR; adr : ADDRESS);
VAR
    i : LONGINT;
    ch : CHAR;
BEGIN
    IF adr = NIL THEN dst[0] := 00X; RETURN END;
    i := 0;
    LOOP
        SYSTEM.MOVE(adr, SYSTEM.ADR(ch), 1);
        IF ch = 00X THEN EXIT END;
        dst[i] := ch;
        INC(i);
        adr := SYSTEM.ADDADR(adr, 1);
    END;
    dst[i] := 00X;
END CStringCopy;

PROCEDURE CopyText*(VAR dst : String.STRING; src :PCHAR);
BEGIN
    IF src # NIL THEN
        String.Reserve(dst, CStringLength(src));
        CStringCopy(dst^, src);
        FreeText(src);
    ELSE String.Assign(dst, "");
    END;
END CopyText;

PROCEDURE Initialize ();
VAR
    dll : dllRTS.HMOD;
BEGIN
    <* IF env_target = "x86nt" THEN *>
        dll := dllRTS.LoadModule("libui.dll");
    <* ELSIF env_target = 'x86linux' THEN *>
        dll := dllRTS.LoadModule("libui.so");
    <* ELSE *>
        *** OS NOT SUPPORTED ***
    <* END *>
    IF dll #  dllRTS.InvalidHandle THEN
        Init                        := SYSTEM.VAL(uiInit,                       dllRTS.GetProcAdr(dll, "uiInit"));
        Uninit                      := SYSTEM.VAL(uiUninit,                     dllRTS.GetProcAdr(dll, "uiUninit"));
        FreeInitError               := SYSTEM.VAL(uiFreeInitError,              dllRTS.GetProcAdr(dll, "uiFreeInitError"));
        Main                        := SYSTEM.VAL(uiMain,                       dllRTS.GetProcAdr(dll, "uiMain"));
        Quit                        := SYSTEM.VAL(uiQuit,                       dllRTS.GetProcAdr(dll, "uiQuit"));
        FreeText                    := SYSTEM.VAL(uiFreeText,                   dllRTS.GetProcAdr(dll, "uiFreeText"));
        -- Control
        ControlDestroy              := SYSTEM.VAL(uiControlDestroy,             dllRTS.GetProcAdr(dll, "uiControlDestroy"));
        ControlToplevel             := SYSTEM.VAL(uiControlToplevel,            dllRTS.GetProcAdr(dll, "uiControlToplevel"));
        ControlVisible              := SYSTEM.VAL(uiControlVisible,             dllRTS.GetProcAdr(dll, "uiControlVisible"));
        ControlShow                 := SYSTEM.VAL(uiControlShow,                dllRTS.GetProcAdr(dll, "uiControlShow"));
        ControlHide                 := SYSTEM.VAL(uiControlHide,                dllRTS.GetProcAdr(dll, "uiControlHide"));
        ControlEnabled              := SYSTEM.VAL(uiControlEnabled,             dllRTS.GetProcAdr(dll, "uiControlEnabled"));
        ControlEnable               := SYSTEM.VAL(uiControlEnable,              dllRTS.GetProcAdr(dll, "uiControlEnable"));
        ControlDisable              := SYSTEM.VAL(uiControlDisable,             dllRTS.GetProcAdr(dll, "uiControlDisable"));
        -- Window
        NewWindow                   := SYSTEM.VAL(uiNewWindow,                  dllRTS.GetProcAdr(dll, "uiNewWindow"));
        WindowTitle                 := SYSTEM.VAL(uiWindowTitle,                dllRTS.GetProcAdr(dll, "uiWindowTitle"));
        WindowSetTitle              := SYSTEM.VAL(uiWindowSetTitle,             dllRTS.GetProcAdr(dll, "uiWindowSetTitle"));
        WindowPosition              := SYSTEM.VAL(uiWindowPosition,             dllRTS.GetProcAdr(dll, "uiWindowPosition"));
        WindowSetPosition           := SYSTEM.VAL(uiWindowSetPosition,          dllRTS.GetProcAdr(dll, "uiWindowSetPosition"));
        WindowOnPositionChanged     := SYSTEM.VAL(uiWindowOnPositionChanged,    dllRTS.GetProcAdr(dll, "uiWindowOnPositionChanged"));
        WindowContentSize           := SYSTEM.VAL(uiWindowContentSize,          dllRTS.GetProcAdr(dll, "uiWindowContentSize"));
        WindowSetContentSize        := SYSTEM.VAL(uiWindowSetContentSize,       dllRTS.GetProcAdr(dll, "uiWindowSetContentSize"));
        WindowFullscreen            := SYSTEM.VAL(uiWindowFullscreen,           dllRTS.GetProcAdr(dll, "uiWindowFullscreen"));
        WindowSetFullscreen         := SYSTEM.VAL(uiWindowSetFullscreen,        dllRTS.GetProcAdr(dll, "uiWindowSetFullscreen"));
        WindowOnContentSizeChanged  := SYSTEM.VAL(uiWindowOnContentSizeChanged, dllRTS.GetProcAdr(dll, "uiWindowOnContentSizeChanged"));
        WindowOnClosing             := SYSTEM.VAL(uiWindowOnClosing,            dllRTS.GetProcAdr(dll, "uiWindowOnClosing"));
        WindowOnFocusChanged        := SYSTEM.VAL(uiWindowOnFocusChanged,       dllRTS.GetProcAdr(dll, "uiWindowOnFocusChanged"));
        WindowFocused               := SYSTEM.VAL(uiWindowFocused,              dllRTS.GetProcAdr(dll, "uiWindowFocused"));
        WindowBorderless            := SYSTEM.VAL(uiWindowBorderless,           dllRTS.GetProcAdr(dll, "uiWindowBorderless"));
        WindowSetBorderless         := SYSTEM.VAL(uiWindowSetBorderless,        dllRTS.GetProcAdr(dll, "uiWindowSetBorderless"));
        WindowSetChild              := SYSTEM.VAL(uiWindowSetChild,             dllRTS.GetProcAdr(dll, "uiWindowSetChild"));
        WindowMargined              := SYSTEM.VAL(uiWindowMargined,             dllRTS.GetProcAdr(dll, "uiWindowMargined"));
        WindowSetMargined           := SYSTEM.VAL(uiWindowSetMargined,          dllRTS.GetProcAdr(dll, "uiWindowSetMargined"));
        WindowResizeable            := SYSTEM.VAL(uiWindowResizeable,           dllRTS.GetProcAdr(dll, "uiWindowResizeable"));
        WindowSetResizeable         := SYSTEM.VAL(uiWindowSetResizeable,        dllRTS.GetProcAdr(dll, "uiWindowSetResizeable"));
        -- Button
        NewButton                   := SYSTEM.VAL(uiNewButton,                  dllRTS.GetProcAdr(dll, "uiNewButton"));
        ButtonText                  := SYSTEM.VAL(uiButtonText,                 dllRTS.GetProcAdr(dll, "uiButtonText"));
        ButtonSetText               := SYSTEM.VAL(uiButtonSetText,              dllRTS.GetProcAdr(dll, "uiButtonSetText"));
        ButtonOnClicked             := SYSTEM.VAL(uiButtonOnClicked,            dllRTS.GetProcAdr(dll, "uiButtonOnClicked"));
        -- Box
        NewVerticalBox              := SYSTEM.VAL(uiNewVerticalBox,             dllRTS.GetProcAdr(dll, "uiNewVerticalBox"));
        NewHorizontalBox            := SYSTEM.VAL(uiNewHorizontalBox,           dllRTS.GetProcAdr(dll, "uiNewHorizontalBox"));
        BoxAppend                   := SYSTEM.VAL(uiBoxAppend,                  dllRTS.GetProcAdr(dll, "uiBoxAppend"));
        BoxNumChildren              := SYSTEM.VAL(uiBoxNumChildren,             dllRTS.GetProcAdr(dll, "uiBoxNumChildren"));
        BoxDelete                   := SYSTEM.VAL(uiBoxDelete,                  dllRTS.GetProcAdr(dll, "uiBoxDelete"));
        BoxPadded                   := SYSTEM.VAL(uiBoxPadded,                  dllRTS.GetProcAdr(dll, "uiBoxPadded"));
        BoxSetPadded                := SYSTEM.VAL(uiBoxSetPadded,               dllRTS.GetProcAdr(dll, "uiBoxSetPadded"));
        -- Checkbox
        NewCheckbox                 := SYSTEM.VAL(uiNewCheckbox,                dllRTS.GetProcAdr(dll, "uiNewCheckbox"));      
        CheckboxText                := SYSTEM.VAL(uiCheckboxText,               dllRTS.GetProcAdr(dll, "uiCheckboxText"));      
        CheckboxSetText             := SYSTEM.VAL(uiCheckboxSetText,            dllRTS.GetProcAdr(dll, "uiCheckboxSetText"));   
        CheckboxOnToggled           := SYSTEM.VAL(uiCheckboxOnToggled,          dllRTS.GetProcAdr(dll, "uiCheckboxOnToggled")); 
        CheckboxChecked             := SYSTEM.VAL(uiCheckboxChecked,            dllRTS.GetProcAdr(dll, "uiCheckboxChecked"));   
        CheckboxSetChecked          := SYSTEM.VAL(uiCheckboxSetChecked,         dllRTS.GetProcAdr(dll, "uiCheckboxSetChecked"));
        -- Entry
        NewEntry                    := SYSTEM.VAL(uiNewEntry,                   dllRTS.GetProcAdr(dll, "uiNewEntry"));         
        NewPasswordEntry            := SYSTEM.VAL(uiNewPasswordEntry,           dllRTS.GetProcAdr(dll, "uiNewPasswordEntry")); 
        NewSearchEntry              := SYSTEM.VAL(uiNewSearchEntry,             dllRTS.GetProcAdr(dll, "uiNewSearchEntry"));   
        EntryText                   := SYSTEM.VAL(uiEntryText,                  dllRTS.GetProcAdr(dll, "uiEntryText"));        
        EntrySetText                := SYSTEM.VAL(uiEntrySetText,               dllRTS.GetProcAdr(dll, "uiEntrySetText"));     
        EntryOnChanged              := SYSTEM.VAL(uiEntryOnChanged,             dllRTS.GetProcAdr(dll, "uiEntryOnChanged"));   
        EntryReadOnly               := SYSTEM.VAL(uiEntryReadOnly,              dllRTS.GetProcAdr(dll, "uiEntryReadOnly"));    
        EntrySetReadOnly            := SYSTEM.VAL(uiEntrySetReadOnly,           dllRTS.GetProcAdr(dll, "uiEntrySetReadOnly")); 
        -- Label
        NewLabel                    := SYSTEM.VAL(uiNewLabel,                   dllRTS.GetProcAdr(dll, "uiNewLabel"));
        LabelText                   := SYSTEM.VAL(uiLabelText,                  dllRTS.GetProcAdr(dll, "uiLabelText"));
        LabelSetText                := SYSTEM.VAL(uiLabelSetText,               dllRTS.GetProcAdr(dll, "uiLabelSetText"));
        -- Tab
        NewTab                      := SYSTEM.VAL(uiNewTab,                     dllRTS.GetProcAdr(dll, "uiNewTab"));      
        TabAppend                   := SYSTEM.VAL(uiTabAppend,                  dllRTS.GetProcAdr(dll, "uiTabAppend"));
        TabInsertAt                 := SYSTEM.VAL(uiTabInsertAt,                dllRTS.GetProcAdr(dll, "uiTabInsertAt"));
        TabDelete                   := SYSTEM.VAL(uiTabDelete,                  dllRTS.GetProcAdr(dll, "uiTabDelete"));
        TabNumPages                 := SYSTEM.VAL(uiTabNumPages,                dllRTS.GetProcAdr(dll, "uiTabNumPages"));
        TabMargined                 := SYSTEM.VAL(uiTabMargined,                dllRTS.GetProcAdr(dll, "uiTabMargined"));
        TabSetMargined              := SYSTEM.VAL(uiTabSetMargined,             dllRTS.GetProcAdr(dll, "uiTabSetMargined"));
        -- Group
        NewGroup                    := SYSTEM.VAL(uiNewGroup,                   dllRTS.GetProcAdr(dll, "uiNewGroup"));     
        GroupTitle                  := SYSTEM.VAL(uiGroupTitle,                 dllRTS.GetProcAdr(dll, "uiGroupTitle"));
        GroupSetTitle               := SYSTEM.VAL(uiGroupSetTitle,              dllRTS.GetProcAdr(dll, "uiGroupSetTitle"));
        GroupSetChild               := SYSTEM.VAL(uiGroupSetChild,              dllRTS.GetProcAdr(dll, "uiGroupSetChild"));
        GroupMargined               := SYSTEM.VAL(uiGroupMargined,              dllRTS.GetProcAdr(dll, "uiGroupMargined"));
        GroupSetMargined            := SYSTEM.VAL(uiGroupSetMargined,           dllRTS.GetProcAdr(dll, "uiGroupSetMargined"));
        -- Spinbox
        NewSpinbox                  := SYSTEM.VAL(uiNewSpinbox,                 dllRTS.GetProcAdr(dll, "uiNewSpinbox"));
        SpinboxValue                := SYSTEM.VAL(uiSpinboxValue,               dllRTS.GetProcAdr(dll, "uiSpinboxValue"));
        SpinboxSetValue             := SYSTEM.VAL(uiSpinboxSetValue,            dllRTS.GetProcAdr(dll, "uiSpinboxSetValue"));
        SpinboxOnChanged            := SYSTEM.VAL(uiSpinboxOnChanged,           dllRTS.GetProcAdr(dll, "uiSpinboxOnChanged"));
        -- Slider
        NewSlider                   := SYSTEM.VAL(uiNewSlider,                  dllRTS.GetProcAdr(dll, "uiNewSlider"));
        SliderValue                 := SYSTEM.VAL(uiSliderValue,                dllRTS.GetProcAdr(dll, "uiSliderValue"));
        SliderSetValue              := SYSTEM.VAL(uiSliderSetValue,             dllRTS.GetProcAdr(dll, "uiSliderSetValue"));     
        SliderHasToolTip            := SYSTEM.VAL(uiSliderHasToolTip,           dllRTS.GetProcAdr(dll, "uiSliderHasToolTip"));
        SliderSetHasToolTip         := SYSTEM.VAL(uiSliderSetHasToolTip,        dllRTS.GetProcAdr(dll, "uiSliderSetHasToolTip"));
        SliderOnChanged             := SYSTEM.VAL(uiSliderOnChanged,            dllRTS.GetProcAdr(dll, "uiSliderOnChanged"));
        SliderOnReleased            := SYSTEM.VAL(uiSliderOnReleased,           dllRTS.GetProcAdr(dll, "uiSliderOnReleased"));
        SliderSetRange              := SYSTEM.VAL(uiSliderSetRange,             dllRTS.GetProcAdr(dll, "uiSliderSetRange"));
        -- ProgressBar
        NewProgressBar              := SYSTEM.VAL(uiNewProgressBar,             dllRTS.GetProcAdr(dll, "uiNewProgressBar"));
        ProgressBarValue            := SYSTEM.VAL(uiProgressBarValue,           dllRTS.GetProcAdr(dll, "uiProgressBarValue"));
        ProgressBarSetValue         := SYSTEM.VAL(uiProgressBarSetValue,        dllRTS.GetProcAdr(dll, "uiProgressBarSetValue"));
        -- Separator
        NewHorizontalSeparator      := SYSTEM.VAL(uiNewHorizontalSeparator,     dllRTS.GetProcAdr(dll, "uiNewHorizontalSeparator"));
        NewVerticalSeparator        := SYSTEM.VAL(uiNewVerticalSeparator,       dllRTS.GetProcAdr(dll, "uiNewVerticalSeparator"));
        -- Combobox
        NewCombobox                 := SYSTEM.VAL(uiNewCombobox,                dllRTS.GetProcAdr(dll, "uiNewCombobox"));
        ComboboxAppend              := SYSTEM.VAL(uiComboboxAppend,             dllRTS.GetProcAdr(dll, "uiComboboxAppend"));
        ComboboxInsertAt            := SYSTEM.VAL(uiComboboxInsertAt,           dllRTS.GetProcAdr(dll, "uiComboboxInsertAt"));
        ComboboxDelete              := SYSTEM.VAL(uiComboboxDelete,             dllRTS.GetProcAdr(dll, "uiComboboxDelete"));
        ComboboxClear               := SYSTEM.VAL(uiComboboxClear,              dllRTS.GetProcAdr(dll, "uiComboboxClear"));
        ComboboxNumItems            := SYSTEM.VAL(uiComboboxNumItems,           dllRTS.GetProcAdr(dll, "uiComboboxNumItems"));
        ComboboxSelected            := SYSTEM.VAL(uiComboboxSelected,           dllRTS.GetProcAdr(dll, "uiComboboxSelected"));
        ComboboxSetSelected         := SYSTEM.VAL(uiComboboxSetSelected,        dllRTS.GetProcAdr(dll, "uiComboboxSetSelected"));
        ComboboxOnSelected          := SYSTEM.VAL(uiComboboxOnSelected,         dllRTS.GetProcAdr(dll, "uiComboboxOnSelected"));
        -- EditableCombobox
        NewEditableCombobox         := SYSTEM.VAL(uiNewEditableCombobox,        dllRTS.GetProcAdr(dll, "uiNewEditableCombobox"));
        EditableComboboxAppend      := SYSTEM.VAL(uiEditableComboboxAppend,     dllRTS.GetProcAdr(dll, "uiEditableComboboxAppend"));
        EditableComboboxText        := SYSTEM.VAL(uiEditableComboboxText,       dllRTS.GetProcAdr(dll, "uiEditableComboboxText"));
        EditableComboboxSetText     := SYSTEM.VAL(uiEditableComboboxSetText,    dllRTS.GetProcAdr(dll, "uiEditableComboboxSetText"));
        EditableComboboxOnChanged   := SYSTEM.VAL(uiEditableComboboxOnChanged,  dllRTS.GetProcAdr(dll, "uiEditableComboboxOnChanged"));
        -- RadioButtons
        NewRadioButtons             := SYSTEM.VAL(uiNewRadioButtons,            dllRTS.GetProcAdr(dll, "uiNewRadioButtons"));
        RadioButtonsAppend          := SYSTEM.VAL(uiRadioButtonsAppend,         dllRTS.GetProcAdr(dll, "uiRadioButtonsAppend"));
        RadioButtonsSelected        := SYSTEM.VAL(uiRadioButtonsSelected,       dllRTS.GetProcAdr(dll, "uiRadioButtonsSelected"));
        RadioButtonsSetSelected     := SYSTEM.VAL(uiRadioButtonsSetSelected,    dllRTS.GetProcAdr(dll, "uiRadioButtonsSetSelected"));
        RadioButtonsOnSelected      := SYSTEM.VAL(uiRadioButtonsOnSelected,     dllRTS.GetProcAdr(dll, "uiRadioButtonsOnSelected"));
        -- DateTimePicker
        NewDateTimePicker           := SYSTEM.VAL(uiNewDateTimePicker,          dllRTS.GetProcAdr(dll, "uiNewDateTimePicker"));
        NewDatePicker               := SYSTEM.VAL(uiNewDatePicker,              dllRTS.GetProcAdr(dll, "uiNewDatePicker"));
        NewTimePicker               := SYSTEM.VAL(uiNewTimePicker,              dllRTS.GetProcAdr(dll, "uiNewTimePicker"));
        DateTimePickerTime          := SYSTEM.VAL(uiDateTimePickerTime,         dllRTS.GetProcAdr(dll, "uiDateTimePickerTime"));
        DateTimePickerSetTime       := SYSTEM.VAL(uiDateTimePickerSetTime,      dllRTS.GetProcAdr(dll, "uiDateTimePickerSetTime"));
        DateTimePickerOnChanged     := SYSTEM.VAL(uiDateTimePickerOnChanged,    dllRTS.GetProcAdr(dll, "uiDateTimePickerOnChanged"));
        -- MultilineEntry
        NewMultilineEntry               := SYSTEM.VAL(uiNewMultilineEntry,              dllRTS.GetProcAdr(dll, "uiNewMultilineEntry"));
        NewNonWrappingMultilineEntry    := SYSTEM.VAL(uiNewNonWrappingMultilineEntry,   dllRTS.GetProcAdr(dll, "uiNewNonWrappingMultilineEntry"));
        MultilineEntryText              := SYSTEM.VAL(uiMultilineEntryText,             dllRTS.GetProcAdr(dll, "uiMultilineEntryText"));
        MultilineEntrySetText           := SYSTEM.VAL(uiMultilineEntrySetText,          dllRTS.GetProcAdr(dll, "uiMultilineEntrySetText"));
        MultilineEntryAppend            := SYSTEM.VAL(uiMultilineEntryAppend,           dllRTS.GetProcAdr(dll, "uiMultilineEntryAppend"));
        MultilineEntryOnChanged         := SYSTEM.VAL(uiMultilineEntryOnChanged,        dllRTS.GetProcAdr(dll, "uiMultilineEntryOnChanged"));
        MultilineEntryReadOnly          := SYSTEM.VAL(uiMultilineEntryReadOnly,         dllRTS.GetProcAdr(dll, "uiMultilineEntryReadOnly"));
        MultilineEntrySetReadOnly       := SYSTEM.VAL(uiMultilineEntrySetReadOnly,      dllRTS.GetProcAdr(dll, "uiMultilineEntrySetReadOnly"));
        -- MenuItem
        MenuItemEnable              := SYSTEM.VAL(uiMenuItemEnable,             dllRTS.GetProcAdr(dll, "uiMenuItemEnable"));
        MenuItemDisable             := SYSTEM.VAL(uiMenuItemDisable,            dllRTS.GetProcAdr(dll, "uiMenuItemDisable"));
        MenuItemOnClicked           := SYSTEM.VAL(uiMenuItemOnClicked,          dllRTS.GetProcAdr(dll, "uiMenuItemOnClicked"));
        MenuItemChecked             := SYSTEM.VAL(uiMenuItemChecked,            dllRTS.GetProcAdr(dll, "uiMenuItemChecked"));
        MenuItemSetChecked          := SYSTEM.VAL(uiMenuItemSetChecked,         dllRTS.GetProcAdr(dll, "uiMenuItemSetChecked"));
        -- Menu
        NewMenu                     := SYSTEM.VAL(uiNewMenu,                    dllRTS.GetProcAdr(dll, "uiNewMenu"));
        MenuAppendItem              := SYSTEM.VAL(uiMenuAppendItem,             dllRTS.GetProcAdr(dll, "uiMenuAppendItem"));
        MenuAppendCheckItem         := SYSTEM.VAL(uiMenuAppendCheckItem,        dllRTS.GetProcAdr(dll, "uiMenuAppendCheckItem"));
        MenuAppendQuitItem          := SYSTEM.VAL(uiMenuAppendQuitItem,         dllRTS.GetProcAdr(dll, "uiMenuAppendQuitItem"));
        MenuAppendPreferencesItem   := SYSTEM.VAL(uiMenuAppendPreferencesItem,  dllRTS.GetProcAdr(dll, "uiMenuAppendPreferencesItem"));
        MenuAppendAboutItem         := SYSTEM.VAL(uiMenuAppendAboutItem,        dllRTS.GetProcAdr(dll, "uiMenuAppendAboutItem"));
        MenuAppendSeparator         := SYSTEM.VAL(uiMenuAppendSeparator,        dllRTS.GetProcAdr(dll, "uiMenuAppendSeparator"));
        -- Standard Dialogs
        OpenFile                    := SYSTEM.VAL(uiOpenFile,                   dllRTS.GetProcAdr(dll, "uiOpenFile"));
        OpenFolder                  := SYSTEM.VAL(uiOpenFolder,                 dllRTS.GetProcAdr(dll, "uiOpenFolder"));
        SaveFile                    := SYSTEM.VAL(uiSaveFile,                   dllRTS.GetProcAdr(dll, "uiSaveFile"));
        MsgBox                      := SYSTEM.VAL(uiMsgBox,                     dllRTS.GetProcAdr(dll, "uiMsgBox"));
        MsgBoxError                 := SYSTEM.VAL(uiMsgBoxError,                dllRTS.GetProcAdr(dll, "uiMsgBoxError"));
        -- Area
        NewArea                     := SYSTEM.VAL(uiNewArea,                    dllRTS.GetProcAdr(dll, "uiNewArea"));
        NewScrollingArea            := SYSTEM.VAL(uiNewScrollingArea,           dllRTS.GetProcAdr(dll, "uiNewScrollingArea"));
        AreaSetSize                 := SYSTEM.VAL(uiAreaSetSize,                dllRTS.GetProcAdr(dll, "uiAreaSetSize"));
        AreaQueueRedrawAll          := SYSTEM.VAL(uiAreaQueueRedrawAll,         dllRTS.GetProcAdr(dll, "uiAreaQueueRedrawAll"));
        AreaScrollTo                := SYSTEM.VAL(uiAreaScrollTo,               dllRTS.GetProcAdr(dll, "uiAreaScrollTo"));
        -- DrawPath
        DrawNewPath                 := SYSTEM.VAL(uiDrawNewPath,                dllRTS.GetProcAdr(dll, "uiDrawNewPath"));
        DrawFreePath                := SYSTEM.VAL(uiDrawFreePath,               dllRTS.GetProcAdr(dll, "uiDrawFreePath"));
        DrawPathNewFigure           := SYSTEM.VAL(uiDrawPathNewFigure,          dllRTS.GetProcAdr(dll, "uiDrawPathNewFigure"));
        DrawPathNewFigureWithArc    := SYSTEM.VAL(uiDrawPathNewFigureWithArc,   dllRTS.GetProcAdr(dll, "uiDrawPathNewFigureWithArc"));
        DrawPathLineTo              := SYSTEM.VAL(uiDrawPathLineTo,             dllRTS.GetProcAdr(dll, "uiDrawPathLineTo"));
        DrawPathArcTo               := SYSTEM.VAL(uiDrawPathArcTo,              dllRTS.GetProcAdr(dll, "uiDrawPathArcTo"));
        DrawPathBezierTo            := SYSTEM.VAL(uiDrawPathBezierTo,           dllRTS.GetProcAdr(dll, "uiDrawPathBezierTo"));
        DrawPathCloseFigure         := SYSTEM.VAL(uiDrawPathCloseFigure,        dllRTS.GetProcAdr(dll, "uiDrawPathCloseFigure"));
        DrawPathAddRectangle        := SYSTEM.VAL(uiDrawPathAddRectangle,       dllRTS.GetProcAdr(dll, "uiDrawPathAddRectangle"));
        DrawPathEnded               := SYSTEM.VAL(uiDrawPathEnded,              dllRTS.GetProcAdr(dll, "uiDrawPathEnded"));
        DrawPathEnd                 := SYSTEM.VAL(uiDrawPathEnd,                dllRTS.GetProcAdr(dll, "uiDrawPathEnd"));
        -- DrawMatrix
        DrawMatrixSetIdentity       := SYSTEM.VAL(uiDrawMatrixSetIdentity,      dllRTS.GetProcAdr(dll, "uiDrawMatrixSetIdentity"));
        DrawMatrixTranslate         := SYSTEM.VAL(uiDrawMatrixTranslate,        dllRTS.GetProcAdr(dll, "uiDrawMatrixTranslate"));
        DrawMatrixScale             := SYSTEM.VAL(uiDrawMatrixScale,            dllRTS.GetProcAdr(dll, "uiDrawMatrixScale"));
        DrawMatrixRotate            := SYSTEM.VAL(uiDrawMatrixRotate,           dllRTS.GetProcAdr(dll, "uiDrawMatrixRotate"));
        DrawMatrixSkew              := SYSTEM.VAL(uiDrawMatrixSkew,             dllRTS.GetProcAdr(dll, "uiDrawMatrixSkew"));
        DrawMatrixMultiply          := SYSTEM.VAL(uiDrawMatrixMultiply,         dllRTS.GetProcAdr(dll, "uiDrawMatrixMultiply"));
        DrawMatrixInvertible        := SYSTEM.VAL(uiDrawMatrixInvertible,       dllRTS.GetProcAdr(dll, "uiDrawMatrixInvertible"));
        DrawMatrixInvert            := SYSTEM.VAL(uiDrawMatrixInvert,           dllRTS.GetProcAdr(dll, "uiDrawMatrixInvert"));
        DrawMatrixTransformPoint    := SYSTEM.VAL(uiDrawMatrixTransformPoint,   dllRTS.GetProcAdr(dll, "uiDrawMatrixTransformPoint"));
        DrawMatrixTransformSize     := SYSTEM.VAL(uiDrawMatrixTransformSize,    dllRTS.GetProcAdr(dll, "uiDrawMatrixTransformSize"));
        -- DrawContext
        DrawSave                    := SYSTEM.VAL(uiDrawSave,                   dllRTS.GetProcAdr(dll, "uiDrawSave"));
        DrawRestore                 := SYSTEM.VAL(uiDrawRestore,                dllRTS.GetProcAdr(dll, "uiDrawRestore"));
        DrawTransform               := SYSTEM.VAL(uiDrawTransform,              dllRTS.GetProcAdr(dll, "uiDrawTransform"));
        DrawClip                    := SYSTEM.VAL(uiDrawClip,                   dllRTS.GetProcAdr(dll, "uiDrawClip"));
        DrawStroke                  := SYSTEM.VAL(uiDrawStroke,                 dllRTS.GetProcAdr(dll, "uiDrawStroke"));
        DrawFill                    := SYSTEM.VAL(uiDrawFill,                   dllRTS.GetProcAdr(dll, "uiDrawFill"));
        -- ColorButton
        NewColorButton              := SYSTEM.VAL(uiNewColorButton,             dllRTS.GetProcAdr(dll, "uiNewColorButton"));
        ColorButtonColor            := SYSTEM.VAL(uiColorButtonColor,           dllRTS.GetProcAdr(dll, "uiColorButtonColor"));
        ColorButtonSetColor         := SYSTEM.VAL(uiColorButtonSetColor,        dllRTS.GetProcAdr(dll, "uiColorButtonSetColor"));
        ColorButtonOnChanged        := SYSTEM.VAL(uiColorButtonOnChanged,       dllRTS.GetProcAdr(dll, "uiColorButtonOnChanged"));
        -- Form
        NewForm                     := SYSTEM.VAL(uiNewForm,                    dllRTS.GetProcAdr(dll, "uiNewForm"));
        FormAppend                  := SYSTEM.VAL(uiFormAppend,                 dllRTS.GetProcAdr(dll, "uiFormAppend"));
        FormNumChildren             := SYSTEM.VAL(uiFormNumChildren,            dllRTS.GetProcAdr(dll, "uiFormNumChildren"));
        FormDelete                  := SYSTEM.VAL(uiFormDelete,                 dllRTS.GetProcAdr(dll, "uiFormDelete"));
        FormPadded                  := SYSTEM.VAL(uiFormPadded,                 dllRTS.GetProcAdr(dll, "uiFormPadded"));
        FormSetPadded               := SYSTEM.VAL(uiFormSetPadded,              dllRTS.GetProcAdr(dll, "uiFormSetPadded"));
        -- Grid
        NewGrid                     := SYSTEM.VAL(uiNewGrid,                    dllRTS.GetProcAdr(dll, "uiNewGrid"));
        GridAppend                  := SYSTEM.VAL(uiGridAppend,                 dllRTS.GetProcAdr(dll, "uiGridAppend"));
        GridInsertAt                := SYSTEM.VAL(uiGridInsertAt,               dllRTS.GetProcAdr(dll, "uiGridInsertAt"));
        GridPadded                  := SYSTEM.VAL(uiGridPadded,                 dllRTS.GetProcAdr(dll, "uiGridPadded"));
        GridSetPadded               := SYSTEM.VAL(uiGridSetPadded,              dllRTS.GetProcAdr(dll, "uiGridSetPadded"));
        -- Image
        NewImage                    := SYSTEM.VAL(uiNewImage,                   dllRTS.GetProcAdr(dll, "uiNewImage"));
        FreeImage                   := SYSTEM.VAL(uiFreeImage,                  dllRTS.GetProcAdr(dll, "uiFreeImage"));
        ImageAppend                 := SYSTEM.VAL(uiImageAppend,                dllRTS.GetProcAdr(dll, "uiImageAppend"));
        -- TableValue
        TableValueGetType           := SYSTEM.VAL(uiTableValueGetType,          dllRTS.GetProcAdr(dll, "uiTableValueGetType"));
        NewTableValueString         := SYSTEM.VAL(uiNewTableValueString,        dllRTS.GetProcAdr(dll, "uiNewTableValueString"));
        TableValueString            := SYSTEM.VAL(uiTableValueString,           dllRTS.GetProcAdr(dll, "uiTableValueString"));
        NewTableValueImage          := SYSTEM.VAL(uiNewTableValueImage,         dllRTS.GetProcAdr(dll, "uiNewTableValueImage"));
        TableValueImage             := SYSTEM.VAL(uiTableValueImage,            dllRTS.GetProcAdr(dll, "uiTableValueImage"));
        NewTableValueInt            := SYSTEM.VAL(uiNewTableValueInt,           dllRTS.GetProcAdr(dll, "uiNewTableValueInt"));
        TableValueInt               := SYSTEM.VAL(uiTableValueInt,              dllRTS.GetProcAdr(dll, "uiTableValueInt"));
        NewTableValueColor          := SYSTEM.VAL(uiNewTableValueColor,         dllRTS.GetProcAdr(dll, "uiNewTableValueColor"));
        TableValueColor             := SYSTEM.VAL(uiTableValueColor,            dllRTS.GetProcAdr(dll, "uiTableValueColor"));
        -- TableModel
        NewTableModel               := SYSTEM.VAL(uiNewTableModel,              dllRTS.GetProcAdr(dll, "uiNewTableModel"));
        FreeTableModel              := SYSTEM.VAL(uiFreeTableModel,             dllRTS.GetProcAdr(dll, "uiFreeTableModel"));
        TableModelRowInserted       := SYSTEM.VAL(uiTableModelRowInserted,      dllRTS.GetProcAdr(dll, "uiTableModelRowInserted"));
        TableModelRowChanged        := SYSTEM.VAL(uiTableModelRowChanged,       dllRTS.GetProcAdr(dll, "uiTableModelRowChanged"));
        TableModelRowDeleted        := SYSTEM.VAL(uiTableModelRowDeleted,       dllRTS.GetProcAdr(dll, "uiTableModelRowDeleted"));
        -- Table    
        NewTable                        := SYSTEM.VAL(uiNewTable,                       dllRTS.GetProcAdr(dll, "uiNewTable"));
        TableAppendTextColumn           := SYSTEM.VAL(uiTableAppendTextColumn,          dllRTS.GetProcAdr(dll, "uiTableAppendTextColumn"));
        TableAppendImageColumn          := SYSTEM.VAL(uiTableAppendImageColumn,         dllRTS.GetProcAdr(dll, "uiTableAppendImageColumn"));
        TableAppendImageTextColumn      := SYSTEM.VAL(uiTableAppendImageTextColumn,     dllRTS.GetProcAdr(dll, "uiTableAppendImageTextColumn"));
        TableAppendCheckboxColumn       := SYSTEM.VAL(uiTableAppendCheckboxColumn,      dllRTS.GetProcAdr(dll, "uiTableAppendCheckboxColumn"));
        TableAppendCheckboxTextColumn   := SYSTEM.VAL(uiTableAppendCheckboxTextColumn,  dllRTS.GetProcAdr(dll, "uiTableAppendCheckboxTextColumn"));
        TableAppendProgressBarColumn    := SYSTEM.VAL(uiTableAppendProgressBarColumn,   dllRTS.GetProcAdr(dll, "uiTableAppendProgressBarColumn"));
        TableAppendButtonColumn         := SYSTEM.VAL(uiTableAppendButtonColumn,        dllRTS.GetProcAdr(dll, "uiTableAppendButtonColumn"));
        TableHeaderVisible              := SYSTEM.VAL(uiTableHeaderVisible,             dllRTS.GetProcAdr(dll, "uiTableHeaderVisible"));
        TableHeaderSetVisible           := SYSTEM.VAL(uiTableHeaderSetVisible,          dllRTS.GetProcAdr(dll, "uiTableHeaderSetVisible"));
        TableOnRowClicked               := SYSTEM.VAL(uiTableOnRowClicked,              dllRTS.GetProcAdr(dll, "uiTableOnRowClicked"));
        TableOnRowDoubleClicked         := SYSTEM.VAL(uiTableOnRowDoubleClicked,        dllRTS.GetProcAdr(dll, "uiTableOnRowDoubleClicked"));
        TableHeaderSetSortIndicator     := SYSTEM.VAL(uiTableHeaderSetSortIndicator,    dllRTS.GetProcAdr(dll, "uiTableHeaderSetSortIndicator"));
        TableHeaderSortIndicator        := SYSTEM.VAL(uiTableHeaderSortIndicator,       dllRTS.GetProcAdr(dll, "uiTableHeaderSortIndicator"));
        TableHeaderOnClicked            := SYSTEM.VAL(uiTableHeaderOnClicked,           dllRTS.GetProcAdr(dll, "uiTableHeaderOnClicked"));
        TableColumnWidth                := SYSTEM.VAL(uiTableColumnWidth,               dllRTS.GetProcAdr(dll, "uiTableColumnWidth"));
        TableColumnSetWidth             := SYSTEM.VAL(uiTableColumnSetWidth,            dllRTS.GetProcAdr(dll, "uiTableColumnSetWidth"));
        TableGetSelectionMode           := SYSTEM.VAL(uiTableGetSelectionMode,          dllRTS.GetProcAdr(dll, "uiTableGetSelectionMode"));
        TableSetSelectionMode           := SYSTEM.VAL(uiTableSetSelectionMode,          dllRTS.GetProcAdr(dll, "uiTableSetSelectionMode"));
        TableOnSelectionChanged         := SYSTEM.VAL(uiTableOnSelectionChanged,        dllRTS.GetProcAdr(dll, "uiTableOnSelectionChanged"));
        TableGetSelection               := SYSTEM.VAL(uiTableGetSelection,              dllRTS.GetProcAdr(dll, "uiTableGetSelection"));
        TableSetSelection               := SYSTEM.VAL(uiTableSetSelection,              dllRTS.GetProcAdr(dll, "uiTableSetSelection"));
        FreeTableSelection              := SYSTEM.VAL(uiFreeTableSelection,             dllRTS.GetProcAdr(dll, "uiFreeTableSelection"));

    ELSE
        Init                        := NIL;
        Uninit                      := NIL;
        FreeInitError               := NIL;
        Main                        := NIL;
        Quit                        := NIL;
        FreeText                    := NIL;
        ControlDestroy              := NIL;
        ControlToplevel             := NIL;
        ControlVisible              := NIL;
        ControlShow                 := NIL;
        ControlHide                 := NIL;
        ControlEnabled              := NIL;
        ControlEnable               := NIL;
        ControlDisable              := NIL;
        NewWindow                   := NIL;
        WindowTitle                 := NIL;
        WindowSetTitle              := NIL;
        WindowPosition              := NIL;
        WindowSetPosition           := NIL;
        WindowOnPositionChanged     := NIL;
        WindowContentSize           := NIL;
        WindowSetContentSize        := NIL;
        WindowFullscreen            := NIL;
        WindowSetFullscreen         := NIL;
        WindowOnContentSizeChanged  := NIL;
        WindowOnClosing             := NIL;
        WindowOnFocusChanged        := NIL;
        WindowFocused               := NIL;
        WindowBorderless            := NIL;
        WindowSetBorderless         := NIL;
        WindowSetChild              := NIL;
        WindowMargined              := NIL;
        WindowSetMargined           := NIL;
        WindowResizeable            := NIL;
        WindowSetResizeable         := NIL;
        NewButton                   := NIL;
        ButtonText                  := NIL;
        ButtonSetText               := NIL;
        ButtonOnClicked             := NIL;
        NewVerticalBox              := NIL;
        NewHorizontalBox            := NIL;
        BoxAppend                   := NIL;
        BoxNumChildren              := NIL;
        BoxDelete                   := NIL;
        BoxPadded                   := NIL;
        BoxSetPadded                := NIL;
        NewCheckbox                 := NIL;
        CheckboxText                := NIL;
        CheckboxSetText             := NIL;
        CheckboxOnToggled           := NIL;
        CheckboxChecked             := NIL;
        CheckboxSetChecked          := NIL;
        NewEntry                    := NIL;
        NewPasswordEntry            := NIL;
        NewSearchEntry              := NIL;
        EntryText                   := NIL;
        EntrySetText                := NIL;
        EntryOnChanged              := NIL;
        EntryReadOnly               := NIL;
        EntrySetReadOnly            := NIL;
        NewLabel                    := NIL;
        LabelText                   := NIL;
        LabelSetText                := NIL;
        NewTab                      := NIL;
        TabAppend                   := NIL;
        TabInsertAt                 := NIL;
        TabDelete                   := NIL;
        TabNumPages                 := NIL;
        TabMargined                 := NIL;
        TabSetMargined              := NIL;
        NewGroup                    := NIL;
        GroupTitle                  := NIL;
        GroupSetTitle               := NIL;
        GroupSetChild               := NIL;
        GroupMargined               := NIL;
        GroupSetMargined            := NIL;
        NewSpinbox                  := NIL;
        SpinboxValue                := NIL;
        SpinboxSetValue             := NIL;
        SpinboxOnChanged            := NIL;
        NewSlider                   := NIL;
        SliderValue                 := NIL;
        SliderSetValue              := NIL;
        SliderHasToolTip            := NIL;
        SliderSetHasToolTip         := NIL;
        SliderOnChanged             := NIL;
        SliderOnReleased            := NIL;
        SliderSetRange              := NIL;
        NewProgressBar              := NIL;
        ProgressBarValue            := NIL;
        ProgressBarSetValue         := NIL;
        NewHorizontalSeparator      := NIL;
        NewVerticalSeparator        := NIL;
        NewCombobox                 := NIL;
        ComboboxAppend              := NIL;
        ComboboxInsertAt            := NIL;
        ComboboxDelete              := NIL;
        ComboboxClear               := NIL;
        ComboboxNumItems            := NIL;
        ComboboxSelected            := NIL;
        ComboboxSetSelected         := NIL;
        ComboboxOnSelected          := NIL;
        NewEditableCombobox         := NIL;
        EditableComboboxAppend      := NIL;
        EditableComboboxText        := NIL;
        EditableComboboxSetText     := NIL;
        EditableComboboxOnChanged   := NIL;
        NewRadioButtons             := NIL;
        RadioButtonsAppend          := NIL;
        RadioButtonsSelected        := NIL;
        RadioButtonsSetSelected     := NIL;
        RadioButtonsOnSelected      := NIL;
        NewMultilineEntry               := NIL;
        NewNonWrappingMultilineEntry    := NIL;
        MultilineEntryText              := NIL;
        MultilineEntrySetText           := NIL;
        MultilineEntryAppend            := NIL;
        MultilineEntryOnChanged         := NIL;
        MultilineEntryReadOnly          := NIL;
        MultilineEntrySetReadOnly       := NIL;
        MenuItemEnable              := NIL;
        MenuItemDisable             := NIL;
        MenuItemOnClicked           := NIL;
        MenuItemChecked             := NIL;
        MenuItemSetChecked          := NIL;
        NewMenu                     := NIL;
        MenuAppendItem              := NIL;
        MenuAppendCheckItem         := NIL;
        MenuAppendQuitItem          := NIL;
        MenuAppendPreferencesItem   := NIL;
        MenuAppendAboutItem         := NIL;
        MenuAppendSeparator         := NIL;
        OpenFile                    := NIL;
        OpenFolder                  := NIL;
        SaveFile                    := NIL;
        MsgBox                      := NIL;
        MsgBoxError                 := NIL;
        NewArea                     := NIL;
        NewScrollingArea            := NIL;
        AreaSetSize                 := NIL;
        AreaQueueRedrawAll          := NIL;
        AreaScrollTo                := NIL;
        DrawNewPath                 := NIL;
        DrawFreePath                := NIL;
        DrawPathNewFigure           := NIL;
        DrawPathNewFigureWithArc    := NIL;
        DrawPathLineTo              := NIL;
        DrawPathArcTo               := NIL;
        DrawPathBezierTo            := NIL;
        DrawPathCloseFigure         := NIL;
        DrawPathAddRectangle        := NIL;
        DrawPathEnded               := NIL;
        DrawPathEnd                 := NIL;
        DrawMatrixSetIdentity       := NIL;
        DrawMatrixTranslate         := NIL;
        DrawMatrixScale             := NIL;
        DrawMatrixRotate            := NIL;
        DrawMatrixSkew              := NIL;
        DrawMatrixMultiply          := NIL;
        DrawMatrixInvertible        := NIL;
        DrawMatrixInvert            := NIL;
        DrawMatrixTransformPoint    := NIL;
        DrawMatrixTransformSize     := NIL;
        DrawSave                    := NIL;
        DrawRestore                 := NIL;
        DrawTransform               := NIL;
        DrawClip                    := NIL;
        DrawStroke                  := NIL;
        DrawFill                    := NIL;
        NewColorButton              := NIL;
        ColorButtonColor            := NIL;
        ColorButtonSetColor         := NIL;
        ColorButtonOnChanged        := NIL;
        NewForm                     := NIL;
        FormAppend                  := NIL;
        FormNumChildren             := NIL;
        FormDelete                  := NIL;
        FormPadded                  := NIL;
        FormSetPadded               := NIL;
        NewGrid                     := NIL;
        GridAppend                  := NIL;
        GridInsertAt                := NIL;
        GridPadded                  := NIL;
        GridSetPadded               := NIL;
        NewImage                    := NIL;
        FreeImage                   := NIL;
        ImageAppend                 := NIL;
        TableValueGetType           := NIL;
        NewTableValueString         := NIL;
        TableValueString            := NIL;
        NewTableValueImage          := NIL;
        TableValueImage             := NIL;
        NewTableValueInt            := NIL;
        TableValueInt               := NIL;
        NewTableValueColor          := NIL;
        TableValueColor             := NIL;
        NewTableModel               := NIL;
        FreeTableModel              := NIL;
        TableModelRowInserted       := NIL;
        TableModelRowChanged        := NIL;
        TableModelRowDeleted        := NIL;
        NewTable                        := NIL;
        TableAppendTextColumn           := NIL;
        TableAppendImageColumn          := NIL;
        TableAppendImageTextColumn      := NIL;
        TableAppendCheckboxColumn       := NIL;
        TableAppendCheckboxTextColumn   := NIL;
        TableAppendProgressBarColumn    := NIL;
        TableAppendButtonColumn         := NIL;
        TableHeaderVisible              := NIL;
        TableHeaderSetVisible           := NIL;
        TableOnRowClicked               := NIL;
        TableOnRowDoubleClicked         := NIL;
        TableHeaderSetSortIndicator     := NIL;
        TableHeaderSortIndicator        := NIL;
        TableHeaderOnClicked            := NIL;
        TableColumnWidth                := NIL;
        TableColumnSetWidth             := NIL;
        TableGetSelectionMode           := NIL;
        TableSetSelectionMode           := NIL;
        TableOnSelectionChanged         := NIL;
        TableGetSelection               := NIL;
        TableSetSelection               := NIL;
        FreeTableSelection              := NIL;
    END;

END Initialize;

BEGIN
    Initialize();
END UIDll.