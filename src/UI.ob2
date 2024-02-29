(**
This module is an object oriented wrapper to the cross platform
user interface library `libui-ng`.

Link https://github.com/libui-ng/libui-ng.

The module is mostly complete except for styled text handling which
is currently marked as experimental in the `C` code.

It is expected that changes are implemented as the library
is marked as `mid-alpha`. Despite this the library is quite
stable, atleast on the Windows platform.
*)
MODULE UI;

IMPORT SYSTEM, oberonRTS, UIDll, String, DateTime;

CONST
    ForEachContinue* 	            = UIDll.ForEachContinue;
    ForEachStop*                    = UIDll.ForEachStop;
    AlignFill*                      = UIDll.AlignFill;
	AlignStart*                     = UIDll.AlignStart;
	AlignCenter*                    = UIDll.AlignCenter;
	AlignEnd*                       = UIDll.AlignEnd;
    AtLeading*                      = UIDll.AtLeading;
	AtTop*                          = UIDll.AtTop;
	AtTrailing*                     = UIDll.AtTrailing;
	AtBottom*                       = UIDll.AtBottom;
    WindowResizeEdgeLeft*           = UIDll.WindowResizeEdgeLeft;
	WindowResizeEdgeTop*            = UIDll.WindowResizeEdgeTop;
	WindowResizeEdgeRight*          = UIDll.WindowResizeEdgeRight;
	WindowResizeEdgeBottom*         = UIDll.WindowResizeEdgeBottom;
	WindowResizeEdgeTopLeft*        = UIDll.WindowResizeEdgeTopLeft;
	WindowResizeEdgeTopRight*       = UIDll.WindowResizeEdgeTopRight;
	WindowResizeEdgeBottomLeft*     = UIDll.WindowResizeEdgeBottomLeft;
	WindowResizeEdgeBottomRight*    = UIDll.WindowResizeEdgeBottomRight;
    BrushTypeSolid*                 = UIDll.DrawBrushTypeSolid;
	BrushTypeLinearGradient*        = UIDll.DrawBrushTypeLinearGradient;
	BrushTypeRadialGradient*        = UIDll.DrawBrushTypeRadialGradient;
	BrushTypeImage*                 = UIDll.DrawBrushTypeImage;
    LineCapFlat*                    = UIDll.DrawLineCapFlat;
	LineCapRound*                   = UIDll.DrawLineCapRound;
	LineCapSquare*                  = UIDll.DrawLineCapSquare;
    LineJoinMiter*                  = UIDll.DrawLineJoinMiter;
	LineJoinRound*                  = UIDll.DrawLineJoinRound;
	LineJoinBevel*                  = UIDll.DrawLineJoinBevel;
    FillModeWinding*                = UIDll.DrawFillModeWinding;
	FillModeAlternate*              = UIDll.DrawFillModeAlternate;
    TableValueTypeString*           = UIDll.TableValueTypeString;
	TableValueTypeImage*            = UIDll.TableValueTypeImage;
	TableValueTypeInt*              = UIDll.TableValueTypeInt;
	TableValueTypeColor*            = UIDll.TableValueTypeColor;
    TableModelColumnNeverEditable*  = UIDll.TableModelColumnNeverEditable;
    TableModelColumnAlwaysEditable* = UIDll.TableModelColumnAlwaysEditable;
    TableSelectionModeNone*         = UIDll.TableSelectionModeNone;
    TableSelectionModeZeroOrOne*    = UIDll.TableSelectionModeZeroOrOne;
    TableSelectionModeOne*          = UIDll.TableSelectionModeOne;
    TableSelectionModeZeroOrMany*   = UIDll.TableSelectionModeZeroOrMany;
    SortIndicatorNone*              = UIDll.SortIndicatorNone;
	SortIndicatorAscending*         = UIDll.SortIndicatorAscending;
	SortIndicatorDescending*        = UIDll.SortIndicatorDescending;

TYPE
    MouseEvent*     = UIDll.AreaMouseEventPtr;
    KeyEvent*       = UIDll.AreaKeyEventPtr;

    App* = POINTER TO AppDesc;
    AppDesc* = RECORD opts- : UIDll.InitOptions END;
    Control* = POINTER TO ControlDesc;
    ControlDesc* = RECORD ptr- : UIDll.ADDRESS END;
    Window* = POINTER TO WindowDesc;
    WindowDesc* = RECORD(ControlDesc) END;
    Button* = POINTER TO ButtonDesc;
    ButtonDesc* = RECORD(ControlDesc) END;
    Box* = POINTER TO BoxDesc;
    BoxDesc* = RECORD(ControlDesc) END;
    Checkbox* = POINTER TO CheckboxDesc;
    CheckboxDesc* = RECORD(ControlDesc) END;
    Entry* = POINTER TO EntryDesc;
    EntryDesc* = RECORD(ControlDesc) END;
    Label* = POINTER TO LabelDesc;
    LabelDesc* = RECORD(ControlDesc) END;
    Tab* = POINTER TO TabDesc;
    TabDesc* = RECORD(ControlDesc) END;
    Group* = POINTER TO GroupDesc;
    GroupDesc* = RECORD(ControlDesc) END;
    Spinbox* = POINTER TO SpinboxDesc;
    SpinboxDesc* = RECORD(ControlDesc) END;
    Slider* = POINTER TO SliderDesc;
    SliderDesc* = RECORD(ControlDesc) END;
    ProgressBar* = POINTER TO ProgressBarDesc;
    ProgressBarDesc* = RECORD(ControlDesc) END;
    Separator* = POINTER TO SeparatorDesc;
    SeparatorDesc* = RECORD(ControlDesc) END;
    Combobox* = POINTER TO ComboboxDesc;
    ComboboxDesc* = RECORD(ControlDesc) END;
    EditableCombobox* = POINTER TO EditableComboboxDesc;
    EditableComboboxDesc* = RECORD(ControlDesc) END;
    RadioButtons* = POINTER TO RadioButtonsDesc;
    RadioButtonsDesc* = RECORD(ControlDesc) END;
    DateTimePicker* = POINTER TO DateTimePickerDesc;
    DateTimePickerDesc* = RECORD(ControlDesc) END;
    MultilineEntry* = POINTER TO MultilineEntryDesc;
    MultilineEntryDesc* = RECORD(ControlDesc) END;
    MenuItem* = POINTER TO MenuItemDesc;
    MenuItemDesc* = RECORD(ControlDesc) END;
    Menu* = POINTER TO MenuDesc;
    MenuDesc* = RECORD(ControlDesc) END;
    DrawContext* = POINTER TO DrawContextDesc;
    DrawContextDesc* = RECORD
        ptr- : UIDll.ADDRESS;
        AreaWidth*      : LONGREAL;
        AreaHeight*     : LONGREAL;
        ClipX*          : LONGREAL;
        ClipY*          : LONGREAL;
        ClipWidth*      : LONGREAL;
        ClipHeight*     : LONGREAL;
    END;
    Area* = POINTER TO AreaDesc;
    AreaDesc* = RECORD(ControlDesc)
        ah : UIDll.AreaHandler;
    END;
    Path* = POINTER TO PathDesc;
    PathDesc* = RECORD ptr- : UIDll.ADDRESS END;
    Brush* = UIDll.DrawBrush;
    Stroke* = UIDll.DrawStrokeParams;
    Matrix* = RECORD m* : UIDll.DrawMatrix END;
    ColorButton* = POINTER TO ColorButtonDesc;
    ColorButtonDesc* = RECORD(ControlDesc) END;
    Form* = POINTER TO FormDesc;
    FormDesc* = RECORD(ControlDesc) END;
    Grid* = POINTER TO GridDesc;
    GridDesc* = RECORD(ControlDesc) END;
    Image* = POINTER TO ImageDesc;
    ImageDesc* = RECORD ptr- : UIDll.ADDRESS END;
    TableValue* = POINTER TO TableValueDesc;
    TableValueDesc* = RECORD ptr- : UIDll.ADDRESS END;
    TableModel* = POINTER TO TableModelDesc;
    TableModelDesc* = RECORD
        ptr- : UIDll.ADDRESS;
        mh : UIDll.TableModelHandler;
    END;
    Table* = POINTER TO TableDesc;
    TableDesc* = RECORD (ControlDesc)
        tp : UIDll.TableParams;
    END;
--
-- Procedures
--

(** Signal Quit to application *)
PROCEDURE Quit*();
BEGIN UIDll.Quit() END Quit;

(** File chooser dialog window to select a single file. *)
PROCEDURE OpenFile*(parent : Window): String.STRING;
    VAR
        str : UIDll.PCHAR;
        ret : String.STRING;
BEGIN
    str := UIDll.OpenFile(parent.ptr);
    IF str = NIL THEN
        RETURN NIL
    END;
    UIDll.CopyText(ret, str);
    RETURN ret
END OpenFile;

(** Folder chooser dialog window to select a single folder. *)
PROCEDURE OpenFolder*(parent : Window): String.STRING;
    VAR
        str : UIDll.PCHAR;
        ret : String.STRING;
BEGIN
    str := UIDll.OpenFolder(parent.ptr);
    IF str = NIL THEN
        RETURN NIL
    END;
    UIDll.CopyText(ret, str);
    RETURN ret
END OpenFolder;

(** Save file dialog window. *)
PROCEDURE SaveFile*(parent : Window): String.STRING;
    VAR
        str : UIDll.PCHAR;
        ret : String.STRING;
BEGIN
    str := UIDll.SaveFile(parent.ptr);
    IF str = NIL THEN
        RETURN NIL
    END;
    UIDll.CopyText(ret, str);
    RETURN ret
END SaveFile;

(** Message box dialog window. *)
PROCEDURE MsgBox*(parent : Window; title- : ARRAY OF CHAR; description- : ARRAY OF CHAR);
BEGIN
    UIDll.MsgBox(parent.ptr, title, description);
END MsgBox;

(** Message box dialog window. *)
PROCEDURE MsgBoxError*(parent : Window; title- : ARRAY OF CHAR; description- : ARRAY OF CHAR);
BEGIN
    UIDll.MsgBoxError(parent.ptr, title, description);
END MsgBoxError;

--
-- App
--

(** Start main loop *)
PROCEDURE (this : App) Main*();
BEGIN UIDll.Main()
END Main;

(** Deallocate resources *)
PROCEDURE (this : App) Destroy*();
BEGIN
    IF this.opts # NIL THEN
        UIDll.Uninit();
        this.opts := NIL;
    END;
END Destroy;

PROCEDURE Finalize(adr : SYSTEM.ADDRESS);
    VAR this : App;
BEGIN 
    this := SYSTEM.VAL(App, adr);
    this.Destroy()
END Finalize;

(** Initialize App *)
PROCEDURE InitApp*(a : App);
    VAR  err : UIDll.PCHAR;
BEGIN
    IF a.opts # NIL THEN RETURN END;
    NEW(a.opts);
    a.opts.size := 0;
    err := UIDll.Init(a.opts);
    IF err # NIL THEN
        UIDll.FreeInitError(err);
        RETURN
    END;
    oberonRTS.InstallFinalizer(Finalize, a);
END InitApp;

--
-- Control base class
--

(** Dispose Control and all allocated resources *)
PROCEDURE (this : Control) Destroy*();
BEGIN UIDll.ControlDestroy(this.ptr);
END Destroy;

(** Returns TRUE if control is a top level control.*)
PROCEDURE (this : Control) IsTopLevel*(): BOOLEAN;
BEGIN RETURN UIDll.ControlToplevel(this.ptr) # 0;
END IsTopLevel;

(** Returns TRUE if control is visible *)
PROCEDURE (this : Control) IsVisible*(): BOOLEAN;
BEGIN RETURN UIDll.ControlVisible(this.ptr) # 0;
END IsVisible;

(** Shows the control *)
PROCEDURE (this : Control) Show*();
BEGIN UIDll.ControlShow(this.ptr);
END Show;

(** Hides the control *)
PROCEDURE (this : Control) Hide*();
BEGIN UIDll.ControlHide(this.ptr);
END Hide;

(** Returns TRUE if the control is enabled *)
PROCEDURE (this : Control) IsEnabled*(): BOOLEAN;
BEGIN RETURN UIDll.ControlEnabled(this.ptr) # 0;
END IsEnabled;

(** Enable control *)
PROCEDURE (this : Control) Enable*();
BEGIN UIDll.ControlEnable(this.ptr);
END Enable;

(** Disable control *)
PROCEDURE (this : Control) Disable*();
BEGIN UIDll.ControlDisable(this.ptr);
END Disable;

--
-- Window
--

(** Returns Window title *)
PROCEDURE (this : Window) Title*(): String.STRING;
    VAR
        str : UIDll.PCHAR;
        ret : String.STRING;
BEGIN
    str := UIDll.WindowTitle(this.ptr);
    UIDll.CopyText(ret, str);
    RETURN ret
END Title;

(** Set Window title *)
PROCEDURE (this : Window) SetTitle*(title- : ARRAY OF CHAR);
BEGIN UIDll.WindowSetTitle(this.ptr, title);
END SetTitle;

(** Get Window position *)
PROCEDURE (this : Window) Position*(VAR x : LONGINT; VAR y : LONGINT);
BEGIN UIDll.WindowPosition(this.ptr, x, y);
END Position;

(** Set Window position *)
PROCEDURE (this : Window) SetPosition*(x, y : LONGINT);
BEGIN UIDll.WindowSetPosition(this.ptr, x, y);
END SetPosition;

(** On position change callback.*)
PROCEDURE (this : Window) OnPositionChanged*();
BEGIN END OnPositionChanged;

PROCEDURE ["C"] WindowOnPositionChanged(sender : UIDll.Window; senderData : UIDll.VOID);
    VAR this : Window;
BEGIN
    this := SYSTEM.VAL(Window, senderData);
    this.OnPositionChanged()
END WindowOnPositionChanged;

(** Get Window content size *)
PROCEDURE (this : Window) ContentSize*(VAR width : LONGINT; VAR height : LONGINT);
BEGIN UIDll.WindowContentSize(this.ptr, width, height);
END ContentSize;

(** Set Window content size *)
PROCEDURE (this : Window) SetContentSize*(width, height : LONGINT);
BEGIN UIDll.WindowSetContentSize(this.ptr, width, height);
END SetContentSize;

(** Returns TRUE if the control is fullscreen *)
PROCEDURE (this : Window) IsFullScreen*(): BOOLEAN;
BEGIN RETURN UIDll.WindowFullscreen(this.ptr) # 0;
END IsFullScreen;

(** Set Window fullscreen *)
PROCEDURE (this : Window) SetFullscreen*(fullscreen : BOOLEAN);
BEGIN UIDll.WindowSetFullscreen(this.ptr, ORD(fullscreen));
END SetFullscreen;

(** On content size change callback.*)
PROCEDURE (this : Window) OnContentSizeChanged*();
BEGIN END OnContentSizeChanged;

PROCEDURE ["C"] WindowOnContentSizeChanged(sender : UIDll.Window; senderData : UIDll.VOID);
    VAR this : Window;
BEGIN
    this := SYSTEM.VAL(Window, senderData);
    this.OnContentSizeChanged()
END WindowOnContentSizeChanged;

(** On close callback.*)
PROCEDURE (this : Window) OnClosing*(): BOOLEAN;
BEGIN
    Quit();
    RETURN TRUE
END OnClosing;

PROCEDURE ["C"] WindowOnClosing(sender : UIDll.Window; senderData : UIDll.VOID): UIDll.INT;
    VAR this : Window;
BEGIN
    this := SYSTEM.VAL(Window, senderData);
    RETURN ORD(this.OnClosing())
END WindowOnClosing;

(** On focus change callback.*)
PROCEDURE (this : Window) OnFocusChanged*();
BEGIN END OnFocusChanged;

PROCEDURE ["C"] WindowOnFocusChanged(sender : UIDll.Window; senderData : UIDll.VOID);
    VAR this : Window;
BEGIN
    this := SYSTEM.VAL(Window, senderData);
    this.OnFocusChanged()
END WindowOnFocusChanged;

(** Returns TRUE if the control has focus *)
PROCEDURE (this : Window) IsFocused*(): BOOLEAN;
BEGIN RETURN UIDll.WindowFocused(this.ptr) # 0;
END IsFocused;

(** Returns TRUE if the control is borderless *)
PROCEDURE (this : Window) IsBorderless*(): BOOLEAN;
BEGIN RETURN UIDll.WindowBorderless(this.ptr) # 0;
END IsBorderless;

(** Set Window bordless flag *)
PROCEDURE (this : Window) SetBorderless*(borderless : BOOLEAN);
BEGIN UIDll.WindowSetBorderless(this.ptr, ORD(borderless));
END SetBorderless;

(** Set child control *)
PROCEDURE (this : Window) SetChild*(child : Control);
BEGIN
    UIDll.WindowSetChild(this.ptr, child.ptr);
END SetChild;

(** Returns TRUE if the control is margined *)
PROCEDURE (this : Window) IsMargined*(): BOOLEAN;
BEGIN RETURN UIDll.WindowMargined(this.ptr) # 0;
END IsMargined;

(** Set Window margined flag *)
PROCEDURE (this : Window) SetMargined*(margined : BOOLEAN);
BEGIN UIDll.WindowSetMargined(this.ptr, ORD(margined));
END SetMargined;

(** Returns TRUE if the control is resizeable *)
PROCEDURE (this : Window) IsResizeable*(): BOOLEAN;
BEGIN RETURN UIDll.WindowResizeable(this.ptr) # 0;
END IsResizeable;

(** Set Window resizeable flag *)
PROCEDURE (this : Window) SetResizeable*(resizeable : BOOLEAN);
BEGIN UIDll.WindowSetResizeable(this.ptr, ORD(resizeable));
END SetResizeable;

(** Initialize Window *)
PROCEDURE InitWindow*(w : Window; title- : ARRAY OF CHAR; width, height : LONGINT; hasMenubar : BOOLEAN);
BEGIN
    IF w.ptr # NIL THEN RETURN END;
    w.ptr := UIDll.NewWindow(title, width, height, ORD(hasMenubar));
    IF w.ptr = NIL THEN RETURN END;
    UIDll.WindowOnClosing(w.ptr, WindowOnClosing, w);
    UIDll.WindowOnPositionChanged(w.ptr, WindowOnPositionChanged, w);
    UIDll.WindowOnContentSizeChanged(w.ptr, WindowOnContentSizeChanged, w);
    UIDll.WindowOnFocusChanged(w.ptr, WindowOnFocusChanged, w);
END InitWindow;

--
-- Button
--

(** Returns Button text *)
PROCEDURE (this : Button) Text*(): String.STRING;
    VAR
        str : UIDll.PCHAR;
        ret : String.STRING;
BEGIN
    str := UIDll.ButtonText(this.ptr);
    UIDll.CopyText(ret, str);
    RETURN ret
END Text;

(** Set Button text *)
PROCEDURE (this : Button) SetText*(text- : ARRAY OF CHAR);
BEGIN UIDll.ButtonSetText(this.ptr, text);
END SetText;

(** Button click callback *)
PROCEDURE (this : Button) OnClicked*();
BEGIN END OnClicked;

PROCEDURE ["C"] ButtonOnClicked(sender : UIDll.Control; senderData : UIDll.VOID);
    VAR this : Button;
BEGIN
    this := SYSTEM.VAL(Button, senderData);
    this.OnClicked()
END ButtonOnClicked;

(** Initialize Button *)
PROCEDURE InitButton*(b : Button; text- : ARRAY OF CHAR);
BEGIN
    IF b.ptr # NIL THEN RETURN END;
    b.ptr := UIDll.NewButton(text);
    IF b.ptr = NIL THEN RETURN END;
    UIDll.ButtonOnClicked(b.ptr, ButtonOnClicked, b);
END InitButton;

--
-- Box
--

(**
Append control to Box.
If stretchy is TRUE the Control expand to the remaining space.
If multiple strechy Controls exists the space is equally shared.
*)
PROCEDURE (this : Box) Append*(child : Control; stretchy : BOOLEAN);
BEGIN
    UIDll.BoxAppend(this.ptr, child.ptr, ORD(stretchy));
END Append;

(** Returns the number of controls contained within the box. *)
PROCEDURE (this : Box) NumChildren*():LONGINT;
BEGIN
    RETURN UIDll.BoxNumChildren(this.ptr)
END NumChildren;

(** Removes the Control at index *)
PROCEDURE (this : Box) Delete*(index : LONGINT);
BEGIN
    UIDll.BoxDelete(this.ptr, index);
END Delete;

(** Returns TRUE if the Box is padded *)
PROCEDURE (this : Box) IsPadded*(): BOOLEAN;
BEGIN RETURN UIDll.BoxPadded(this.ptr) # 0;
END IsPadded;

(** Set Box padded flag *)
PROCEDURE (this : Box) SetPadded*(padded : BOOLEAN);
BEGIN UIDll.BoxSetPadded(this.ptr, ORD(padded));
END SetPadded;

(** Initialize vertical Box *)
PROCEDURE InitVerticalBox*(b : Box);
BEGIN
    IF b.ptr # NIL THEN RETURN END;
    b.ptr := UIDll.NewVerticalBox();
END InitVerticalBox;

(** Initialize horizontal Box *)
PROCEDURE InitHorizontalBox*(b : Box);
BEGIN
    IF b.ptr # NIL THEN RETURN END;
    b.ptr := UIDll.NewHorizontalBox();
END InitHorizontalBox;

--
-- Checkbox
--

(** Returns Checkbox text *)
PROCEDURE (this : Checkbox) Text*(): String.STRING;
    VAR
        str : UIDll.PCHAR;
        ret : String.STRING;
BEGIN
    str := UIDll.CheckboxText(this.ptr);
    UIDll.CopyText(ret, str);
    RETURN ret
END Text;

(** Set Checkbox text *)
PROCEDURE (this : Checkbox) SetText*(text- : ARRAY OF CHAR);
BEGIN UIDll.CheckboxSetText(this.ptr, text);
END SetText;

(** Checkbox toggled callback *)
PROCEDURE (this : Checkbox) OnToggled*();
BEGIN END OnToggled;

PROCEDURE ["C"] CheckboxOnToggled(sender : UIDll.Control; senderData : UIDll.VOID);
    VAR this : Checkbox;
BEGIN
    this := SYSTEM.VAL(Checkbox, senderData);
    this.OnToggled()
END CheckboxOnToggled;

(** Returns TRUE if the Checkbox is checked *)
PROCEDURE (this : Checkbox) IsChecked*(): BOOLEAN;
BEGIN RETURN UIDll.CheckboxChecked(this.ptr) # 0;
END IsChecked;

(** Set Checkbox checked flag *)
PROCEDURE (this : Checkbox) SetChecked*(checked : BOOLEAN);
BEGIN UIDll.CheckboxSetChecked(this.ptr, ORD(checked));
END SetChecked;

(** Initialize Checkbox *)
PROCEDURE InitCheckbox*(c : Checkbox; text- : ARRAY OF CHAR);
BEGIN
    IF c.ptr # NIL THEN RETURN END;
    c.ptr := UIDll.NewCheckbox(text);
    UIDll.CheckboxOnToggled(c.ptr, CheckboxOnToggled, c);
END InitCheckbox;

--
-- Entry
--

(** Returns Entry text *)
PROCEDURE (this : Entry) Text*(): String.STRING;
    VAR
        str : UIDll.PCHAR;
        ret : String.STRING;
BEGIN
    str := UIDll.EntryText(this.ptr);
    UIDll.CopyText(ret, str);
    RETURN ret
END Text;

(** Set Entry text *)
PROCEDURE (this : Entry) SetText*(text- : ARRAY OF CHAR);
BEGIN UIDll.EntrySetText(this.ptr, text);
END SetText;

(** Entry change callback *)
PROCEDURE (this : Entry) OnChanged*();
BEGIN END OnChanged;

PROCEDURE ["C"] EntryOnChanged(sender : UIDll.Control; senderData : UIDll.VOID);
    VAR this : Entry;
BEGIN
    this := SYSTEM.VAL(Entry, senderData);
    this.OnChanged()
END EntryOnChanged;

(** Returns TRUE if the Entry is readonly *)
PROCEDURE (this : Entry) IsReadOnly*(): BOOLEAN;
BEGIN RETURN UIDll.EntryReadOnly(this.ptr) # 0;
END IsReadOnly;

(** Set Entry readonly flag *)
PROCEDURE (this : Entry) SetReadOnly*(readonly : BOOLEAN);
BEGIN UIDll.EntrySetReadOnly(this.ptr, ORD(readonly));
END SetReadOnly;

(** Initialize Entry *)
PROCEDURE InitEntry*(e : Entry);
BEGIN
    IF e.ptr # NIL THEN RETURN END;
    e.ptr := UIDll.NewEntry();
    UIDll.EntryOnChanged(e.ptr, EntryOnChanged, e);
END InitEntry;

(** Initialize password Entry *)
PROCEDURE InitPasswordEntry*(e : Entry);
BEGIN
    IF e.ptr # NIL THEN RETURN END;
    e.ptr := UIDll.NewPasswordEntry();
    UIDll.EntryOnChanged(e.ptr, EntryOnChanged, e);
END InitPasswordEntry;

(** Initialize search Entry *)
PROCEDURE InitSearchEntry*(e : Entry);
BEGIN
    IF e.ptr # NIL THEN RETURN END;
    e.ptr := UIDll.NewSearchEntry();
    UIDll.EntryOnChanged(e.ptr, EntryOnChanged, e);
END InitSearchEntry;

--
-- Label
--

(** Returns Label text *)
PROCEDURE (this : Label) Text*(): String.STRING;
    VAR
        str : UIDll.PCHAR;
        ret : String.STRING;
BEGIN
    str := UIDll.LabelText(this.ptr);
    UIDll.CopyText(ret, str);
    RETURN ret
END Text;

(** Set Label text *)
PROCEDURE (this : Label) SetText*(text- : ARRAY OF CHAR);
BEGIN UIDll.LabelSetText(this.ptr, text);
END SetText;

(** Initialize Label *)
PROCEDURE InitLabel*(l : Label; text- : ARRAY OF CHAR);
BEGIN
    IF l.ptr # NIL THEN RETURN END;
    l.ptr := UIDll.NewLabel(text);
END InitLabel;

--
-- Tab
--

(** Appends a control in form of a page/tab with label. *)
PROCEDURE (this : Tab) Append*(name- : ARRAY OF CHAR; control : Control);
BEGIN
    UIDll.TabAppend(this.ptr, name, control.ptr);
END Append;

(** Inserts a control in form of a page/tab with label at index. *)
PROCEDURE (this : Tab) InsertAt*(name- : ARRAY OF CHAR; index : LONGINT; control : Control);
BEGIN
    UIDll.TabInsertAt(this.ptr, name, index, control.ptr);
END InsertAt;

(** Removes the control at index. *)
PROCEDURE (this : Tab) Delete*(index : LONGINT);
BEGIN UIDll.TabDelete(this.ptr, index);
END Delete;

(** Returns the number of pages contained. *)
PROCEDURE (this : Tab) NumPages*(): LONGINT;
BEGIN RETURN UIDll.TabNumPages(this.ptr)
END NumPages;

(** Returns whether or not the page/tab at index has a margin. *)
PROCEDURE (this : Tab) IsMargined*(index : LONGINT): BOOLEAN;
BEGIN RETURN UIDll.TabMargined(this.ptr, index) # 0;
END IsMargined;

(** Sets whether or not the page/tab at index has a margin. *)
PROCEDURE (this : Tab) SetMargined*(index : LONGINT; margined : BOOLEAN);
BEGIN UIDll.TabSetMargined(this.ptr, index, ORD(margined));
END SetMargined;

(** Initialize Tab *)
PROCEDURE InitTab*(t : Tab);
BEGIN
    IF t.ptr # NIL THEN RETURN END;
    t.ptr := UIDll.NewTab();
END InitTab;

--
-- Group
--

(** Returns Group title *)
PROCEDURE (this : Group) Title*(): String.STRING;
    VAR
        str : UIDll.PCHAR;
        ret : String.STRING;
BEGIN
    str := UIDll.GroupTitle(this.ptr);
    UIDll.CopyText(ret, str);
    RETURN ret
END Title;

(** Set Group title *)
PROCEDURE (this : Label) SetTitle*(title- : ARRAY OF CHAR);
BEGIN UIDll.GroupSetTitle(this.ptr, title);
END SetTitle;

(** Set child control *)
PROCEDURE (this : Label) SetChild*(control : Control);
BEGIN
    UIDll.GroupSetChild(this.ptr, control.ptr);
END SetChild;

(** Returns TRUE if the control is margined *)
PROCEDURE (this : Label) IsMargined*(): BOOLEAN;
BEGIN RETURN UIDll.GroupMargined(this.ptr) # 0;
END IsMargined;

(** Set Window margined flag *)
PROCEDURE (this : Label) SetMargined*(margined : BOOLEAN);
BEGIN UIDll.GroupSetMargined(this.ptr, ORD(margined));
END SetMargined;

--
-- Spinbox
--

(** Returns the Spinbox value. *)
PROCEDURE (this : Spinbox) Value*():LONGINT;
BEGIN
    RETURN UIDll.SpinboxValue(this.ptr)
END Value;

(** Sets the spinbox value. *)
PROCEDURE (this : Spinbox) SetValue*(value : LONGINT);
BEGIN
    UIDll.SpinboxSetValue(this.ptr, value)
END SetValue;

(** Entry change callback *)
PROCEDURE (this : Spinbox) OnChanged*();
BEGIN END OnChanged;

PROCEDURE ["C"] SpinboxOnChanged(sender : UIDll.Control; senderData : UIDll.VOID);
    VAR this : Spinbox;
BEGIN
    this := SYSTEM.VAL(Spinbox, senderData);
    this.OnChanged()
END SpinboxOnChanged;

(** Initialize Spinbox *)
PROCEDURE InitSpinbox*(s : Spinbox; min, max : LONGINT);
BEGIN
    ASSERT((min >= 0) & (max >= 0) & (max > min));
    IF s.ptr # NIL THEN RETURN END;
    s.ptr := UIDll.NewSpinbox(min, max);
    UIDll.SpinboxOnChanged(s.ptr, SpinboxOnChanged, s);
END InitSpinbox;

--
-- Slider
--

(** Returns the Slider value. *)
PROCEDURE (this : Slider) Value*():LONGINT;
BEGIN
    RETURN UIDll.SliderValue(this.ptr)
END Value;

(** Sets the Slider value. *)
PROCEDURE (this : Slider) SetValue*(value : LONGINT);
BEGIN
    UIDll.SliderSetValue(this.ptr, value)
END SetValue;

(** Returns whether or not the slider has a tool tip. *)
PROCEDURE (this : Slider) HasToolTip*(): BOOLEAN;
BEGIN RETURN UIDll.SliderHasToolTip(this.ptr) # 0;
END HasToolTip;

(** Sets whether or not the slider has a tool tip. *)
PROCEDURE (this : Slider) SetHasToolTip*(hasToolTip : BOOLEAN);
BEGIN UIDll.SliderSetHasToolTip(this.ptr, ORD(hasToolTip));
END SetHasToolTip;

(** Entry change callback *)
PROCEDURE (this : Slider) OnChanged*();
BEGIN END OnChanged;

PROCEDURE ["C"] SliderOnChanged(sender : UIDll.Control; senderData : UIDll.VOID);
    VAR this : Slider;
BEGIN
    this := SYSTEM.VAL(Slider, senderData);
    this.OnChanged()
END SliderOnChanged;

(** Callback for when the slider is released from dragging. *)
PROCEDURE (this : Slider) OnReleased*();
BEGIN END OnReleased;

PROCEDURE ["C"] SliderOnReleased(sender : UIDll.Control; senderData : UIDll.VOID);
    VAR this : Slider;
BEGIN
    this := SYSTEM.VAL(Slider, senderData);
    this.OnReleased()
END SliderOnReleased;

(** Sets the slider range. *)
PROCEDURE (this : Slider) SetRange*(min, max : LONGINT);
BEGIN
    ASSERT((min >= 0) & (max >= 0) & (max > min));
    UIDll.SliderSetRange(this.ptr, min, max)
END SetRange;

(** Initialize Slider *)
PROCEDURE InitSlider*(s : Slider; min, max : LONGINT);
BEGIN
    ASSERT((min >= 0) & (max >= 0) & (max > min));
    IF s.ptr # NIL THEN RETURN END;
    s.ptr := UIDll.NewSlider(min, max);
    UIDll.SliderOnChanged(s.ptr, SliderOnChanged, s);
    UIDll.SliderOnReleased(s.ptr, SliderOnReleased, s);
END InitSlider;

--
-- ProgressBar
--

(** Returns the ProgressBar value. *)
PROCEDURE (this : ProgressBar) Value*():LONGINT;
BEGIN
    RETURN UIDll.ProgressBarValue(this.ptr)
END Value;

(** Sets the ProgressBar value. *)
PROCEDURE (this : ProgressBar) SetValue*(value : LONGINT);
BEGIN
    UIDll.ProgressBarSetValue(this.ptr, value)
END SetValue;

(** Initialize ProgressBar *)
PROCEDURE InitProgressBar*(p : ProgressBar);
BEGIN
    IF p.ptr # NIL THEN RETURN END;
    p.ptr := UIDll.NewProgressBar();
END InitProgressBar;

--
-- Separator
--

(** Initialize horizontal separator. *)
PROCEDURE InitHorizontalSeparator*(s : Separator);
BEGIN
    IF s.ptr # NIL THEN RETURN END;
    s.ptr := UIDll.NewHorizontalSeparator();
END InitHorizontalSeparator;

(** Initialize vertical separator. *)
PROCEDURE InitVerticalSeparator*(s : Separator);
BEGIN
    IF s.ptr # NIL THEN RETURN END;
    s.ptr := UIDll.NewVerticalSeparator();
END InitVerticalSeparator;

--
-- Combobox
--

(** Appends an item to the combo box. *)
PROCEDURE (this : Combobox) Append*(text- : ARRAY OF CHAR);
BEGIN
    UIDll.ComboboxAppend(this.ptr, text);
END Append;

(** Inserts an item at index to the combo box. *)
PROCEDURE (this : Combobox) InsertAt*(index : LONGINT; text- : ARRAY OF CHAR);
BEGIN
    UIDll.ComboboxInsertAt(this.ptr, index, text);
END InsertAt;

(** Deletes an item at index from the combo box. *)
PROCEDURE (this : Combobox) Delete*(index : LONGINT);
BEGIN
    UIDll.ComboboxDelete(this.ptr, index);
END Delete;

(** Deletes all items from the combo box. *)
PROCEDURE (this : Combobox) Clear*;
BEGIN
    UIDll.ComboboxClear(this.ptr);
END Clear;

(** Returns the number of items contained within the combo box. *)
PROCEDURE (this : Combobox) NumItems*():LONGINT;
BEGIN
    RETURN UIDll.ComboboxNumItems(this.ptr)
END NumItems;

(** Returns the index of the item selected. *)
PROCEDURE (this : Combobox) Selected*():LONGINT;
BEGIN
    RETURN UIDll.ComboboxSelected(this.ptr)
END Selected;

(** Sets the item selected. *)
PROCEDURE (this : Combobox) SetSelected*(index : LONGINT);
BEGIN
    UIDll.ComboboxSetSelected(this.ptr, index)
END SetSelected;

(** Selected item callback *)
PROCEDURE (this : Combobox) OnSelected*();
BEGIN END OnSelected;

PROCEDURE ["C"] ComboboxOnSelected(sender : UIDll.Control; senderData : UIDll.VOID);
    VAR this : Combobox;
BEGIN
    this := SYSTEM.VAL(Combobox, senderData);
    this.OnSelected()
END ComboboxOnSelected;

(** Initialize Combobox *)
PROCEDURE InitCombobox*(c : Combobox);
BEGIN
    IF c.ptr # NIL THEN RETURN END;
    c.ptr := UIDll.NewCombobox();
    UIDll.ComboboxOnSelected(c.ptr, ComboboxOnSelected, c);
END InitCombobox;

--
-- EditableCombobox
--

(** Appends an item to the editable combo box. *)
PROCEDURE (this : EditableCombobox) Append*(text- : ARRAY OF CHAR);
BEGIN
    UIDll.EditableComboboxAppend(this.ptr, text);
END Append;

(** Returns the text of the editable combo box. *)
PROCEDURE (this : EditableCombobox) Text*(): String.STRING;
    VAR
        str : UIDll.PCHAR;
        ret : String.STRING;
BEGIN
    str := UIDll.EditableComboboxText(this.ptr);
    UIDll.CopyText(ret, str);
    RETURN ret
END Text;

(** Sets the editable combo box text. *)
PROCEDURE (this : EditableCombobox) SetText*(text- : ARRAY OF CHAR);
BEGIN UIDll.EditableComboboxSetText(this.ptr, text);
END SetText;

(** Editable combo box change callback *)
PROCEDURE (this : EditableCombobox) OnChanged*();
BEGIN END OnChanged;

PROCEDURE ["C"] EditableComboboxOnChanged(sender : UIDll.Control; senderData : UIDll.VOID);
    VAR this : EditableCombobox;
BEGIN
    this := SYSTEM.VAL(EditableCombobox, senderData);
    this.OnChanged()
END EditableComboboxOnChanged;

(** Initialize Combobox *)
PROCEDURE InitEditableCombobox*(c : EditableCombobox);
BEGIN
    IF c.ptr # NIL THEN RETURN END;
    c.ptr := UIDll.NewEditableCombobox();
    UIDll.EditableComboboxOnChanged(c.ptr, EditableComboboxOnChanged, c);
END InitEditableCombobox;

--
-- RadioButtons
--

(** Appends a radio button. *)
PROCEDURE (this : RadioButtons) Append*(text- : ARRAY OF CHAR);
BEGIN
    UIDll.RadioButtonsAppend(this.ptr, text);
END Append;

(** Returns the index of the item selected. *)
PROCEDURE (this : RadioButtons) Selected*():LONGINT;
BEGIN
    RETURN UIDll.RadioButtonsSelected(this.ptr)
END Selected;

(** Sets the item selected. *)
PROCEDURE (this : RadioButtons) SetSelected*(index : LONGINT);
BEGIN
    UIDll.RadioButtonsSetSelected(this.ptr, index)
END SetSelected;

(** Selected item callback *)
PROCEDURE (this : RadioButtons) OnSelected*();
BEGIN END OnSelected;

PROCEDURE ["C"] RadioButtonsOnSelected(sender : UIDll.Control; senderData : UIDll.VOID);
    VAR this : RadioButtons;
BEGIN
    this := SYSTEM.VAL(RadioButtons, senderData);
    this.OnSelected()
END RadioButtonsOnSelected;

(** Initialize RadioButtons *)
PROCEDURE InitRadioButtons*(r : RadioButtons);
BEGIN
    IF r.ptr # NIL THEN RETURN END;
    r.ptr := UIDll.NewRadioButtons();
    UIDll.RadioButtonsOnSelected(r.ptr, RadioButtonsOnSelected, r);
END InitRadioButtons;

--
-- DateTimePicker
--

(** Returns date and time stored in the data time picker. *)
PROCEDURE (this : DateTimePicker) Time*():DateTime.DATETIME;
    VAR tm : UIDll.TM;
BEGIN
    UIDll.DateTimePickerTime(this.ptr, tm);
    RETURN DateTime.EncodeDateTime(tm.tm_year, tm.tm_mon, tm.tm_yday, tm.tm_hour, tm.tm_min, tm.tm_sec, 0);
END Time;

(** Sets date and time of the data time picker. *)
PROCEDURE (this : DateTimePicker) SetTime*(time : DateTime.DATETIME);
    VAR
        tm : UIDll.TM;
        year, month, day, hour, min, sec, msec: LONGINT;
BEGIN
    DateTime.DecodeDateTime(year, month, day, hour, min, sec, msec, time);
    tm.tm_year  := year;
    tm.tm_mon   := month;
    tm.tm_yday  := day;
    tm.tm_hour  := hour;
    tm.tm_min   := min;
    tm.tm_sec   := sec;
    tm.tm_isdst := -1;
    UIDll.DateTimePickerSetTime(this.ptr, tm);
END SetTime;

(** DateTimePicker change callback *)
PROCEDURE (this : DateTimePicker) OnChanged*();
BEGIN END OnChanged;

PROCEDURE ["C"] DateTimePickerOnChanged(sender : UIDll.Control; senderData : UIDll.VOID);
    VAR this : DateTimePicker;
BEGIN
    this := SYSTEM.VAL(DateTimePicker, senderData);
    this.OnChanged()
END DateTimePickerOnChanged;

(** Initialize a new date picker. *)
PROCEDURE InitDatePicker*(d : DateTimePicker);
BEGIN
    IF d.ptr # NIL THEN RETURN END;
    d.ptr := UIDll.NewDatePicker();
    UIDll.DateTimePickerOnChanged(d.ptr, DateTimePickerOnChanged, d);
END InitDatePicker;

(** Initialize a new time picker. *)
PROCEDURE InitTimePicker*(d : DateTimePicker);
BEGIN
    IF d.ptr # NIL THEN RETURN END;
    d.ptr := UIDll.NewTimePicker();
    UIDll.DateTimePickerOnChanged(d.ptr, DateTimePickerOnChanged, d);
END InitTimePicker;

(** Initialize a new date picker. *)
PROCEDURE InitDateTimePicker*(d : DateTimePicker);
BEGIN
    IF d.ptr # NIL THEN RETURN END;
    d.ptr := UIDll.NewDateTimePicker();
    UIDll.DateTimePickerOnChanged(d.ptr, DateTimePickerOnChanged, d);
END InitDateTimePicker;

--
-- MultilineEntry
--

(** Returns MultilineEntry text *)
PROCEDURE (this : MultilineEntry) Text*(): String.STRING;
    VAR
        str : UIDll.PCHAR;
        ret : String.STRING;
BEGIN
    str := UIDll.MultilineEntryText(this.ptr);
    UIDll.CopyText(ret, str);
    RETURN ret
END Text;

(** Set MultilineEntry text *)
PROCEDURE (this : MultilineEntry) SetText*(text- : ARRAY OF CHAR);
BEGIN UIDll.MultilineEntrySetText(this.ptr, text);
END SetText;

(** Append MultilineEntry text *)
PROCEDURE (this : MultilineEntry) Append*(text- : ARRAY OF CHAR);
BEGIN UIDll.MultilineEntryAppend(this.ptr, text);
END Append;

(** MultilineEntry change callback *)
PROCEDURE (this : MultilineEntry) OnChanged*();
BEGIN END OnChanged;

PROCEDURE ["C"] MultilineEntryOnChanged(sender : UIDll.Control; senderData : UIDll.VOID);
    VAR this : MultilineEntry;
BEGIN
    this := SYSTEM.VAL(MultilineEntry, senderData);
    this.OnChanged()
END MultilineEntryOnChanged;

(** Returns TRUE if the MultilineEntry is readonly *)
PROCEDURE (this : MultilineEntry) IsReadOnly*(): BOOLEAN;
BEGIN RETURN UIDll.MultilineEntryReadOnly(this.ptr) # 0;
END IsReadOnly;

(** Set MultilineEntry readonly flag *)
PROCEDURE (this : MultilineEntry) SetReadOnly*(readonly : BOOLEAN);
BEGIN UIDll.MultilineEntrySetReadOnly(this.ptr, ORD(readonly));
END SetReadOnly;

(** Initialize a new MultilineEntry. *)
PROCEDURE InitMultilineEntry*(e : MultilineEntry);
BEGIN
    IF e.ptr # NIL THEN RETURN END;
    e.ptr := UIDll.NewMultilineEntry();
    UIDll.MultilineEntryOnChanged(e.ptr, MultilineEntryOnChanged, e);
END InitMultilineEntry;

(** Initialize a new non-wrapping MultilineEntry. *)
PROCEDURE InitNonWrappingMultilineEntry*(e : MultilineEntry);
BEGIN
    IF e.ptr # NIL THEN RETURN END;
    e.ptr := UIDll.NewNonWrappingMultilineEntry();
    UIDll.MultilineEntryOnChanged(e.ptr, MultilineEntryOnChanged, e);
END InitNonWrappingMultilineEntry;

--
-- MenuItem
--

(** Enables the menu item. *)
PROCEDURE (this : MenuItem) Enable*;
BEGIN
    UIDll.MenuItemEnable(this.ptr);
END Enable;

(** Menu item is grayed out and user interaction is not possible. *)
PROCEDURE (this : MenuItem) Disable*;
BEGIN
    UIDll.MenuItemDisable(this.ptr);
END Disable;

(** Returns TRUE if the MenuItem is checked *)
PROCEDURE (this : MenuItem) IsChecked*(): BOOLEAN;
BEGIN RETURN UIDll.MenuItemChecked(this.ptr) # 0;
END IsChecked;

(** Set Checkbox MenuItem flag *)
PROCEDURE (this : MenuItem) SetChecked*(checked : BOOLEAN);
BEGIN UIDll.MenuItemSetChecked(this.ptr, ORD(checked));
END SetChecked;

(** MenuItem click callback *)
PROCEDURE (this : MenuItem) OnClicked*();
BEGIN END OnClicked;

PROCEDURE ["C"] MenuItemOnClicked(sender : UIDll.Control; senderData : UIDll.VOID);
    VAR this : MenuItem;
BEGIN
    this := SYSTEM.VAL(MenuItem, senderData);
    this.OnClicked()
END MenuItemOnClicked;

--
-- Menu
--

(** Appends a generic menu item. *)
PROCEDURE (this : Menu) AppendItem*(name- : ARRAY OF CHAR): MenuItem;
    VAR ret : MenuItem;
BEGIN
    NEW(ret);
    ret.ptr := UIDll.MenuAppendItem(this.ptr, name);
    UIDll.MenuItemOnClicked(ret.ptr, MenuItemOnClicked, ret);
    RETURN ret
END AppendItem;

(** Appends a generic menu item with a checkbox. *)
PROCEDURE (this : Menu) AppendCheckItem*(name- : ARRAY OF CHAR): MenuItem;
    VAR ret : MenuItem;
BEGIN
    NEW(ret);
    ret.ptr := UIDll.MenuAppendCheckItem(this.ptr, name);
    UIDll.MenuItemOnClicked(ret.ptr, MenuItemOnClicked, ret);
    RETURN ret
END AppendCheckItem;

(** Appends a new `Quit` menu item. *)
PROCEDURE (this : Menu) AppendQuitItem*(): MenuItem;
    VAR ret : MenuItem;
BEGIN
    NEW(ret);
    ret.ptr := UIDll.MenuAppendQuitItem(this.ptr);
    UIDll.MenuItemOnClicked(ret.ptr, MenuItemOnClicked, ret);
    RETURN ret
END AppendQuitItem;

(** Appends a new `Preferences` menu item. *)
PROCEDURE (this : Menu) AppendPreferencesItem*(): MenuItem;
    VAR ret : MenuItem;
BEGIN
    NEW(ret);
    ret.ptr := UIDll.MenuAppendPreferencesItem(this.ptr);
    UIDll.MenuItemOnClicked(ret.ptr, MenuItemOnClicked, ret);
    RETURN ret
END AppendPreferencesItem;

(** Appends a new `About` menu item. *)
PROCEDURE (this : Menu) AppendAboutItem*(): MenuItem;
    VAR ret : MenuItem;
BEGIN
    NEW(ret);
    ret.ptr := UIDll.MenuAppendAboutItem(this.ptr);
    UIDll.MenuItemOnClicked(ret.ptr, MenuItemOnClicked, ret);
    RETURN ret
END AppendAboutItem;

(** Appends a new separator. *)
PROCEDURE (this : Menu) AppendSeparator*;
BEGIN
    UIDll.MenuAppendSeparator(this.ptr);
END AppendSeparator;

(** Initialize Menu *)
PROCEDURE InitMenu*(m : Menu; name- : ARRAY OF CHAR);
BEGIN
    IF m.ptr # NIL THEN RETURN END;
    m.ptr := UIDll.NewMenu(name);;
END InitMenu;

--
-- Area
--

PROCEDURE (this : Area) SetSize*(width : LONGINT; height : LONGINT);
BEGIN  UIDll.AreaSetSize(this.ptr, width, height); END SetSize;

PROCEDURE (this : Area) QueueRedrawAll*();
BEGIN  UIDll.AreaQueueRedrawAll(this.ptr); END QueueRedrawAll;

(** Draw callback *)
PROCEDURE (this : Area) Draw*(context : DrawContext);
BEGIN END Draw;

PROCEDURE ["C"] AreaHandlerDraw(areaHandler : UIDll.VOID; area : UIDll.VOID; areaDrawParams : UIDll.VOID);
    VAR
        this : Area;
        ah : UIDll.AreaHandlerPtr;
        param : UIDll.AreaDrawParamsPtr;
        context : DrawContext;
BEGIN
    ah := SYSTEM.VAL(UIDll.AreaHandlerPtr, areaHandler);
    param := SYSTEM.VAL(UIDll.AreaDrawParamsPtr, areaDrawParams);
    NEW(context);
    context.ptr         := param.Context;
    context.AreaWidth   := param.AreaWidth;
    context.AreaHeight  := param.AreaHeight;
    context.ClipX       := param.ClipX;
    context.ClipY       := param.ClipY;
    context.ClipWidth   := param.ClipWidth;
    context.ClipHeight  := param.ClipHeight;
    this := SYSTEM.VAL(Area, ah.Area);
    this.Draw(context)
END AreaHandlerDraw;

(** MouseEvent callback *)
PROCEDURE (this : Area) MouseEvent*(event : MouseEvent);
BEGIN END MouseEvent;

PROCEDURE ["C"] AreaMouseEvent(areaHandler : UIDll.VOID; area : UIDll.VOID; areaMouseEvent : UIDll.VOID);
    VAR
        this : Area;
        ah : UIDll.AreaHandlerPtr;
        event : UIDll.AreaMouseEventPtr;
BEGIN
    ah := SYSTEM.VAL(UIDll.AreaHandlerPtr, areaHandler);
    event := SYSTEM.VAL(UIDll.AreaMouseEventPtr, areaMouseEvent);
    this := SYSTEM.VAL(Area, ah.Area);
    this.MouseEvent(event)
END AreaMouseEvent;

(** MouseCrossed callback *)
PROCEDURE (this : Area) MouseCrossed*(left : LONGINT);
BEGIN END MouseCrossed;

PROCEDURE ["C"] AreaMouseCrossed(areaHandler : UIDll.VOID; area : UIDll.VOID; left : UIDll.INT);
    VAR
        this : Area;
        ah : UIDll.AreaHandlerPtr;
BEGIN
    ah := SYSTEM.VAL(UIDll.AreaHandlerPtr, areaHandler);
    this := SYSTEM.VAL(Area, ah.Area);
    this.MouseCrossed(left)
END AreaMouseCrossed;

(** DragBroken callback *)
PROCEDURE (this : Area) DragBroken*();
BEGIN END DragBroken;

PROCEDURE ["C"] AreaDragBroken(areaHandler : UIDll.VOID; area : UIDll.VOID);
    VAR
        this : Area;
        ah : UIDll.AreaHandlerPtr;
BEGIN
    ah := SYSTEM.VAL(UIDll.AreaHandlerPtr, areaHandler);
    this := SYSTEM.VAL(Area, ah.Area);
    this.DragBroken()
END AreaDragBroken;

(** MouseEvent callback *)
PROCEDURE (this : Area) KeyEvent*(event : KeyEvent) : LONGINT;
BEGIN RETURN 0 END KeyEvent;

PROCEDURE ["C"] AreaKeyEvent(areaHandler : UIDll.VOID; area : UIDll.VOID; areaKeyEvent : UIDll.VOID): UIDll.INT;
    VAR
        this : Area;
        ah : UIDll.AreaHandlerPtr;
        event : UIDll.AreaKeyEventPtr;
BEGIN
    ah := SYSTEM.VAL(UIDll.AreaHandlerPtr, areaHandler);
    event := SYSTEM.VAL(UIDll.AreaKeyEventPtr, areaKeyEvent);
    this := SYSTEM.VAL(Area, ah.Area);
    RETURN this.KeyEvent(event)
END AreaKeyEvent;

(** Initialize Area *)
PROCEDURE InitArea*(a : Area);
BEGIN
    IF a.ptr # NIL THEN RETURN END;
    a.ah.Draw           := AreaHandlerDraw;
    a.ah.MouseEvent     := AreaMouseEvent;
    a.ah.MouseCrossed   := AreaMouseCrossed;
    a.ah.DragBroken     := AreaDragBroken;
    a.ah.KeyEvent       := AreaKeyEvent;
    a.ah.Area           := a;
    a.ptr               := UIDll.NewArea(a.ah);
END InitArea;

(** Initialize ScrollingArea *)
PROCEDURE InitScrollingArea*(a : Area; width : LONGINT; height : LONGINT);
BEGIN
    IF a.ptr # NIL THEN RETURN END;
    a.ah.Draw           := AreaHandlerDraw;
    a.ah.MouseEvent     := AreaMouseEvent;
    a.ah.MouseCrossed   := AreaMouseCrossed;
    a.ah.DragBroken     := AreaDragBroken;
    a.ah.KeyEvent       := AreaKeyEvent;
    a.ah.Area           := a;
    a.ptr               := UIDll.NewScrollingArea(a.ah, width, height);
END InitScrollingArea;

--
-- Path
--

(** Deallocate resources *)
PROCEDURE (this : Path) Destroy*();
BEGIN
    IF this.ptr # NIL THEN
        UIDll.DrawFreePath(this.ptr);
        this.ptr := NIL;
    END;
END Destroy;

PROCEDURE (this : Path) NewFigure*(x : LONGREAL; y : LONGREAL);
BEGIN UIDll.DrawPathNewFigure(this.ptr, x, y);
END NewFigure;

PROCEDURE (this : Path) NewFigureWithArc*(xCenter : LONGREAL; yCenter  : LONGREAL; radius : LONGREAL; startAngle : LONGREAL; sweep : LONGREAL; negative : BOOLEAN);
BEGIN UIDll.DrawPathNewFigureWithArc(this.ptr, xCenter, yCenter, radius, startAngle, sweep, ORD(negative));
END NewFigureWithArc;

PROCEDURE (this : Path) LineTo*(x : LONGREAL; y : LONGREAL);
BEGIN UIDll.DrawPathLineTo(this.ptr, x, y);
END LineTo;

PROCEDURE (this : Path) ArcTo*(xCenter : LONGREAL; yCenter  : LONGREAL; radius : LONGREAL; startAngle : LONGREAL; sweep : LONGREAL; negative : BOOLEAN);
BEGIN UIDll.DrawPathArcTo(this.ptr, xCenter, yCenter, radius, startAngle, sweep, ORD(negative));
END ArcTo;

PROCEDURE (this : Path) CloseFigure*();
BEGIN UIDll.DrawPathCloseFigure(this.ptr);
END CloseFigure;

PROCEDURE (this : Path) AddRectangle*(x : LONGREAL; y : LONGREAL; width : LONGREAL; height : LONGREAL);
BEGIN UIDll.DrawPathAddRectangle(this.ptr, x, y, width, height);
END AddRectangle;

PROCEDURE (this : Path) IsEnded*() : BOOLEAN;
BEGIN RETURN UIDll.DrawPathEnded(this.ptr) = 1;
END IsEnded;

PROCEDURE (this : Path) End*();
BEGIN UIDll.DrawPathEnd(this.ptr);
END End;

PROCEDURE FinalizePath(adr : SYSTEM.ADDRESS);
    VAR this : Path;
BEGIN 
    this := SYSTEM.VAL(Path, adr);
    this.Destroy()
END FinalizePath;

(** Initialize Path *)
PROCEDURE InitPath*(dp : Path; fillMode := FillModeWinding : LONGINT);
BEGIN
    IF dp.ptr # NIL THEN RETURN END;
    dp.ptr := UIDll.DrawNewPath(fillMode);
    oberonRTS.InstallFinalizer(FinalizePath, dp);
END InitPath;

--
-- Brush
--

(** Initialize Solid Brush *)
PROCEDURE InitSolidBrush*(VAR brush : Brush; r, g, b : LONGREAL; a := 1.0 : LONGREAL);
BEGIN
    brush.Type := BrushTypeSolid;
    brush.R := r;
    brush.G := g;
    brush.B := b;
    brush.A := a;
END InitSolidBrush;

--
-- Stroke
--

(** Initialize Stroke *)
PROCEDURE InitStroke*(VAR stroke : Stroke; cap, join : LONGINT; thickness : LONGREAL);
BEGIN
    stroke.Cap := cap;
    stroke.Join := join;
    stroke.Thickness := thickness;
    stroke.MiterLimit := 0.0;
    stroke.Dashes := NIL;
    stroke.NumDashes := 0;
    stroke.DashPhase := 0.0;
END InitStroke;

--
-- Matrix
--

PROCEDURE (VAR this : Matrix) SetIdentity*();
BEGIN UIDll.DrawMatrixSetIdentity(SYSTEM.ADR(this.m));
END SetIdentity;

PROCEDURE (VAR this : Matrix) Translate*(x, y : LONGREAL);
BEGIN UIDll.DrawMatrixTranslate(SYSTEM.ADR(this.m), x, y);
END Translate;

PROCEDURE (VAR this : Matrix) Scale*(xCenter, yCenter, x, y : LONGREAL);
BEGIN UIDll.DrawMatrixScale(SYSTEM.ADR(this.m), xCenter, yCenter, x, y);
END Scale;

PROCEDURE (VAR this : Matrix) Rotate*(x, y, amount : LONGREAL);
BEGIN UIDll.DrawMatrixRotate(SYSTEM.ADR(this.m), x, y, amount);
END Rotate;

PROCEDURE (VAR this : Matrix) Skew*(x, y, xamount, yamount : LONGREAL);
BEGIN UIDll.DrawMatrixSkew(SYSTEM.ADR(this.m), x, y, xamount, yamount);
END Skew;

PROCEDURE (VAR this : Matrix) Multiply*(VAR src : Matrix);
BEGIN UIDll.DrawMatrixMultiply(SYSTEM.ADR(this.m), SYSTEM.ADR(src.m));
END Multiply;

PROCEDURE (VAR this : Matrix) IsInvertible*() : BOOLEAN;
BEGIN RETURN UIDll.DrawMatrixInvertible(SYSTEM.ADR(this.m)) # 0;
END IsInvertible;

PROCEDURE (VAR this : Matrix) Invert*() : BOOLEAN;
BEGIN RETURN UIDll.DrawMatrixInvert(SYSTEM.ADR(this.m)) # 0;
END Invert;

PROCEDURE (VAR this : Matrix) TransformPoint*(VAR x : LONGREAL; VAR y : LONGREAL);
BEGIN UIDll.DrawMatrixTransformPoint(SYSTEM.ADR(this.m), x, y);
END TransformPoint;

PROCEDURE (VAR this : Matrix) TransformSize*(VAR x : LONGREAL; VAR y : LONGREAL);
BEGIN UIDll.DrawMatrixTransformSize(SYSTEM.ADR(this.m), x, y);
END TransformSize;

--
-- DrawContext
--

PROCEDURE (this : DrawContext) Save*();
BEGIN UIDll.DrawSave(this.ptr);
END Save;

PROCEDURE (this : DrawContext) Restore*();
BEGIN UIDll.DrawRestore(this.ptr);
END Restore;

PROCEDURE (this : DrawContext) Transform *(matrix- : Matrix);
BEGIN UIDll.DrawTransform(this.ptr, SYSTEM.ADR(matrix.m));
END Transform ;

PROCEDURE (this : DrawContext) Clip*(path : Path);
BEGIN UIDll.DrawClip(this.ptr, path.ptr);
END Clip;

PROCEDURE (this : DrawContext) Fill*(path : Path; VAR b : Brush);
BEGIN
    IF ~path.IsEnded() THEN RETURN END;
    UIDll.DrawFill(this.ptr, path.ptr, SYSTEM.REF(b));
END Fill;

PROCEDURE (this : DrawContext) Stroke*(path : Path; VAR b : Brush; VAR s : Stroke);
BEGIN
    IF ~path.IsEnded() THEN RETURN END;
    UIDll.DrawStroke(this.ptr, path.ptr, SYSTEM.REF(b), SYSTEM.REF(s));
END Stroke;

--
-- ColorButton
--

(** Returns the color button color. *)
PROCEDURE (this : ColorButton) Color*(VAR r : LONGREAL; VAR g : LONGREAL; VAR bl : LONGREAL; VAR a : LONGREAL);
BEGIN
    UIDll.ColorButtonColor(this.ptr, r, g, bl, a);
END Color;

(** Sets the color button color. *)
PROCEDURE (this : ColorButton) SetColor*(r, g, bl, a : LONGREAL);
BEGIN
    UIDll.ColorButtonSetColor(this.ptr, r, g, bl, a);
END SetColor;

(** ColorButton change callback *)
PROCEDURE (this : ColorButton) OnChanged*();
BEGIN END OnChanged;

PROCEDURE ["C"] ColorButtonOnChanged(sender : UIDll.Control; senderData : UIDll.VOID);
    VAR this : ColorButton;
BEGIN
    this := SYSTEM.VAL(ColorButton, senderData);
    this.OnChanged()
END ColorButtonOnChanged;

(** Initialize ColorButton *)
PROCEDURE InitColorButton*(b : ColorButton);
BEGIN
    IF b.ptr # NIL THEN RETURN END;
    b.ptr := UIDll.NewColorButton();
    UIDll.ColorButtonOnChanged(b.ptr, ColorButtonOnChanged, b);
END InitColorButton;

--
-- Form
--

(** Appends a control with a label to the form. *)
PROCEDURE (this : Form) Append*(name- : ARRAY OF CHAR; control : Control; stretchy : BOOLEAN);
BEGIN
    UIDll.FormAppend(this.ptr, name, control.ptr, ORD(stretchy));
END Append;

(** Returns the number of controls contained within the form. *)
PROCEDURE (this : Form) NumChildren*(): LONGINT;
BEGIN RETURN UIDll.FormNumChildren(this.ptr)
END NumChildren;

(** Removes the control at index from the form. *)
PROCEDURE (this : Form) Delete*(index : LONGINT);
BEGIN UIDll.FormDelete(this.ptr, index);
END Delete;

(** Returns whether or not controls within the form are padded. *)
PROCEDURE (this : Form) IsPadded*(): BOOLEAN;
BEGIN RETURN UIDll.FormPadded(this.ptr) # 0;
END IsPadded;

(** Sets whether or not controls within the box are padded. *)
PROCEDURE (this : Form) SetPadded*(padded : BOOLEAN);
BEGIN UIDll.FormSetPadded(this.ptr, ORD(padded));
END SetPadded;

(** Initialize Form *)
PROCEDURE InitForm*(f : Form);
BEGIN
    IF f.ptr # NIL THEN RETURN END;
    f.ptr := UIDll.NewForm();
END InitForm;

--
-- Grid
--

(** Appends a control to the grid. *)
PROCEDURE (this : Grid) Append*(control : Control; left, top, xpan, yspan, hexpand, halign, vexpand, valign : LONGINT);
BEGIN
    UIDll.GridAppend(this.ptr, control.ptr, left, top, xpan, yspan, hexpand, halign, vexpand, valign);
END Append;

(** Inserts a control positioned in relation to another control within the grid. *)
PROCEDURE (this : Grid) InsertAt*(control, existing : Control; at, xpan, yspan, hexpand, halign, vexpand, valign : LONGINT);
BEGIN
    UIDll.GridInsertAt(this.ptr, control.ptr, existing.ptr, at, xpan, yspan, hexpand, halign, vexpand, valign);
END InsertAt;

(** Returns whether or not controls within the grid are padded. *)
PROCEDURE (this : Grid) IsPadded*(): BOOLEAN;
BEGIN RETURN UIDll.GridPadded(this.ptr) # 0;
END IsPadded;

(** Sets whether or not controls within the grid are padded. *)
PROCEDURE (this : Grid) SetPadded*(padded : BOOLEAN);
BEGIN UIDll.GridSetPadded(this.ptr, ORD(padded));
END SetPadded;

(** Initialize Grid *)
PROCEDURE InitGrid*(g : Grid);
BEGIN
    IF g.ptr # NIL THEN RETURN END;
    g.ptr := UIDll.NewGrid();
END InitGrid;

--
-- Image
--

(** Appends a new image representation. *)
PROCEDURE (this : Image) Append*(pixels- : ARRAY OF SYSTEM.BYTE; pixelWidth, pixelHeight, byteStride : LONGINT);
BEGIN
    UIDll.ImageAppend(this.ptr, pixels, pixelWidth, pixelHeight, byteStride);
END Append;

(** Deallocate resources *)
PROCEDURE (this : Image) Destroy*();
BEGIN
    IF this.ptr # NIL THEN
        UIDll.FreeImage(this.ptr);
        this.ptr := NIL;
    END;
END Destroy;

PROCEDURE FinalizeImage(adr : SYSTEM.ADDRESS);
    VAR this : Image;
BEGIN 
    this := SYSTEM.VAL(Image, adr);
    this.Destroy()
END FinalizeImage;

(** Initialize Image *)
PROCEDURE InitImage*(i : Image; width, height :LONGREAL);
BEGIN
    IF i.ptr # NIL THEN RETURN END;
    i.ptr := UIDll.NewImage(width, height);
    oberonRTS.InstallFinalizer(FinalizeImage, i);
END InitImage;

--
-- TableValue
--

(** Gets the TableValue type. *)
PROCEDURE (this : TableValue) GetType*(): LONGINT;
BEGIN RETURN UIDll.TableValueGetType(this.ptr)
END GetType;

(** Returns the string value. *)
PROCEDURE (this : TableValue) Text*(): String.STRING;
    VAR
        str : UIDll.PCHAR;
        ret : String.STRING;
BEGIN
    str := UIDll.TableValueString(this.ptr);
    UIDll.CopyText(ret, str);
    RETURN ret
END Text;

(** Returns the image value. *)
PROCEDURE (this : TableValue) Image*(): Image;
    VAR ret : Image;
BEGIN
    NEW(ret);
    ret.ptr := UIDll.TableValueImage(this.ptr);
    RETURN ret
END Image;

(** Returns the integer value. *)
PROCEDURE (this : TableValue) Int*(): LONGINT;
BEGIN RETURN UIDll.TableValueInt(this.ptr)
END Int;

(** Returns the color value. *)
PROCEDURE (this : TableValue) Color*(VAR r : LONGREAL; VAR g : LONGREAL; VAR b : LONGREAL; VAR a : LONGREAL);
BEGIN UIDll.TableValueColor(this.ptr, r, g, b, a)
END Color;

(** Creates a new table value to store a text string. *)
PROCEDURE InitTableValueString*(tv : TableValue; str- : ARRAY OF CHAR);
BEGIN
    IF tv.ptr # NIL THEN RETURN END;
    tv.ptr := UIDll.NewTableValueString(str);
END InitTableValueString;

(** Creates a new table value to store an image. *)
PROCEDURE InitTableValueImage*(tv : TableValue; img : Image);
BEGIN
    IF tv.ptr # NIL THEN RETURN END;
    tv.ptr := UIDll.NewTableValueImage(img.ptr);
END InitTableValueImage;

(** Creates a new table value to store an integer. *)
PROCEDURE InitTableValueInt*(tv : TableValue; i : LONGINT);
BEGIN
    IF tv.ptr # NIL THEN RETURN END;
    tv.ptr := UIDll.NewTableValueInt(i);
END InitTableValueInt;

(** Creates a new table value to store a color in. *)
PROCEDURE InitTableValueColor*(tv : TableValue; r, g, b, a : LONGREAL);
BEGIN
    IF tv.ptr # NIL THEN RETURN END;
    tv.ptr := UIDll.NewTableValueColor(r, g, b, a);
END InitTableValueColor;

--
-- TableModel
--

(* Frees the table model. *)
PROCEDURE (this : TableModel) Destroy*();
BEGIN
    IF this.ptr # NIL THEN
        UIDll.FreeTableModel(this.ptr);
        this.ptr := NIL;
    END;
END Destroy;

(* Informs all associated uiTable views that a new row has been added. *)
PROCEDURE (this : TableModel) RowInserted*(newIndex : LONGINT);
BEGIN UIDll.TableModelRowInserted(this.ptr, newIndex);
END RowInserted;

(* Informs all associated uiTable views that a row has been changed. *)
PROCEDURE (this : TableModel) RowChanged*(index : LONGINT);
BEGIN UIDll.TableModelRowChanged(this.ptr, index);
END RowChanged;

(* Informs all associated uiTable views that a row has been deleted. *)
PROCEDURE (this : TableModel) RowDeleted*(oldIndex : LONGINT);
BEGIN UIDll.TableModelRowDeleted(this.ptr, oldIndex);
END RowDeleted;

(** Returns the number of columns *)
PROCEDURE (this : TableModel) NumColumns*(): LONGINT;
BEGIN RETURN 0 END NumColumns;

PROCEDURE ["C"] TableModelHandlerNumColumns(tableModelHandler : UIDll.VOID; tableModel : UIDll.VOID): UIDll.INT;
    VAR
        this : TableModel;
        mh : UIDll.TableModelHandlerPtr;
BEGIN
    mh := SYSTEM.VAL(UIDll.TableModelHandlerPtr, tableModelHandler);
    this := SYSTEM.VAL(TableModel, mh.Model);
    RETURN this.NumColumns()
END TableModelHandlerNumColumns;

(** Returns the column type *)
PROCEDURE (this : TableModel) TableValueType*(column : LONGINT): LONGINT;
BEGIN RETURN -1 END TableValueType;

PROCEDURE ["C"] TableModelHandlerTableValueType(tableModelHandler : UIDll.VOID; tableModel : UIDll.VOID; column : UIDll.INT): UIDll.INT;
    VAR
        this : TableModel;
        mh : UIDll.TableModelHandlerPtr;
BEGIN
    mh := SYSTEM.VAL(UIDll.TableModelHandlerPtr, tableModelHandler);
    this := SYSTEM.VAL(TableModel, mh.Model);
    RETURN this.TableValueType(column)
END TableModelHandlerTableValueType;

(** Returns the number of columns *)
PROCEDURE (this : TableModel) NumRows*(): LONGINT;
BEGIN RETURN 0 END NumRows;

PROCEDURE ["C"] TableModelHandlerNumRows(tableModelHandler : UIDll.VOID; tableModel : UIDll.VOID): UIDll.INT;
    VAR
        this : TableModel;
        mh : UIDll.TableModelHandlerPtr;
BEGIN
    mh := SYSTEM.VAL(UIDll.TableModelHandlerPtr, tableModelHandler);
    this := SYSTEM.VAL(TableModel, mh.Model);
    RETURN this.NumRows()
END TableModelHandlerNumRows;

(** Returns the cell value for (row, column). *)
PROCEDURE (this : TableModel) CellValue*(row, column : LONGINT): TableValue;
BEGIN RETURN NIL END CellValue;

PROCEDURE ["C"] TableModelHandlerCellValue(tableModelHandler : UIDll.VOID; tableModel : UIDll.VOID; row : UIDll.INT; column : UIDll.INT): UIDll.ADDRESS;
    VAR
        this : TableModel;
        mh : UIDll.TableModelHandlerPtr;
        value : TableValue;
BEGIN
    mh := SYSTEM.VAL(UIDll.TableModelHandlerPtr, tableModelHandler);
    this := SYSTEM.VAL(TableModel, mh.Model);
    value := this.CellValue(row, column);
    RETURN value.ptr
END TableModelHandlerCellValue;

(** Sets the cell value for (row, column). *)
PROCEDURE (this : TableModel) SetCellValue*(row, column : LONGINT; value : TableValue);
BEGIN END SetCellValue;

PROCEDURE ["C"] TableModelHandlerSetCellValue(tableModelHandler : UIDll.VOID; tableModel : UIDll.VOID; row : UIDll.INT; column : UIDll.INT; val : UIDll.ADDRESS);
    VAR
        this : TableModel;
        mh : UIDll.TableModelHandlerPtr;
        value : TableValue;
BEGIN
    mh := SYSTEM.VAL(UIDll.TableModelHandlerPtr, tableModelHandler);
    this := SYSTEM.VAL(TableModel, mh.Model);
    NEW(value);
    value.ptr := val;
    this.SetCellValue(row, column, value);
END TableModelHandlerSetCellValue;

PROCEDURE FinalizeTableModel(adr : SYSTEM.ADDRESS);
    VAR this : TableModel;
BEGIN 
    this := SYSTEM.VAL(TableModel, adr);
    this.Destroy()
END FinalizeTableModel;

(** Initialize TableModel *)
PROCEDURE InitTableModel*(t : TableModel);
BEGIN
    IF t.ptr # NIL THEN RETURN END;
    t.mh.NumColumns := TableModelHandlerNumColumns;
    t.mh.ColumnType := TableModelHandlerTableValueType;
    t.mh.NumRows := TableModelHandlerNumRows;
    t.mh.CellValue := TableModelHandlerCellValue;
    t.mh.SetCellValue := TableModelHandlerSetCellValue;
    t.mh.Model := t;
    t.ptr := UIDll.NewTableModel(SYSTEM.ADR(t.mh));
    oberonRTS.InstallFinalizer(FinalizeTableModel, t);
END InitTableModel;

--
-- Table
--

(* Appends a text column to the table. *)
PROCEDURE (this : Table) AppendTextColumn*(name : ARRAY OF CHAR; textModelColumn : LONGINT; textEditableModelColumn := TableModelColumnNeverEditable : LONGINT);
    VAR opts : UIDll.TableTextColumnOptionalParams;
BEGIN
    opts.ColorModelColumn := -1;
    UIDll.TableAppendTextColumn(this.ptr, name, textModelColumn, textEditableModelColumn, opts);
END AppendTextColumn;

(* Appends an image column to the table. *)
PROCEDURE (this : Table) AppendImageColumn*(name : ARRAY OF CHAR; imageModelColumn : LONGINT);
BEGIN
    UIDll.TableAppendImageColumn(this.ptr, name, imageModelColumn);
END AppendImageColumn;

(* Appends a column to the table that displays both an image and text. *)
PROCEDURE (this : Table) AppendImageTextColumn*(name : ARRAY OF CHAR; imageModelColumn : LONGINT; textModelColumn : LONGINT; textEditableModelColumn := TableModelColumnNeverEditable : LONGINT);
    VAR opts : UIDll.TableTextColumnOptionalParams;
BEGIN
    opts.ColorModelColumn := -1;
    UIDll.TableAppendImageTextColumn(this.ptr, name, imageModelColumn, textModelColumn, textEditableModelColumn, opts);
END AppendImageTextColumn;

(* Appends a column to the table containing a checkbox. *)
PROCEDURE (this : Table) AppendCheckboxColumn*(name : ARRAY OF CHAR; checkboxModelColumn : LONGINT; checkboxEditableModelColumn := TableModelColumnNeverEditable : LONGINT);
BEGIN
    UIDll.TableAppendCheckboxColumn(this.ptr, name, checkboxModelColumn, checkboxEditableModelColumn);
END AppendCheckboxColumn;

(* Appends a column to the table containing a checkbox and text. *)
PROCEDURE (this : Table) AppendCheckboxTextColumn*(name : ARRAY OF CHAR; checkboxModelColumn : LONGINT; checkboxEditableModelColumn : LONGINT; textModelColumn : LONGINT; textEditableModelColumn : LONGINT);
    VAR opts : UIDll.TableTextColumnOptionalParams;
BEGIN
    opts.ColorModelColumn := -1;
    UIDll.TableAppendCheckboxTextColumn(this.ptr, name, checkboxModelColumn, checkboxEditableModelColumn, textModelColumn, textEditableModelColumn, opts);
END AppendCheckboxTextColumn;

(* Appends a column to the table containing a progress bar. *)
PROCEDURE (this : Table) AppendProgressBarColumn*(name : ARRAY OF CHAR; progressModelColumn : LONGINT);
BEGIN
    UIDll.TableAppendProgressBarColumn(this.ptr, name, progressModelColumn);
END AppendProgressBarColumn;

(* Appends a column to the table containing a button. *)
PROCEDURE (this : Table) AppendButtonColumn*(name : ARRAY OF CHAR; buttonModelColumn : LONGINT; buttonClickableModelColumn : LONGINT);
BEGIN
    UIDll.TableAppendButtonColumn(this.ptr, name, buttonModelColumn, buttonClickableModelColumn);
END AppendButtonColumn;

(** Returns whether or not the table header is visible. *)
PROCEDURE (this : Table) IsHeaderVisible*(): BOOLEAN;
BEGIN RETURN UIDll.TableHeaderVisible(this.ptr) # 0;
END IsHeaderVisible;

(** Sets whether or not the table header is visible. *)
PROCEDURE (this : Table) SetHeaderVisible*(visible : BOOLEAN);
BEGIN UIDll.TableHeaderSetVisible(this.ptr, ORD(visible));
END SetHeaderVisible;

(** Returns the column's sort indicator displayed in the table header. *)
PROCEDURE (this : Table) HeaderSortIndicator*(column : LONGINT) : LONGINT;
BEGIN RETURN UIDll.TableHeaderSortIndicator(this.ptr, column);
END HeaderSortIndicator;

(** Sets the column's sort indicator displayed in the table header. *)
PROCEDURE (this : Table) HeaderSetSortIndicator*(column : LONGINT; indicator : LONGINT);
BEGIN UIDll.TableHeaderSetSortIndicator(this.ptr, column, indicator);
END HeaderSetSortIndicator;

(** Returns the table column width. *)
PROCEDURE (this : Table) ColumnWidth*(column : LONGINT) : LONGINT;
BEGIN RETURN UIDll.TableColumnWidth(this.ptr, column);
END ColumnWidth;

(** Sets the table column width. *)
PROCEDURE (this : Table) ColumnSetWidth*(column : LONGINT; width : LONGINT);
BEGIN UIDll.TableColumnSetWidth(this.ptr, column, width);
END ColumnSetWidth;

(** Initialize Table *)
PROCEDURE InitTable*(t : Table ; tm : TableModel; RowBackgroundColorModelColumn := -1 : LONGINT);
BEGIN
    IF t.ptr # NIL THEN RETURN END;
    t.tp.Model := tm.ptr;
    t.tp.RowBackgroundColorModelColumn := RowBackgroundColorModelColumn;
    t.ptr := UIDll.NewTable(t.tp);
END InitTable;

END UI.

Button Example
--------------

.. code-block:: modula2
    
    <* +MAIN *>
    MODULE UIButtonExample;

    IMPORT UI, OSStream, String;

    TYPE
        MyButton* = POINTER TO MyButtonDesc;
        MyButtonDesc* = RECORD(UI.ButtonDesc) END;

    PROCEDURE (this : MyButton) OnClicked*();
    BEGIN OSStream.stdout.Format("MyButton clicked!\n") END OnClicked;

    PROCEDURE Test();
    VAR
        a : UI.App; w : UI.Window;
        l : UI.Label; b : MyButton;
        s : String.STRING;
    BEGIN
        NEW(a); UI.InitApp(a);
        NEW(w); UI.InitWindow(w, "Hello World!", 300, 30, FALSE);
        NEW(b); UI.InitButton(b, "ClickMe!");
        w.SetChild(b);
        s := w.Title();
        OSStream.stdout.Format("title = '%s'\n", s^);
        w.Show();
        a.Main();
    END Test;

    BEGIN
        Test();
    END UIButtonExample.

Draw Example
------------

.. code-block:: modula2
    
    <* +MAIN *>
    MODULE UIDrawExample;

    IMPORT UI, String;

    TYPE
        MyArea* = POINTER TO MyAreaDesc;
        MyAreaDesc* = RECORD(UI.AreaDesc)
            Width : LONGREAL;
            Height : LONGREAL;
        END;

    PROCEDURE (this : MyArea) Draw*(context : UI.DrawContext);
        VAR
            path : UI.Path;
            brush : UI.Brush;
            stroke : UI.Stroke;
            matrix : UI.Matrix;
    BEGIN
        NEW(path); UI.InitPath(path, UI.FillModeWinding);
        path.AddRectangle(0., 0., this.Width, this.Height);
        path.End();
        UI.InitSolidBrush(brush, 1.0, 0.0, 0.0);
        UI.InitStroke(stroke, UI.LineCapFlat, UI.LineJoinMiter, 10.0);
        matrix.SetIdentity();
        matrix.Scale(0.0, 0.0, 0.5, 0.5);
        context.Transform(matrix);
        context.Fill(path, brush);
        UI.InitSolidBrush(brush, 0.0, 0.0, 1.0);
        context.Stroke(path, brush, stroke);
    END Draw;

    PROCEDURE (this : MyArea) MouseEvent*(event : UI.MouseEvent);
    BEGIN
        this.Width := event.AreaWidth;
        this.Height := event.AreaHeight;
        this.QueueRedrawAll();
    END MouseEvent;

    PROCEDURE Test();
    VAR
        a : UI.App; w : UI.Window;
        area : MyArea;
        s : String.STRING;
    BEGIN
        NEW(a); UI.InitApp(a);
        NEW(area); UI.InitArea(area );
        NEW(w); UI.InitWindow(w, "Hello World!", 300, 300, FALSE);
        w.SetMargined(TRUE);
        w.SetChild(area);
        w.Show();
        area.QueueRedrawAll();
        a.Main();
    END Test;

    BEGIN
        Test();
    END UIDrawExample.

Table Example
-------------

.. code-block:: modula2
    
    <* +MAIN *>
    MODULE UITableExample;

    IMPORT UI, String;

    TYPE
        MyTableModel* = POINTER TO MyTableModelDesc;
        MyTableModelDesc* = RECORD(UI.TableModelDesc) END;

    PROCEDURE (this : MyTableModel) NumColumns*(): LONGINT;
    BEGIN RETURN 10 END NumColumns;

    PROCEDURE (this : MyTableModel) TableValueType*(column : LONGINT): LONGINT;
    BEGIN RETURN UI.TableValueTypeString END TableValueType;

    PROCEDURE (this : MyTableModel) NumRows*(): LONGINT;
    BEGIN RETURN 10 END NumRows;

    PROCEDURE (this : MyTableModel) CellValue*(row, column : LONGINT): UI.TableValue;
        VAR
            ret : UI.TableValue;
            s : String.STRING;
    BEGIN
        NEW(ret);
        String.Format(s, "%d,%d", row, column);
        UI.InitTableValueString(ret, s^);
        RETURN ret
    END CellValue;

    PROCEDURE Test();
    VAR
        a : UI.App; w : UI.Window;
        t : UI.Table; model : MyTableModel;
        s : String.STRING;
    BEGIN
        NEW(a); UI.InitApp(a);
        NEW(w); UI.InitWindow(w, "Hello World!", 300, 30, FALSE);
        NEW(model); UI.InitTableModel(model);
        NEW(t); UI.InitTable(t, model);
        t.AppendTextColumn("a", 0);
        t.AppendTextColumn("b", 1);
        w.SetChild(t);
        w.Show();
        a.Main();
        
    END Test;

    BEGIN
        Test();
    END UITableExample.