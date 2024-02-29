.. index::
    single: UI

.. _UI:

**
UI
**


This module is an object oriented wrapper to the cross platform
user interface library `libui-ng`.

Link https://github.com/libui-ng/libui-ng.

The module is mostly complete except for styled text handling which
is currently marked as experimental in the `C` code.

It is expected that changes are implemented as the library
is marked as `mid-alpha`. Despite this the library is quite
stable, atleast on the Windows platform.


Const
=====

.. code-block:: modula2

    ForEachContinue* 	            = UIDll.ForEachContinue;

.. code-block:: modula2

    ForEachStop*                    = UIDll.ForEachStop;

.. code-block:: modula2

    AlignFill*                      = UIDll.AlignFill;

.. code-block:: modula2

    AlignStart*                     = UIDll.AlignStart;

.. code-block:: modula2

    AlignCenter*                    = UIDll.AlignCenter;

.. code-block:: modula2

    AlignEnd*                       = UIDll.AlignEnd;

.. code-block:: modula2

    AtLeading*                      = UIDll.AtLeading;

.. code-block:: modula2

    AtTop*                          = UIDll.AtTop;

.. code-block:: modula2

    AtTrailing*                     = UIDll.AtTrailing;

.. code-block:: modula2

    AtBottom*                       = UIDll.AtBottom;

.. code-block:: modula2

    WindowResizeEdgeLeft*           = UIDll.WindowResizeEdgeLeft;

.. code-block:: modula2

    WindowResizeEdgeTop*            = UIDll.WindowResizeEdgeTop;

.. code-block:: modula2

    WindowResizeEdgeRight*          = UIDll.WindowResizeEdgeRight;

.. code-block:: modula2

    WindowResizeEdgeBottom*         = UIDll.WindowResizeEdgeBottom;

.. code-block:: modula2

    WindowResizeEdgeTopLeft*        = UIDll.WindowResizeEdgeTopLeft;

.. code-block:: modula2

    WindowResizeEdgeTopRight*       = UIDll.WindowResizeEdgeTopRight;

.. code-block:: modula2

    WindowResizeEdgeBottomLeft*     = UIDll.WindowResizeEdgeBottomLeft;

.. code-block:: modula2

    WindowResizeEdgeBottomRight*    = UIDll.WindowResizeEdgeBottomRight;

.. code-block:: modula2

    BrushTypeSolid*                 = UIDll.DrawBrushTypeSolid;

.. code-block:: modula2

    BrushTypeLinearGradient*        = UIDll.DrawBrushTypeLinearGradient;

.. code-block:: modula2

    BrushTypeRadialGradient*        = UIDll.DrawBrushTypeRadialGradient;

.. code-block:: modula2

    BrushTypeImage*                 = UIDll.DrawBrushTypeImage;

.. code-block:: modula2

    LineCapFlat*                    = UIDll.DrawLineCapFlat;

.. code-block:: modula2

    LineCapRound*                   = UIDll.DrawLineCapRound;

.. code-block:: modula2

    LineCapSquare*                  = UIDll.DrawLineCapSquare;

.. code-block:: modula2

    LineJoinMiter*                  = UIDll.DrawLineJoinMiter;

.. code-block:: modula2

    LineJoinRound*                  = UIDll.DrawLineJoinRound;

.. code-block:: modula2

    LineJoinBevel*                  = UIDll.DrawLineJoinBevel;

.. code-block:: modula2

    FillModeWinding*                = UIDll.DrawFillModeWinding;

.. code-block:: modula2

    FillModeAlternate*              = UIDll.DrawFillModeAlternate;

.. code-block:: modula2

    TableValueTypeString*           = UIDll.TableValueTypeString;

.. code-block:: modula2

    TableValueTypeImage*            = UIDll.TableValueTypeImage;

.. code-block:: modula2

    TableValueTypeInt*              = UIDll.TableValueTypeInt;

.. code-block:: modula2

    TableValueTypeColor*            = UIDll.TableValueTypeColor;

.. code-block:: modula2

    TableModelColumnNeverEditable*  = UIDll.TableModelColumnNeverEditable;

.. code-block:: modula2

    TableModelColumnAlwaysEditable* = UIDll.TableModelColumnAlwaysEditable;

.. code-block:: modula2

    TableSelectionModeNone*         = UIDll.TableSelectionModeNone;

.. code-block:: modula2

    TableSelectionModeZeroOrOne*    = UIDll.TableSelectionModeZeroOrOne;

.. code-block:: modula2

    TableSelectionModeOne*          = UIDll.TableSelectionModeOne;

.. code-block:: modula2

    TableSelectionModeZeroOrMany*   = UIDll.TableSelectionModeZeroOrMany;

.. code-block:: modula2

    SortIndicatorNone*              = UIDll.SortIndicatorNone;

.. code-block:: modula2

    SortIndicatorAscending*         = UIDll.SortIndicatorAscending;

.. code-block:: modula2

    SortIndicatorDescending*        = UIDll.SortIndicatorDescending;

Types
=====

.. code-block:: modula2

    MouseEvent*     = UIDll.AreaMouseEventPtr;

.. code-block:: modula2

    KeyEvent*       = UIDll.AreaKeyEventPtr;

.. code-block:: modula2

    App* = POINTER TO AppDesc;

.. code-block:: modula2

    AppDesc* = RECORD opts- : UIDll.InitOptions END;

.. code-block:: modula2

    Control* = POINTER TO ControlDesc;

.. code-block:: modula2

    ControlDesc* = RECORD ptr- : UIDll.ADDRESS END;

.. code-block:: modula2

    Window* = POINTER TO WindowDesc;

.. code-block:: modula2

    WindowDesc* = RECORD(ControlDesc) END;

.. code-block:: modula2

    Button* = POINTER TO ButtonDesc;

.. code-block:: modula2

    ButtonDesc* = RECORD(ControlDesc) END;

.. code-block:: modula2

    Box* = POINTER TO BoxDesc;

.. code-block:: modula2

    BoxDesc* = RECORD(ControlDesc) END;

.. code-block:: modula2

    Checkbox* = POINTER TO CheckboxDesc;

.. code-block:: modula2

    CheckboxDesc* = RECORD(ControlDesc) END;

.. code-block:: modula2

    Entry* = POINTER TO EntryDesc;

.. code-block:: modula2

    EntryDesc* = RECORD(ControlDesc) END;

.. code-block:: modula2

    Label* = POINTER TO LabelDesc;

.. code-block:: modula2

    LabelDesc* = RECORD(ControlDesc) END;

.. code-block:: modula2

    Tab* = POINTER TO TabDesc;

.. code-block:: modula2

    TabDesc* = RECORD(ControlDesc) END;

.. code-block:: modula2

    Group* = POINTER TO GroupDesc;

.. code-block:: modula2

    GroupDesc* = RECORD(ControlDesc) END;

.. code-block:: modula2

    Spinbox* = POINTER TO SpinboxDesc;

.. code-block:: modula2

    SpinboxDesc* = RECORD(ControlDesc) END;

.. code-block:: modula2

    Slider* = POINTER TO SliderDesc;

.. code-block:: modula2

    SliderDesc* = RECORD(ControlDesc) END;

.. code-block:: modula2

    ProgressBar* = POINTER TO ProgressBarDesc;

.. code-block:: modula2

    ProgressBarDesc* = RECORD(ControlDesc) END;

.. code-block:: modula2

    Separator* = POINTER TO SeparatorDesc;

.. code-block:: modula2

    SeparatorDesc* = RECORD(ControlDesc) END;

.. code-block:: modula2

    Combobox* = POINTER TO ComboboxDesc;

.. code-block:: modula2

    ComboboxDesc* = RECORD(ControlDesc) END;

.. code-block:: modula2

    EditableCombobox* = POINTER TO EditableComboboxDesc;

.. code-block:: modula2

    EditableComboboxDesc* = RECORD(ControlDesc) END;

.. code-block:: modula2

    RadioButtons* = POINTER TO RadioButtonsDesc;

.. code-block:: modula2

    RadioButtonsDesc* = RECORD(ControlDesc) END;

.. code-block:: modula2

    DateTimePicker* = POINTER TO DateTimePickerDesc;

.. code-block:: modula2

    DateTimePickerDesc* = RECORD(ControlDesc) END;

.. code-block:: modula2

    MultilineEntry* = POINTER TO MultilineEntryDesc;

.. code-block:: modula2

    MultilineEntryDesc* = RECORD(ControlDesc) END;

.. code-block:: modula2

    MenuItem* = POINTER TO MenuItemDesc;

.. code-block:: modula2

    MenuItemDesc* = RECORD(ControlDesc) END;

.. code-block:: modula2

    Menu* = POINTER TO MenuDesc;

.. code-block:: modula2

    MenuDesc* = RECORD(ControlDesc) END;

.. code-block:: modula2

    DrawContext* = POINTER TO DrawContextDesc;

.. code-block:: modula2

    DrawContextDesc* = RECORD
            ptr- : UIDll.ADDRESS;
            AreaWidth*      : LONGREAL;
            AreaHeight*     : LONGREAL;
            ClipX*          : LONGREAL;
            ClipY*          : LONGREAL;
            ClipWidth*      : LONGREAL;
            ClipHeight*     : LONGREAL;
        END;

.. code-block:: modula2

    Area* = POINTER TO AreaDesc;

.. code-block:: modula2

    AreaDesc* = RECORD(ControlDesc)
            ah : UIDll.AreaHandler;
        END;

.. code-block:: modula2

    Path* = POINTER TO PathDesc;

.. code-block:: modula2

    PathDesc* = RECORD ptr- : UIDll.ADDRESS END;

.. code-block:: modula2

    Brush* = UIDll.DrawBrush;

.. code-block:: modula2

    Stroke* = UIDll.DrawStrokeParams;

.. code-block:: modula2

    Matrix* = RECORD m* : UIDll.DrawMatrix END;

.. code-block:: modula2

    ColorButton* = POINTER TO ColorButtonDesc;

.. code-block:: modula2

    ColorButtonDesc* = RECORD(ControlDesc) END;

.. code-block:: modula2

    Form* = POINTER TO FormDesc;

.. code-block:: modula2

    FormDesc* = RECORD(ControlDesc) END;

.. code-block:: modula2

    Grid* = POINTER TO GridDesc;

.. code-block:: modula2

    GridDesc* = RECORD(ControlDesc) END;

.. code-block:: modula2

    Image* = POINTER TO ImageDesc;

.. code-block:: modula2

    ImageDesc* = RECORD ptr- : UIDll.ADDRESS END;

.. code-block:: modula2

    TableValue* = POINTER TO TableValueDesc;

.. code-block:: modula2

    TableValueDesc* = RECORD ptr- : UIDll.ADDRESS END;

.. code-block:: modula2

    TableModel* = POINTER TO TableModelDesc;

.. code-block:: modula2

    TableModelDesc* = RECORD
            ptr- : UIDll.ADDRESS;
            mh : UIDll.TableModelHandler;
        END;

.. code-block:: modula2

    Table* = POINTER TO TableDesc;

.. code-block:: modula2

    TableDesc* = RECORD (ControlDesc)
            tp : UIDll.TableParams;
        END;

Procedures
==========

.. _UI.Quit:

Quit
----

.. code-block:: modula2

    PROCEDURE Quit*();

.. _UI.OpenFile:

OpenFile
--------

 File chooser dialog window to select a single file. 

.. code-block:: modula2

    PROCEDURE OpenFile*(parent : Window): String.STRING;

.. _UI.OpenFolder:

OpenFolder
----------

 Folder chooser dialog window to select a single folder. 

.. code-block:: modula2

    PROCEDURE OpenFolder*(parent : Window): String.STRING;

.. _UI.SaveFile:

SaveFile
--------

 Save file dialog window. 

.. code-block:: modula2

    PROCEDURE SaveFile*(parent : Window): String.STRING;

.. _UI.MsgBox:

MsgBox
------

 Message box dialog window. 

.. code-block:: modula2

    PROCEDURE MsgBox*(parent : Window; title- : ARRAY OF CHAR; description- : ARRAY OF CHAR);

.. _UI.MsgBoxError:

MsgBoxError
-----------

 Message box dialog window. 

.. code-block:: modula2

    PROCEDURE MsgBoxError*(parent : Window; title- : ARRAY OF CHAR; description- : ARRAY OF CHAR);

.. _UI.App.Main:

App.Main
--------

 Start main loop 

.. code-block:: modula2

    PROCEDURE (this : App) Main*();

.. _UI.App.Destroy:

App.Destroy
-----------

 Deallocate resources 

.. code-block:: modula2

    PROCEDURE (this : App) Destroy*();

.. _UI.InitApp:

InitApp
-------

 Initialize App 

.. code-block:: modula2

    PROCEDURE InitApp*(a : App);

.. _UI.Control.Destroy:

Control.Destroy
---------------

 Dispose Control and all allocated resources 

.. code-block:: modula2

    PROCEDURE (this : Control) Destroy*();

.. _UI.Control.IsTopLevel:

Control.IsTopLevel
------------------

 Returns TRUE if control is a top level control.

.. code-block:: modula2

    PROCEDURE (this : Control) IsTopLevel*(): BOOLEAN;

.. _UI.Control.IsVisible:

Control.IsVisible
-----------------

 Returns TRUE if control is visible 

.. code-block:: modula2

    PROCEDURE (this : Control) IsVisible*(): BOOLEAN;

.. _UI.Control.Show:

Control.Show
------------

 Shows the control 

.. code-block:: modula2

    PROCEDURE (this : Control) Show*();

.. _UI.Control.Hide:

Control.Hide
------------

 Hides the control 

.. code-block:: modula2

    PROCEDURE (this : Control) Hide*();

.. _UI.Control.IsEnabled:

Control.IsEnabled
-----------------

 Returns TRUE if the control is enabled 

.. code-block:: modula2

    PROCEDURE (this : Control) IsEnabled*(): BOOLEAN;

.. _UI.Control.Enable:

Control.Enable
--------------

 Enable control 

.. code-block:: modula2

    PROCEDURE (this : Control) Enable*();

.. _UI.Control.Disable:

Control.Disable
---------------

 Disable control 

.. code-block:: modula2

    PROCEDURE (this : Control) Disable*();

.. _UI.Window.Title:

Window.Title
------------

 Returns Window title 

.. code-block:: modula2

    PROCEDURE (this : Window) Title*(): String.STRING;

.. _UI.Window.SetTitle:

Window.SetTitle
---------------

 Set Window title 

.. code-block:: modula2

    PROCEDURE (this : Window) SetTitle*(title- : ARRAY OF CHAR);

.. _UI.Window.Position:

Window.Position
---------------

 Get Window position 

.. code-block:: modula2

    PROCEDURE (this : Window) Position*(VAR x : LONGINT; VAR y : LONGINT);

.. _UI.Window.SetPosition:

Window.SetPosition
------------------

 Set Window position 

.. code-block:: modula2

    PROCEDURE (this : Window) SetPosition*(x, y : LONGINT);

.. _UI.Window.OnPositionChanged:

Window.OnPositionChanged
------------------------

 On position change callback.

.. code-block:: modula2

    PROCEDURE (this : Window) OnPositionChanged*();

.. _UI.Window.ContentSize:

Window.ContentSize
------------------

 Get Window content size 

.. code-block:: modula2

    PROCEDURE (this : Window) ContentSize*(VAR width : LONGINT; VAR height : LONGINT);

.. _UI.Window.SetContentSize:

Window.SetContentSize
---------------------

 Set Window content size 

.. code-block:: modula2

    PROCEDURE (this : Window) SetContentSize*(width, height : LONGINT);

.. _UI.Window.IsFullScreen:

Window.IsFullScreen
-------------------

 Returns TRUE if the control is fullscreen 

.. code-block:: modula2

    PROCEDURE (this : Window) IsFullScreen*(): BOOLEAN;

.. _UI.Window.SetFullscreen:

Window.SetFullscreen
--------------------

 Set Window fullscreen 

.. code-block:: modula2

    PROCEDURE (this : Window) SetFullscreen*(fullscreen : BOOLEAN);

.. _UI.Window.OnContentSizeChanged:

Window.OnContentSizeChanged
---------------------------

 On content size change callback.

.. code-block:: modula2

    PROCEDURE (this : Window) OnContentSizeChanged*();

.. _UI.Window.OnClosing:

Window.OnClosing
----------------

 On close callback.

.. code-block:: modula2

    PROCEDURE (this : Window) OnClosing*(): BOOLEAN;

.. _UI.Window.OnFocusChanged:

Window.OnFocusChanged
---------------------

 On focus change callback.

.. code-block:: modula2

    PROCEDURE (this : Window) OnFocusChanged*();

.. _UI.Window.IsFocused:

Window.IsFocused
----------------

 Returns TRUE if the control has focus 

.. code-block:: modula2

    PROCEDURE (this : Window) IsFocused*(): BOOLEAN;

.. _UI.Window.IsBorderless:

Window.IsBorderless
-------------------

 Returns TRUE if the control is borderless 

.. code-block:: modula2

    PROCEDURE (this : Window) IsBorderless*(): BOOLEAN;

.. _UI.Window.SetBorderless:

Window.SetBorderless
--------------------

 Set Window bordless flag 

.. code-block:: modula2

    PROCEDURE (this : Window) SetBorderless*(borderless : BOOLEAN);

.. _UI.Window.SetChild:

Window.SetChild
---------------

 Set child control 

.. code-block:: modula2

    PROCEDURE (this : Window) SetChild*(child : Control);

.. _UI.Window.IsMargined:

Window.IsMargined
-----------------

 Returns TRUE if the control is margined 

.. code-block:: modula2

    PROCEDURE (this : Window) IsMargined*(): BOOLEAN;

.. _UI.Window.SetMargined:

Window.SetMargined
------------------

 Set Window margined flag 

.. code-block:: modula2

    PROCEDURE (this : Window) SetMargined*(margined : BOOLEAN);

.. _UI.Window.IsResizeable:

Window.IsResizeable
-------------------

 Returns TRUE if the control is resizeable 

.. code-block:: modula2

    PROCEDURE (this : Window) IsResizeable*(): BOOLEAN;

.. _UI.Window.SetResizeable:

Window.SetResizeable
--------------------

 Set Window resizeable flag 

.. code-block:: modula2

    PROCEDURE (this : Window) SetResizeable*(resizeable : BOOLEAN);

.. _UI.InitWindow:

InitWindow
----------

 Initialize Window 

.. code-block:: modula2

    PROCEDURE InitWindow*(w : Window; title- : ARRAY OF CHAR; width, height : LONGINT; hasMenubar : BOOLEAN);

.. _UI.Button.Text:

Button.Text
-----------

 Returns Button text 

.. code-block:: modula2

    PROCEDURE (this : Button) Text*(): String.STRING;

.. _UI.Button.SetText:

Button.SetText
--------------

 Set Button text 

.. code-block:: modula2

    PROCEDURE (this : Button) SetText*(text- : ARRAY OF CHAR);

.. _UI.Button.OnClicked:

Button.OnClicked
----------------

 Button click callback 

.. code-block:: modula2

    PROCEDURE (this : Button) OnClicked*();

.. _UI.InitButton:

InitButton
----------

 Initialize Button 

.. code-block:: modula2

    PROCEDURE InitButton*(b : Button; text- : ARRAY OF CHAR);

.. _UI.Box.Append:

Box.Append
----------


Append control to Box.
If stretchy is TRUE the Control expand to the remaining space.
If multiple strechy Controls exists the space is equally shared.


.. code-block:: modula2

    PROCEDURE (this : Box) Append*(child : Control; stretchy : BOOLEAN);

.. _UI.Box.NumChildren:

Box.NumChildren
---------------

 Returns the number of controls contained within the box. 

.. code-block:: modula2

    PROCEDURE (this : Box) NumChildren*():LONGINT;

.. _UI.Box.Delete:

Box.Delete
----------

 Removes the Control at index 

.. code-block:: modula2

    PROCEDURE (this : Box) Delete*(index : LONGINT);

.. _UI.Box.IsPadded:

Box.IsPadded
------------

 Returns TRUE if the Box is padded 

.. code-block:: modula2

    PROCEDURE (this : Box) IsPadded*(): BOOLEAN;

.. _UI.Box.SetPadded:

Box.SetPadded
-------------

 Set Box padded flag 

.. code-block:: modula2

    PROCEDURE (this : Box) SetPadded*(padded : BOOLEAN);

.. _UI.InitVerticalBox:

InitVerticalBox
---------------

 Initialize vertical Box 

.. code-block:: modula2

    PROCEDURE InitVerticalBox*(b : Box);

.. _UI.InitHorizontalBox:

InitHorizontalBox
-----------------

 Initialize horizontal Box 

.. code-block:: modula2

    PROCEDURE InitHorizontalBox*(b : Box);

.. _UI.Checkbox.Text:

Checkbox.Text
-------------

 Returns Checkbox text 

.. code-block:: modula2

    PROCEDURE (this : Checkbox) Text*(): String.STRING;

.. _UI.Checkbox.SetText:

Checkbox.SetText
----------------

 Set Checkbox text 

.. code-block:: modula2

    PROCEDURE (this : Checkbox) SetText*(text- : ARRAY OF CHAR);

.. _UI.Checkbox.OnToggled:

Checkbox.OnToggled
------------------

 Checkbox toggled callback 

.. code-block:: modula2

    PROCEDURE (this : Checkbox) OnToggled*();

.. _UI.Checkbox.IsChecked:

Checkbox.IsChecked
------------------

 Returns TRUE if the Checkbox is checked 

.. code-block:: modula2

    PROCEDURE (this : Checkbox) IsChecked*(): BOOLEAN;

.. _UI.Checkbox.SetChecked:

Checkbox.SetChecked
-------------------

 Set Checkbox checked flag 

.. code-block:: modula2

    PROCEDURE (this : Checkbox) SetChecked*(checked : BOOLEAN);

.. _UI.InitCheckbox:

InitCheckbox
------------

 Initialize Checkbox 

.. code-block:: modula2

    PROCEDURE InitCheckbox*(c : Checkbox; text- : ARRAY OF CHAR);

.. _UI.Entry.Text:

Entry.Text
----------

 Returns Entry text 

.. code-block:: modula2

    PROCEDURE (this : Entry) Text*(): String.STRING;

.. _UI.Entry.SetText:

Entry.SetText
-------------

 Set Entry text 

.. code-block:: modula2

    PROCEDURE (this : Entry) SetText*(text- : ARRAY OF CHAR);

.. _UI.Entry.OnChanged:

Entry.OnChanged
---------------

 Entry change callback 

.. code-block:: modula2

    PROCEDURE (this : Entry) OnChanged*();

.. _UI.Entry.IsReadOnly:

Entry.IsReadOnly
----------------

 Returns TRUE if the Entry is readonly 

.. code-block:: modula2

    PROCEDURE (this : Entry) IsReadOnly*(): BOOLEAN;

.. _UI.Entry.SetReadOnly:

Entry.SetReadOnly
-----------------

 Set Entry readonly flag 

.. code-block:: modula2

    PROCEDURE (this : Entry) SetReadOnly*(readonly : BOOLEAN);

.. _UI.InitEntry:

InitEntry
---------

 Initialize Entry 

.. code-block:: modula2

    PROCEDURE InitEntry*(e : Entry);

.. _UI.InitPasswordEntry:

InitPasswordEntry
-----------------

 Initialize password Entry 

.. code-block:: modula2

    PROCEDURE InitPasswordEntry*(e : Entry);

.. _UI.InitSearchEntry:

InitSearchEntry
---------------

 Initialize search Entry 

.. code-block:: modula2

    PROCEDURE InitSearchEntry*(e : Entry);

.. _UI.Label.Text:

Label.Text
----------

 Returns Label text 

.. code-block:: modula2

    PROCEDURE (this : Label) Text*(): String.STRING;

.. _UI.Label.SetText:

Label.SetText
-------------

 Set Label text 

.. code-block:: modula2

    PROCEDURE (this : Label) SetText*(text- : ARRAY OF CHAR);

.. _UI.InitLabel:

InitLabel
---------

 Initialize Label 

.. code-block:: modula2

    PROCEDURE InitLabel*(l : Label; text- : ARRAY OF CHAR);

.. _UI.Tab.Append:

Tab.Append
----------

 Appends a control in form of a page/tab with label. 

.. code-block:: modula2

    PROCEDURE (this : Tab) Append*(name- : ARRAY OF CHAR; control : Control);

.. _UI.Tab.InsertAt:

Tab.InsertAt
------------

 Inserts a control in form of a page/tab with label at index. 

.. code-block:: modula2

    PROCEDURE (this : Tab) InsertAt*(name- : ARRAY OF CHAR; index : LONGINT; control : Control);

.. _UI.Tab.Delete:

Tab.Delete
----------

 Removes the control at index. 

.. code-block:: modula2

    PROCEDURE (this : Tab) Delete*(index : LONGINT);

.. _UI.Tab.NumPages:

Tab.NumPages
------------

 Returns the number of pages contained. 

.. code-block:: modula2

    PROCEDURE (this : Tab) NumPages*(): LONGINT;

.. _UI.Tab.IsMargined:

Tab.IsMargined
--------------

 Returns whether or not the page/tab at index has a margin. 

.. code-block:: modula2

    PROCEDURE (this : Tab) IsMargined*(index : LONGINT): BOOLEAN;

.. _UI.Tab.SetMargined:

Tab.SetMargined
---------------

 Sets whether or not the page/tab at index has a margin. 

.. code-block:: modula2

    PROCEDURE (this : Tab) SetMargined*(index : LONGINT; margined : BOOLEAN);

.. _UI.InitTab:

InitTab
-------

 Initialize Tab 

.. code-block:: modula2

    PROCEDURE InitTab*(t : Tab);

.. _UI.Group.Title:

Group.Title
-----------

 Returns Group title 

.. code-block:: modula2

    PROCEDURE (this : Group) Title*(): String.STRING;

.. _UI.Label.SetTitle:

Label.SetTitle
--------------

 Set Group title 

.. code-block:: modula2

    PROCEDURE (this : Label) SetTitle*(title- : ARRAY OF CHAR);

.. _UI.Label.SetChild:

Label.SetChild
--------------

 Set child control 

.. code-block:: modula2

    PROCEDURE (this : Label) SetChild*(control : Control);

.. _UI.Label.IsMargined:

Label.IsMargined
----------------

 Returns TRUE if the control is margined 

.. code-block:: modula2

    PROCEDURE (this : Label) IsMargined*(): BOOLEAN;

.. _UI.Label.SetMargined:

Label.SetMargined
-----------------

 Set Window margined flag 

.. code-block:: modula2

    PROCEDURE (this : Label) SetMargined*(margined : BOOLEAN);

.. _UI.Spinbox.Value:

Spinbox.Value
-------------

 Returns the Spinbox value. 

.. code-block:: modula2

    PROCEDURE (this : Spinbox) Value*():LONGINT;

.. _UI.Spinbox.SetValue:

Spinbox.SetValue
----------------

 Sets the spinbox value. 

.. code-block:: modula2

    PROCEDURE (this : Spinbox) SetValue*(value : LONGINT);

.. _UI.Spinbox.OnChanged:

Spinbox.OnChanged
-----------------

 Entry change callback 

.. code-block:: modula2

    PROCEDURE (this : Spinbox) OnChanged*();

.. _UI.InitSpinbox:

InitSpinbox
-----------

 Initialize Spinbox 

.. code-block:: modula2

    PROCEDURE InitSpinbox*(s : Spinbox; min, max : LONGINT);

.. _UI.Slider.Value:

Slider.Value
------------

 Returns the Slider value. 

.. code-block:: modula2

    PROCEDURE (this : Slider) Value*():LONGINT;

.. _UI.Slider.SetValue:

Slider.SetValue
---------------

 Sets the Slider value. 

.. code-block:: modula2

    PROCEDURE (this : Slider) SetValue*(value : LONGINT);

.. _UI.Slider.HasToolTip:

Slider.HasToolTip
-----------------

 Returns whether or not the slider has a tool tip. 

.. code-block:: modula2

    PROCEDURE (this : Slider) HasToolTip*(): BOOLEAN;

.. _UI.Slider.SetHasToolTip:

Slider.SetHasToolTip
--------------------

 Sets whether or not the slider has a tool tip. 

.. code-block:: modula2

    PROCEDURE (this : Slider) SetHasToolTip*(hasToolTip : BOOLEAN);

.. _UI.Slider.OnChanged:

Slider.OnChanged
----------------

 Entry change callback 

.. code-block:: modula2

    PROCEDURE (this : Slider) OnChanged*();

.. _UI.Slider.OnReleased:

Slider.OnReleased
-----------------

 Callback for when the slider is released from dragging. 

.. code-block:: modula2

    PROCEDURE (this : Slider) OnReleased*();

.. _UI.Slider.SetRange:

Slider.SetRange
---------------

 Sets the slider range. 

.. code-block:: modula2

    PROCEDURE (this : Slider) SetRange*(min, max : LONGINT);

.. _UI.InitSlider:

InitSlider
----------

 Initialize Slider 

.. code-block:: modula2

    PROCEDURE InitSlider*(s : Slider; min, max : LONGINT);

.. _UI.ProgressBar.Value:

ProgressBar.Value
-----------------

 Returns the ProgressBar value. 

.. code-block:: modula2

    PROCEDURE (this : ProgressBar) Value*():LONGINT;

.. _UI.ProgressBar.SetValue:

ProgressBar.SetValue
--------------------

 Sets the ProgressBar value. 

.. code-block:: modula2

    PROCEDURE (this : ProgressBar) SetValue*(value : LONGINT);

.. _UI.InitProgressBar:

InitProgressBar
---------------

 Initialize ProgressBar 

.. code-block:: modula2

    PROCEDURE InitProgressBar*(p : ProgressBar);

.. _UI.InitHorizontalSeparator:

InitHorizontalSeparator
-----------------------

 Initialize horizontal separator. 

.. code-block:: modula2

    PROCEDURE InitHorizontalSeparator*(s : Separator);

.. _UI.InitVerticalSeparator:

InitVerticalSeparator
---------------------

 Initialize vertical separator. 

.. code-block:: modula2

    PROCEDURE InitVerticalSeparator*(s : Separator);

.. _UI.Combobox.Append:

Combobox.Append
---------------

 Appends an item to the combo box. 

.. code-block:: modula2

    PROCEDURE (this : Combobox) Append*(text- : ARRAY OF CHAR);

.. _UI.Combobox.InsertAt:

Combobox.InsertAt
-----------------

 Inserts an item at index to the combo box. 

.. code-block:: modula2

    PROCEDURE (this : Combobox) InsertAt*(index : LONGINT; text- : ARRAY OF CHAR);

.. _UI.Combobox.Delete:

Combobox.Delete
---------------

 Deletes an item at index from the combo box. 

.. code-block:: modula2

    PROCEDURE (this : Combobox) Delete*(index : LONGINT);

.. _UI.Combobox.Clear:

Combobox.Clear
--------------

 Deletes all items from the combo box. 

.. code-block:: modula2

    PROCEDURE (this : Combobox) Clear*;

.. _UI.Combobox.NumItems:

Combobox.NumItems
-----------------

 Returns the number of items contained within the combo box. 

.. code-block:: modula2

    PROCEDURE (this : Combobox) NumItems*():LONGINT;

.. _UI.Combobox.Selected:

Combobox.Selected
-----------------

 Returns the index of the item selected. 

.. code-block:: modula2

    PROCEDURE (this : Combobox) Selected*():LONGINT;

.. _UI.Combobox.SetSelected:

Combobox.SetSelected
--------------------

 Sets the item selected. 

.. code-block:: modula2

    PROCEDURE (this : Combobox) SetSelected*(index : LONGINT);

.. _UI.Combobox.OnSelected:

Combobox.OnSelected
-------------------

 Selected item callback 

.. code-block:: modula2

    PROCEDURE (this : Combobox) OnSelected*();

.. _UI.InitCombobox:

InitCombobox
------------

 Initialize Combobox 

.. code-block:: modula2

    PROCEDURE InitCombobox*(c : Combobox);

.. _UI.EditableCombobox.Append:

EditableCombobox.Append
-----------------------

 Appends an item to the editable combo box. 

.. code-block:: modula2

    PROCEDURE (this : EditableCombobox) Append*(text- : ARRAY OF CHAR);

.. _UI.EditableCombobox.Text:

EditableCombobox.Text
---------------------

 Returns the text of the editable combo box. 

.. code-block:: modula2

    PROCEDURE (this : EditableCombobox) Text*(): String.STRING;

.. _UI.EditableCombobox.SetText:

EditableCombobox.SetText
------------------------

 Sets the editable combo box text. 

.. code-block:: modula2

    PROCEDURE (this : EditableCombobox) SetText*(text- : ARRAY OF CHAR);

.. _UI.EditableCombobox.OnChanged:

EditableCombobox.OnChanged
--------------------------

 Editable combo box change callback 

.. code-block:: modula2

    PROCEDURE (this : EditableCombobox) OnChanged*();

.. _UI.InitEditableCombobox:

InitEditableCombobox
--------------------

 Initialize Combobox 

.. code-block:: modula2

    PROCEDURE InitEditableCombobox*(c : EditableCombobox);

.. _UI.RadioButtons.Append:

RadioButtons.Append
-------------------

 Appends a radio button. 

.. code-block:: modula2

    PROCEDURE (this : RadioButtons) Append*(text- : ARRAY OF CHAR);

.. _UI.RadioButtons.Selected:

RadioButtons.Selected
---------------------

 Returns the index of the item selected. 

.. code-block:: modula2

    PROCEDURE (this : RadioButtons) Selected*():LONGINT;

.. _UI.RadioButtons.SetSelected:

RadioButtons.SetSelected
------------------------

 Sets the item selected. 

.. code-block:: modula2

    PROCEDURE (this : RadioButtons) SetSelected*(index : LONGINT);

.. _UI.RadioButtons.OnSelected:

RadioButtons.OnSelected
-----------------------

 Selected item callback 

.. code-block:: modula2

    PROCEDURE (this : RadioButtons) OnSelected*();

.. _UI.InitRadioButtons:

InitRadioButtons
----------------

 Initialize RadioButtons 

.. code-block:: modula2

    PROCEDURE InitRadioButtons*(r : RadioButtons);

.. _UI.DateTimePicker.Time:

DateTimePicker.Time
-------------------

 Returns date and time stored in the data time picker. 

.. code-block:: modula2

    PROCEDURE (this : DateTimePicker) Time*():DateTime.DATETIME;

.. _UI.DateTimePicker.SetTime:

DateTimePicker.SetTime
----------------------

 Sets date and time of the data time picker. 

.. code-block:: modula2

    PROCEDURE (this : DateTimePicker) SetTime*(time : DateTime.DATETIME);

.. _UI.DateTimePicker.OnChanged:

DateTimePicker.OnChanged
------------------------

 DateTimePicker change callback 

.. code-block:: modula2

    PROCEDURE (this : DateTimePicker) OnChanged*();

.. _UI.InitDatePicker:

InitDatePicker
--------------

 Initialize a new date picker. 

.. code-block:: modula2

    PROCEDURE InitDatePicker*(d : DateTimePicker);

.. _UI.InitTimePicker:

InitTimePicker
--------------

 Initialize a new time picker. 

.. code-block:: modula2

    PROCEDURE InitTimePicker*(d : DateTimePicker);

.. _UI.InitDateTimePicker:

InitDateTimePicker
------------------

 Initialize a new date picker. 

.. code-block:: modula2

    PROCEDURE InitDateTimePicker*(d : DateTimePicker);

.. _UI.MultilineEntry.Text:

MultilineEntry.Text
-------------------

 Returns MultilineEntry text 

.. code-block:: modula2

    PROCEDURE (this : MultilineEntry) Text*(): String.STRING;

.. _UI.MultilineEntry.SetText:

MultilineEntry.SetText
----------------------

 Set MultilineEntry text 

.. code-block:: modula2

    PROCEDURE (this : MultilineEntry) SetText*(text- : ARRAY OF CHAR);

.. _UI.MultilineEntry.Append:

MultilineEntry.Append
---------------------

 Append MultilineEntry text 

.. code-block:: modula2

    PROCEDURE (this : MultilineEntry) Append*(text- : ARRAY OF CHAR);

.. _UI.MultilineEntry.OnChanged:

MultilineEntry.OnChanged
------------------------

 MultilineEntry change callback 

.. code-block:: modula2

    PROCEDURE (this : MultilineEntry) OnChanged*();

.. _UI.MultilineEntry.IsReadOnly:

MultilineEntry.IsReadOnly
-------------------------

 Returns TRUE if the MultilineEntry is readonly 

.. code-block:: modula2

    PROCEDURE (this : MultilineEntry) IsReadOnly*(): BOOLEAN;

.. _UI.MultilineEntry.SetReadOnly:

MultilineEntry.SetReadOnly
--------------------------

 Set MultilineEntry readonly flag 

.. code-block:: modula2

    PROCEDURE (this : MultilineEntry) SetReadOnly*(readonly : BOOLEAN);

.. _UI.InitMultilineEntry:

InitMultilineEntry
------------------

 Initialize a new MultilineEntry. 

.. code-block:: modula2

    PROCEDURE InitMultilineEntry*(e : MultilineEntry);

.. _UI.InitNonWrappingMultilineEntry:

InitNonWrappingMultilineEntry
-----------------------------

 Initialize a new non-wrapping MultilineEntry. 

.. code-block:: modula2

    PROCEDURE InitNonWrappingMultilineEntry*(e : MultilineEntry);

.. _UI.MenuItem.Enable:

MenuItem.Enable
---------------

 Enables the menu item. 

.. code-block:: modula2

    PROCEDURE (this : MenuItem) Enable*;

.. _UI.MenuItem.Disable:

MenuItem.Disable
----------------

 Menu item is grayed out and user interaction is not possible. 

.. code-block:: modula2

    PROCEDURE (this : MenuItem) Disable*;

.. _UI.MenuItem.IsChecked:

MenuItem.IsChecked
------------------

 Returns TRUE if the MenuItem is checked 

.. code-block:: modula2

    PROCEDURE (this : MenuItem) IsChecked*(): BOOLEAN;

.. _UI.MenuItem.SetChecked:

MenuItem.SetChecked
-------------------

 Set Checkbox MenuItem flag 

.. code-block:: modula2

    PROCEDURE (this : MenuItem) SetChecked*(checked : BOOLEAN);

.. _UI.MenuItem.OnClicked:

MenuItem.OnClicked
------------------

 MenuItem click callback 

.. code-block:: modula2

    PROCEDURE (this : MenuItem) OnClicked*();

.. _UI.Menu.AppendItem:

Menu.AppendItem
---------------

 Appends a generic menu item. 

.. code-block:: modula2

    PROCEDURE (this : Menu) AppendItem*(name- : ARRAY OF CHAR): MenuItem;

.. _UI.Menu.AppendCheckItem:

Menu.AppendCheckItem
--------------------

 Appends a generic menu item with a checkbox. 

.. code-block:: modula2

    PROCEDURE (this : Menu) AppendCheckItem*(name- : ARRAY OF CHAR): MenuItem;

.. _UI.Menu.AppendQuitItem:

Menu.AppendQuitItem
-------------------

 Appends a new `Quit` menu item. 

.. code-block:: modula2

    PROCEDURE (this : Menu) AppendQuitItem*(): MenuItem;

.. _UI.Menu.AppendPreferencesItem:

Menu.AppendPreferencesItem
--------------------------

 Appends a new `Preferences` menu item. 

.. code-block:: modula2

    PROCEDURE (this : Menu) AppendPreferencesItem*(): MenuItem;

.. _UI.Menu.AppendAboutItem:

Menu.AppendAboutItem
--------------------

 Appends a new `About` menu item. 

.. code-block:: modula2

    PROCEDURE (this : Menu) AppendAboutItem*(): MenuItem;

.. _UI.Menu.AppendSeparator:

Menu.AppendSeparator
--------------------

 Appends a new separator. 

.. code-block:: modula2

    PROCEDURE (this : Menu) AppendSeparator*;

.. _UI.InitMenu:

InitMenu
--------

 Initialize Menu 

.. code-block:: modula2

    PROCEDURE InitMenu*(m : Menu; name- : ARRAY OF CHAR);

.. _UI.Area.SetSize:

Area.SetSize
------------

--

.. code-block:: modula2

    PROCEDURE (this : Area) SetSize*(width : LONGINT; height : LONGINT);

.. _UI.Area.QueueRedrawAll:

Area.QueueRedrawAll
-------------------

.. code-block:: modula2

    PROCEDURE (this : Area) QueueRedrawAll*();

.. _UI.Area.Draw:

Area.Draw
---------

 Draw callback 

.. code-block:: modula2

    PROCEDURE (this : Area) Draw*(context : DrawContext);

.. _UI.Area.MouseEvent:

Area.MouseEvent
---------------

 MouseEvent callback 

.. code-block:: modula2

    PROCEDURE (this : Area) MouseEvent*(event : MouseEvent);

.. _UI.Area.MouseCrossed:

Area.MouseCrossed
-----------------

 MouseCrossed callback 

.. code-block:: modula2

    PROCEDURE (this : Area) MouseCrossed*(left : LONGINT);

.. _UI.Area.DragBroken:

Area.DragBroken
---------------

 DragBroken callback 

.. code-block:: modula2

    PROCEDURE (this : Area) DragBroken*();

.. _UI.Area.KeyEvent:

Area.KeyEvent
-------------

 MouseEvent callback 

.. code-block:: modula2

    PROCEDURE (this : Area) KeyEvent*(event : KeyEvent) : LONGINT;

.. _UI.InitArea:

InitArea
--------

 Initialize Area 

.. code-block:: modula2

    PROCEDURE InitArea*(a : Area);

.. _UI.InitScrollingArea:

InitScrollingArea
-----------------

 Initialize ScrollingArea 

.. code-block:: modula2

    PROCEDURE InitScrollingArea*(a : Area; width : LONGINT; height : LONGINT);

.. _UI.Path.Destroy:

Path.Destroy
------------

 Deallocate resources 

.. code-block:: modula2

    PROCEDURE (this : Path) Destroy*();

.. _UI.Path.NewFigure:

Path.NewFigure
--------------

.. code-block:: modula2

    PROCEDURE (this : Path) NewFigure*(x : LONGREAL; y : LONGREAL);

.. _UI.Path.NewFigureWithArc:

Path.NewFigureWithArc
---------------------

.. code-block:: modula2

    PROCEDURE (this : Path) NewFigureWithArc*(xCenter : LONGREAL; yCenter  : LONGREAL; radius : LONGREAL; startAngle : LONGREAL; sweep : LONGREAL; negative : BOOLEAN);

.. _UI.Path.LineTo:

Path.LineTo
-----------

.. code-block:: modula2

    PROCEDURE (this : Path) LineTo*(x : LONGREAL; y : LONGREAL);

.. _UI.Path.ArcTo:

Path.ArcTo
----------

.. code-block:: modula2

    PROCEDURE (this : Path) ArcTo*(xCenter : LONGREAL; yCenter  : LONGREAL; radius : LONGREAL; startAngle : LONGREAL; sweep : LONGREAL; negative : BOOLEAN);

.. _UI.Path.CloseFigure:

Path.CloseFigure
----------------

.. code-block:: modula2

    PROCEDURE (this : Path) CloseFigure*();

.. _UI.Path.AddRectangle:

Path.AddRectangle
-----------------

.. code-block:: modula2

    PROCEDURE (this : Path) AddRectangle*(x : LONGREAL; y : LONGREAL; width : LONGREAL; height : LONGREAL);

.. _UI.Path.IsEnded:

Path.IsEnded
------------

.. code-block:: modula2

    PROCEDURE (this : Path) IsEnded*() : BOOLEAN;

.. _UI.Path.End:

Path.End
--------

.. code-block:: modula2

    PROCEDURE (this : Path) End*();

.. _UI.InitPath:

InitPath
--------

 Initialize Path 

.. code-block:: modula2

    PROCEDURE InitPath*(dp : Path; fillMode := FillModeWinding : LONGINT);

.. _UI.InitSolidBrush:

InitSolidBrush
--------------

 Initialize Solid Brush 

.. code-block:: modula2

    PROCEDURE InitSolidBrush*(VAR brush : Brush; r, g, b : LONGREAL; a := 1.0 : LONGREAL);

.. _UI.InitStroke:

InitStroke
----------

 Initialize Stroke 

.. code-block:: modula2

    PROCEDURE InitStroke*(VAR stroke : Stroke; cap, join : LONGINT; thickness : LONGREAL);

.. _UI.Matrix.SetIdentity:

Matrix.SetIdentity
------------------

--

.. code-block:: modula2

    PROCEDURE (VAR this : Matrix) SetIdentity*();

.. _UI.Matrix.Translate:

Matrix.Translate
----------------

.. code-block:: modula2

    PROCEDURE (VAR this : Matrix) Translate*(x, y : LONGREAL);

.. _UI.Matrix.Scale:

Matrix.Scale
------------

.. code-block:: modula2

    PROCEDURE (VAR this : Matrix) Scale*(xCenter, yCenter, x, y : LONGREAL);

.. _UI.Matrix.Rotate:

Matrix.Rotate
-------------

.. code-block:: modula2

    PROCEDURE (VAR this : Matrix) Rotate*(x, y, amount : LONGREAL);

.. _UI.Matrix.Skew:

Matrix.Skew
-----------

.. code-block:: modula2

    PROCEDURE (VAR this : Matrix) Skew*(x, y, xamount, yamount : LONGREAL);

.. _UI.Matrix.Multiply:

Matrix.Multiply
---------------

.. code-block:: modula2

    PROCEDURE (VAR this : Matrix) Multiply*(VAR src : Matrix);

.. _UI.Matrix.IsInvertible:

Matrix.IsInvertible
-------------------

.. code-block:: modula2

    PROCEDURE (VAR this : Matrix) IsInvertible*() : BOOLEAN;

.. _UI.Matrix.Invert:

Matrix.Invert
-------------

.. code-block:: modula2

    PROCEDURE (VAR this : Matrix) Invert*() : BOOLEAN;

.. _UI.Matrix.TransformPoint:

Matrix.TransformPoint
---------------------

.. code-block:: modula2

    PROCEDURE (VAR this : Matrix) TransformPoint*(VAR x : LONGREAL; VAR y : LONGREAL);

.. _UI.Matrix.TransformSize:

Matrix.TransformSize
--------------------

.. code-block:: modula2

    PROCEDURE (VAR this : Matrix) TransformSize*(VAR x : LONGREAL; VAR y : LONGREAL);

.. _UI.DrawContext.Save:

DrawContext.Save
----------------

--

.. code-block:: modula2

    PROCEDURE (this : DrawContext) Save*();

.. _UI.DrawContext.Restore:

DrawContext.Restore
-------------------

.. code-block:: modula2

    PROCEDURE (this : DrawContext) Restore*();

.. _UI.DrawContext.Transform:

DrawContext.Transform
---------------------

.. code-block:: modula2

    PROCEDURE (this : DrawContext) Transform *(matrix- : Matrix);

.. _UI.DrawContext.Clip:

DrawContext.Clip
----------------

.. code-block:: modula2

    PROCEDURE (this : DrawContext) Clip*(path : Path);

.. _UI.DrawContext.Fill:

DrawContext.Fill
----------------

.. code-block:: modula2

    PROCEDURE (this : DrawContext) Fill*(path : Path; VAR b : Brush);

.. _UI.DrawContext.Stroke:

DrawContext.Stroke
------------------

.. code-block:: modula2

    PROCEDURE (this : DrawContext) Stroke*(path : Path; VAR b : Brush; VAR s : Stroke);

.. _UI.ColorButton.Color:

ColorButton.Color
-----------------

 Returns the color button color. 

.. code-block:: modula2

    PROCEDURE (this : ColorButton) Color*(VAR r : LONGREAL; VAR g : LONGREAL; VAR bl : LONGREAL; VAR a : LONGREAL);

.. _UI.ColorButton.SetColor:

ColorButton.SetColor
--------------------

 Sets the color button color. 

.. code-block:: modula2

    PROCEDURE (this : ColorButton) SetColor*(r, g, bl, a : LONGREAL);

.. _UI.ColorButton.OnChanged:

ColorButton.OnChanged
---------------------

 ColorButton change callback 

.. code-block:: modula2

    PROCEDURE (this : ColorButton) OnChanged*();

.. _UI.InitColorButton:

InitColorButton
---------------

 Initialize ColorButton 

.. code-block:: modula2

    PROCEDURE InitColorButton*(b : ColorButton);

.. _UI.Form.Append:

Form.Append
-----------

 Appends a control with a label to the form. 

.. code-block:: modula2

    PROCEDURE (this : Form) Append*(name- : ARRAY OF CHAR; control : Control; stretchy : BOOLEAN);

.. _UI.Form.NumChildren:

Form.NumChildren
----------------

 Returns the number of controls contained within the form. 

.. code-block:: modula2

    PROCEDURE (this : Form) NumChildren*(): LONGINT;

.. _UI.Form.Delete:

Form.Delete
-----------

 Removes the control at index from the form. 

.. code-block:: modula2

    PROCEDURE (this : Form) Delete*(index : LONGINT);

.. _UI.Form.IsPadded:

Form.IsPadded
-------------

 Returns whether or not controls within the form are padded. 

.. code-block:: modula2

    PROCEDURE (this : Form) IsPadded*(): BOOLEAN;

.. _UI.Form.SetPadded:

Form.SetPadded
--------------

 Sets whether or not controls within the box are padded. 

.. code-block:: modula2

    PROCEDURE (this : Form) SetPadded*(padded : BOOLEAN);

.. _UI.InitForm:

InitForm
--------

 Initialize Form 

.. code-block:: modula2

    PROCEDURE InitForm*(f : Form);

.. _UI.Grid.Append:

Grid.Append
-----------

 Appends a control to the grid. 

.. code-block:: modula2

    PROCEDURE (this : Grid) Append*(control : Control; left, top, xpan, yspan, hexpand, halign, vexpand, valign : LONGINT);

.. _UI.Grid.InsertAt:

Grid.InsertAt
-------------

 Inserts a control positioned in relation to another control within the grid. 

.. code-block:: modula2

    PROCEDURE (this : Grid) InsertAt*(control, existing : Control; at, xpan, yspan, hexpand, halign, vexpand, valign : LONGINT);

.. _UI.Grid.IsPadded:

Grid.IsPadded
-------------

 Returns whether or not controls within the grid are padded. 

.. code-block:: modula2

    PROCEDURE (this : Grid) IsPadded*(): BOOLEAN;

.. _UI.Grid.SetPadded:

Grid.SetPadded
--------------

 Sets whether or not controls within the grid are padded. 

.. code-block:: modula2

    PROCEDURE (this : Grid) SetPadded*(padded : BOOLEAN);

.. _UI.InitGrid:

InitGrid
--------

 Initialize Grid 

.. code-block:: modula2

    PROCEDURE InitGrid*(g : Grid);

.. _UI.Image.Append:

Image.Append
------------

 Appends a new image representation. 

.. code-block:: modula2

    PROCEDURE (this : Image) Append*(pixels- : ARRAY OF SYSTEM.BYTE; pixelWidth, pixelHeight, byteStride : LONGINT);

.. _UI.Image.Destroy:

Image.Destroy
-------------

 Deallocate resources 

.. code-block:: modula2

    PROCEDURE (this : Image) Destroy*();

.. _UI.InitImage:

InitImage
---------

 Initialize Image 

.. code-block:: modula2

    PROCEDURE InitImage*(i : Image; width, height :LONGREAL);

.. _UI.TableValue.GetType:

TableValue.GetType
------------------

 Gets the TableValue type. 

.. code-block:: modula2

    PROCEDURE (this : TableValue) GetType*(): LONGINT;

.. _UI.TableValue.Text:

TableValue.Text
---------------

 Returns the string value. 

.. code-block:: modula2

    PROCEDURE (this : TableValue) Text*(): String.STRING;

.. _UI.TableValue.Image:

TableValue.Image
----------------

 Returns the image value. 

.. code-block:: modula2

    PROCEDURE (this : TableValue) Image*(): Image;

.. _UI.TableValue.Int:

TableValue.Int
--------------

 Returns the integer value. 

.. code-block:: modula2

    PROCEDURE (this : TableValue) Int*(): LONGINT;

.. _UI.TableValue.Color:

TableValue.Color
----------------

 Returns the color value. 

.. code-block:: modula2

    PROCEDURE (this : TableValue) Color*(VAR r : LONGREAL; VAR g : LONGREAL; VAR b : LONGREAL; VAR a : LONGREAL);

.. _UI.InitTableValueString:

InitTableValueString
--------------------

 Creates a new table value to store a text string. 

.. code-block:: modula2

    PROCEDURE InitTableValueString*(tv : TableValue; str- : ARRAY OF CHAR);

.. _UI.InitTableValueImage:

InitTableValueImage
-------------------

 Creates a new table value to store an image. 

.. code-block:: modula2

    PROCEDURE InitTableValueImage*(tv : TableValue; img : Image);

.. _UI.InitTableValueInt:

InitTableValueInt
-----------------

 Creates a new table value to store an integer. 

.. code-block:: modula2

    PROCEDURE InitTableValueInt*(tv : TableValue; i : LONGINT);

.. _UI.InitTableValueColor:

InitTableValueColor
-------------------

 Creates a new table value to store a color in. 

.. code-block:: modula2

    PROCEDURE InitTableValueColor*(tv : TableValue; r, g, b, a : LONGREAL);

.. _UI.TableModel.Destroy:

TableModel.Destroy
------------------

 Frees the table model. 

.. code-block:: modula2

    PROCEDURE (this : TableModel) Destroy*();

.. _UI.TableModel.RowInserted:

TableModel.RowInserted
----------------------

 Informs all associated uiTable views that a new row has been added. 

.. code-block:: modula2

    PROCEDURE (this : TableModel) RowInserted*(newIndex : LONGINT);

.. _UI.TableModel.RowChanged:

TableModel.RowChanged
---------------------

 Informs all associated uiTable views that a row has been changed. 

.. code-block:: modula2

    PROCEDURE (this : TableModel) RowChanged*(index : LONGINT);

.. _UI.TableModel.RowDeleted:

TableModel.RowDeleted
---------------------

 Informs all associated uiTable views that a row has been deleted. 

.. code-block:: modula2

    PROCEDURE (this : TableModel) RowDeleted*(oldIndex : LONGINT);

.. _UI.TableModel.NumColumns:

TableModel.NumColumns
---------------------

 Returns the number of columns 

.. code-block:: modula2

    PROCEDURE (this : TableModel) NumColumns*(): LONGINT;

.. _UI.TableModel.TableValueType:

TableModel.TableValueType
-------------------------

 Returns the column type 

.. code-block:: modula2

    PROCEDURE (this : TableModel) TableValueType*(column : LONGINT): LONGINT;

.. _UI.TableModel.NumRows:

TableModel.NumRows
------------------

 Returns the number of columns 

.. code-block:: modula2

    PROCEDURE (this : TableModel) NumRows*(): LONGINT;

.. _UI.TableModel.CellValue:

TableModel.CellValue
--------------------

 Returns the cell value for (row, column). 

.. code-block:: modula2

    PROCEDURE (this : TableModel) CellValue*(row, column : LONGINT): TableValue;

.. _UI.TableModel.SetCellValue:

TableModel.SetCellValue
-----------------------

 Sets the cell value for (row, column). 

.. code-block:: modula2

    PROCEDURE (this : TableModel) SetCellValue*(row, column : LONGINT; value : TableValue);

.. _UI.InitTableModel:

InitTableModel
--------------

 Initialize TableModel 

.. code-block:: modula2

    PROCEDURE InitTableModel*(t : TableModel);

.. _UI.Table.AppendTextColumn:

Table.AppendTextColumn
----------------------

 Appends a text column to the table. 

.. code-block:: modula2

    PROCEDURE (this : Table) AppendTextColumn*(name : ARRAY OF CHAR; textModelColumn : LONGINT; textEditableModelColumn := TableModelColumnNeverEditable : LONGINT);

.. _UI.Table.AppendImageColumn:

Table.AppendImageColumn
-----------------------

 Appends an image column to the table. 

.. code-block:: modula2

    PROCEDURE (this : Table) AppendImageColumn*(name : ARRAY OF CHAR; imageModelColumn : LONGINT);

.. _UI.Table.AppendImageTextColumn:

Table.AppendImageTextColumn
---------------------------

 Appends a column to the table that displays both an image and text. 

.. code-block:: modula2

    PROCEDURE (this : Table) AppendImageTextColumn*(name : ARRAY OF CHAR; imageModelColumn : LONGINT; textModelColumn : LONGINT; textEditableModelColumn := TableModelColumnNeverEditable : LONGINT);

.. _UI.Table.AppendCheckboxColumn:

Table.AppendCheckboxColumn
--------------------------

 Appends a column to the table containing a checkbox. 

.. code-block:: modula2

    PROCEDURE (this : Table) AppendCheckboxColumn*(name : ARRAY OF CHAR; checkboxModelColumn : LONGINT; checkboxEditableModelColumn := TableModelColumnNeverEditable : LONGINT);

.. _UI.Table.AppendCheckboxTextColumn:

Table.AppendCheckboxTextColumn
------------------------------

 Appends a column to the table containing a checkbox and text. 

.. code-block:: modula2

    PROCEDURE (this : Table) AppendCheckboxTextColumn*(name : ARRAY OF CHAR; checkboxModelColumn : LONGINT; checkboxEditableModelColumn : LONGINT; textModelColumn : LONGINT; textEditableModelColumn : LONGINT);

.. _UI.Table.AppendProgressBarColumn:

Table.AppendProgressBarColumn
-----------------------------

 Appends a column to the table containing a progress bar. 

.. code-block:: modula2

    PROCEDURE (this : Table) AppendProgressBarColumn*(name : ARRAY OF CHAR; progressModelColumn : LONGINT);

.. _UI.Table.AppendButtonColumn:

Table.AppendButtonColumn
------------------------

 Appends a column to the table containing a button. 

.. code-block:: modula2

    PROCEDURE (this : Table) AppendButtonColumn*(name : ARRAY OF CHAR; buttonModelColumn : LONGINT; buttonClickableModelColumn : LONGINT);

.. _UI.Table.IsHeaderVisible:

Table.IsHeaderVisible
---------------------

 Returns whether or not the table header is visible. 

.. code-block:: modula2

    PROCEDURE (this : Table) IsHeaderVisible*(): BOOLEAN;

.. _UI.Table.SetHeaderVisible:

Table.SetHeaderVisible
----------------------

 Sets whether or not the table header is visible. 

.. code-block:: modula2

    PROCEDURE (this : Table) SetHeaderVisible*(visible : BOOLEAN);

.. _UI.Table.HeaderSortIndicator:

Table.HeaderSortIndicator
-------------------------

 Returns the column's sort indicator displayed in the table header. 

.. code-block:: modula2

    PROCEDURE (this : Table) HeaderSortIndicator*(column : LONGINT) : LONGINT;

.. _UI.Table.HeaderSetSortIndicator:

Table.HeaderSetSortIndicator
----------------------------

 Sets the column's sort indicator displayed in the table header. 

.. code-block:: modula2

    PROCEDURE (this : Table) HeaderSetSortIndicator*(column : LONGINT; indicator : LONGINT);

.. _UI.Table.ColumnWidth:

Table.ColumnWidth
-----------------

 Returns the table column width. 

.. code-block:: modula2

    PROCEDURE (this : Table) ColumnWidth*(column : LONGINT) : LONGINT;

.. _UI.Table.ColumnSetWidth:

Table.ColumnSetWidth
--------------------

 Sets the table column width. 

.. code-block:: modula2

    PROCEDURE (this : Table) ColumnSetWidth*(column : LONGINT; width : LONGINT);

.. _UI.InitTable:

InitTable
---------

 Initialize Table 

.. code-block:: modula2

    PROCEDURE InitTable*(t : Table ; tm : TableModel; RowBackgroundColorModelColumn := -1 : LONGINT);


Example
=======

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

