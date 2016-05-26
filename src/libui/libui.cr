@[Link("ui")]

lib UI
  type Menu = Void*
  type MenuItem = Void*
  type Window = Void*
  type Control = Void*
  type Separator = Void*
  type Box = Void*
  type Tab = Void*
  type Group = Void*
  type Button = Void*
  type Checkbox = Void*
  type Entry = Void*
  type MultilineEntry = Void*
  type Label = Void*
  type DateTimePicker = Void*
  type Spinbox = Void*
  type ProgressBar = Void*
  type Slider = Void*
  type Combobox = Void*
  type EditableCombobox = Void*
  type RadioButtons = Void*
  type FontButton = Void*
  type ColorButton = Void*
  type DrawTextFont = Void*
  type Area = Void*
  type AreaHandler = Void*

  enum DrawFillMode
  	DrawFillModeWinding
  	DrawFillModeAlternate
  end

  type DrawPath = Void*
  type DrawContext = Void*
  type DrawBrush = Void*
  type DrawStrokeParams = Void*
  type DrawFontFamilies = Void*
  type DrawTextFontDescriptor = Void*
  type DrawTextFontMetrics = Void*
  type DrawTextLayout = Void*
  type DrawMatrix = Void*

# TODO This actual structure (and more) although not necessary unless debugging

#  struct uiControl {
#  	uint32_t Signature;
#  	uint32_t OSSignature;
#  	uint32_t TypeSignature;
#  	void (*Destroy)(c: UI::Control*);
#  	uintptr_t (*Handle)(c: UI::Control*);
#  	c: UI::Control*(*Parent)(uiControl *);
#  	void (*SetParent)(c: UI::Control*, uiControl *);
#  	int (*Toplevel)(c: UI::Control*);
#  	int (*Visible)(c: UI::Control*);
#  	void (*Show)(c: UI::Control*);
#  	void (*Hide)(c: UI::Control*);
#  	int (*Enabled)(c: UI::Control*);
#  	void (*Enable)(c: UI::Control*);
#  	void (*Disable)(c: UI::Control*);
#  };

  struct InitOptions
    size: LibC::SizeT
  end

  # Life Cycle
  
  fun main = uiMain
  fun mainStep = uiMainStep(wait: LibC::Int): LibC::Int
  fun init = uiInit(options: UI::InitOptions*): Char*
  fun uninit = uiUninit
  fun quit = uiQuit
  fun freeText = uiFreeText(text: UInt8*)
  fun freeInitError = uiFreeInitError(err: UInt8*)

  # Components

  fun newMenu = uiNewMenu(name: UInt8*): UI::Menu*
  fun menuAppendItem = uiMenuAppendItem(m: UI::Menu*, name: UInt8*): UI::MenuItem*
  fun menuAppendCheckItem = uiMenuAppendCheckItem(m: UI::Menu*, name: UInt8*): UI::MenuItem*
  fun menuItemOnClicked = uiMenuItemOnClicked(m: UI::MenuItem*, f: UI::MenuItem*, UI::Window*, Void* ->, data: Void*)
  fun menuAppendQuitItem = uiMenuAppendQuitItem(m: UI::Menu*): UI::MenuItem*
  fun menuAppendPreferencesItem = uiMenuAppendPreferencesItem(m: UI::Menu*): UI::MenuItem*
  fun menuAppendAboutItem = uiMenuAppendAboutItem(m: UI::Menu*): UI::MenuItem*
  fun menuAppendSeparator = uiMenuAppendSeparator(m: UI::Menu*)
  fun onShouldQuit = uiOnShouldQuit(f: Void* -> LibC::Int, data: Void*)
  fun menuItemDisable = uiMenuItemDisable(m: UI::MenuItem*)

  fun menuItemEnable = uiMenuItemEnable(m: UI::MenuItem*)
  fun menuItemDisable = uiMenuItemDisable(m: UI::MenuItem*)
  fun menuItemOnClicked = uiMenuItemOnClicked(m: UI::MenuItem*, f: UI::MenuItem*, UI::Window*, Void* ->, Void*)
  fun menuItemChecked = uiMenuItemChecked(m: UI::MenuItem*): LibC::Int
  fun menuItemSetChecked = uiMenuItemSetChecked(m: UI::MenuItem*, checked: LibC::Int)

  fun newHorizontalSeparator = uiNewHorizontalSeparator: UI::Separator*

  fun newWindow = uiNewWindow(title: UInt8*, width: LibC::Int, height: LibC::Int, hasMenubar: LibC::Int): UI::Window*
  fun windowSetMargined = uiWindowSetMargined(w: UI::Window*, margined: LibC::Int)
  fun windowMargined = uiWindowMargined(w: UI::Window*): LibC::Int
  fun windowSetChild = uiWindowSetChild(w: UI::Window*, child: UI::Control*)
  fun windowTitle = uiWindowTitle(w: UI::Window*): UInt8*
  fun windowSetTiele = uiWindowSetTitle(w: UI::Window*, title: UInt8*)
  fun windowOnClosing = uiWindowOnClosing(w: UI::Window*, f: UI::Window*, Void* -> LibC::Int, Void*)

  fun newVerticalBox = uiNewVerticalBox: UI::Box*
  fun newHorizontalBox = uiNewHorizontalBox: UI::Box*
  fun boxAppend = uiBoxAppend(b: UI::Box*, child: UI::Control*, stretchy: LibC::Int)
  fun boxDelete = uiBoxDelete(b: UI::Box*, index: LibC::Int)
  fun boxSetPadded = uiBoxSetPadded(b: UI::Box*, padded: LibC::Int)
  fun boxPadded = uiBoxPadded(b: UI::Box*): LibC::Int

  fun newTab = uiNewTab: UI::Tab*
  fun tabAppend = uiTabAppend(t: UI::Tab*, name: UInt8*, c: UI::Control*)
  fun tabInsertAt = uiTabInsertAt(t: UI::Tab*, name: UInt8*, before: UInt64, c: UI::Control*)
  fun tabDelete = uiTabDelete(t: UI::Tab*, index: UInt64)
  fun tabNumPages = uiTabNumPages(t: UI::Tab*): UInt64
  fun tabMargined = uiTabMargined(t: UI::Tab*, page: UInt64): LibC::Int
  fun tabSetMargined = uiTabSetMargined(t: UI::Tab*, page: UInt64, margined: LibC::Int)

  fun newGroup = uiNewGroup(title: UInt8*): UI::Group*
  fun groupTitle = uiGroupTitle(g: UI::Group*): UInt8*
  fun groupSetTitle = uiGroupSetTitle(g: UI::Group*, title: UInt8*)
  fun groupSetMargined = uiGroupSetMargined(g: UI::Group*, margined: LibC::Int)
  fun groupMargined = uiGroupMargined(g: UI::Group*): LibC::Int
  fun groupSetChild = uiGroupSetChild(g: UI::Group*, c: UI::Control*)

  fun msgBox = uiMsgBox(parent: UI::Window*, title: UInt8*, description: UInt8*)
  fun msgBoxError = uiMsgBoxError(parent: UI::Window*, title: UInt8*, description: UInt8*)

  fun openFile = uiOpenFile(parent: UI::Window*): UInt8*
  fun saveFile = uiSaveFile(parent: UI::Window*): UInt8*

  fun newButton = uiNewButton(text: UInt8*): UI::Button*
  fun buttonText = uiButtonText(b: UI::Button*): UInt8*
  fun buttonSetText = uiButtonSetText(b: UI::Button*, text: UInt8*)
  fun buttonOnClicked = uiButtonOnClicked(b: UI::Button*, f: UI::Button*, Void* ->, data: Void*)

  fun newCheckbox = uiNewCheckbox(text: UInt8*): UI::Checkbox*
  fun checkboxText = uiCheckboxText(c: UI::Checkbox*): UInt8*
  fun checkboxSetText = uiCheckboxSetText(c: UI::Checkbox*, text: UInt8*)
  fun checkboxOnToggled = uiCheckboxOnToggled(c: UI::Checkbox*, f: UI::Checkbox*, Void* ->, Void*)
  fun checkboxChecked = uiCheckboxChecked(c: UI::Checkbox*): LibC::Int
  fun checkboxSetChecked = uiCheckboxSetChecked(c: UI::Checkbox*, checked: LibC::Int)

  fun newEntry = uiNewEntry: UI::Entry*
  fun entrySetText = uiEntrySetText(e: UI::Entry*, text: UInt8*)
  fun entryTest = uiEntryText(e: UI::Entry*): UInt8*
  fun entryOnChanged = uiEntryOnChanged(e: UI::Entry*, f: UI::Entry*, Void* ->, Void*)
  fun entryReadOnly = uiEntryReadOnly(e: UI::Entry*): LibC::Int
  fun entrySetReadOnly = uiEntrySetReadOnly(e: UI::Entry*, readonly: LibC::Int)

  fun multilineEntry = uiNewMultilineEntry: UI::MultilineEntry*
  fun multilineEntryText = uiMultilineEntryText(e: UI::MultilineEntry*): UInt8*
  fun multilineEntrySetText = uiMultilineEntrySetText(e: UI::MultilineEntry*, text: UInt8*)
  fun multilineEntryAppend = uiMultilineEntryAppend(e: UI::MultilineEntry*, text: UInt8*)
  fun multilineEntryOnChanged = uiMultilineEntryOnChanged(e: UI::MultilineEntry*, f: UI::MultilineEntry*, Void* ->, Void*)
  fun multilineEntryReadOnly = uiMultilineEntryReadOnly(e: UI::MultilineEntry*): LibC::Int
  fun multilineEntrySetReadOnly = uiMultilineEntrySetReadOnly(e: UI::MultilineEntry*, readonly: LibC::Int)

  fun newLabel = uiNewLabel(text: UInt8*): UI::Label*
  fun labelText = uiLabelText(l: UI::Label*): UInt8*
  fun labelSetText = uiLabelSetText(l: UI::Label*, text: UInt8*)

  fun newDateTimePicker = uiNewDateTimePicker: UI::DateTimePicker*
  fun newDatePicker = uiNewDatePicker: UI::DateTimePicker*
  fun newTimePicker = uiNewTimePicker: UI::DateTimePicker*

  fun newSpinbox = uiNewSpinbox(min: Int64, max: Int64): UI::Spinbox*
  fun spinboxValue = uiSpinboxValue(s: UI::Spinbox*): Int64
  fun spinboxSetValue = uiSpinboxSetValue(s: UI::Spinbox*, value: Int64)
  fun spinboxOnChanged = uiSpinboxOnChanged(s: UI::Spinbox*, f: UI::Spinbox*, Void* ->, Void*)

  fun newProgressBar = uiNewProgressBar: UI::ProgressBar*
  fun progressBarSetValue = uiProgressBarSetValue(p: UI::ProgressBar*, n: LibC::Int)

  fun newSlider = uiNewSlider(min: Int64, max: Int64): UI::Slider*
  fun sliderValue = uiSliderValue(s: UI::Slider*): Int64
  fun sliderSetValue = uiSliderSetValue(s: UI::Slider*, value: Int64)
  fun sliderOnChanged = uiSliderOnChanged(s: UI::Slider*, f: UI::Slider*, Void* ->, Void*)

  fun newCombobox = uiNewCombobox: UI::Combobox*
  fun comboboxAppend = uiComboboxAppend(c: UI::Combobox*, text: UInt8*)
  fun comboboxSelected = uiComboboxSelected(c: UI::Combobox*): Int64
  fun comboboxSetSelected = uiComboboxSetSelected(c: UI::Combobox*, n: Int64)
  fun comboboxOnSelected = uiComboboxOnSelected(c: UI::Combobox*, f: UI::Combobox*, Void* ->, Void*)

  fun newEditableCombobox = uiNewEditableCombobox: UI::EditableCombobox*
  fun editableComboboxAppend = uiEditableComboboxAppend(c: UI::EditableCombobox*, text: UInt8*)
  fun editableComboboxText = uiEditableComboboxText(c: UI::EditableCombobox*): UInt8*
  fun editableComboboxSetText = uiEditableComboboxSetText(c: UI::EditableCombobox*, text: UInt8*)
  fun editableComboboxOnChanged = uiEditableComboboxOnChanged(c: UI::EditableCombobox*, f: UI::Combobox*, Void* ->, Void*)

  fun newRadioButtons = uiNewRadioButtons: UI::RadioButtons*
  fun radioButtonsAppend = uiRadioButtonsAppend(r: UI::RadioButtons*, text: UInt8*)

  fun newFontButton = uiNewFontButton: UI::FontButton*
  fun fontButtonFont = uiFontButtonFont(b: UI::FontButton*): UI::DrawTextFont*
  fun fontButtonOnChanged = uiFontButtonOnChanged(b: UI::FontButton*, f: UI::FontButton*, Void* ->, Void*)

  fun newColorButton = uiNewColorButton: UI::ColorButton*
  fun colorButtonColor = uiColorButtonColor(b: UI::ColorButton*, r: LibC::Double, g: LibC::Double, bl: LibC::Double, a: LibC::Double)
  fun colorButtonSetColor = uiColorButtonSetColor(b: UI::ColorButton*, r: LibC::Double, g: LibC::Double, bl: LibC::Double, a: LibC::Double)
  fun colorButtonOnChanged = uiColorButtonOnChanged(b: UI::ColorButton*, f: UI::ColorButton*, Void* ->, Void*)

  # Low Level

  fun newArea = uiNewArea(ah: UI::AreaHandler*): UI::Area*
  fun newScrollingArea = uiNewScrollingArea(ah: UI::AreaHandler*, width: Int64, height: Int64): UI::Area*
  fun areaSetSize = uiAreaSetSize(a: UI::Area*, width: Int64, height: Int64)
  fun areaQueueRedrawal = uiAreaQueueRedrawAll(a: UI::Area*)
  fun areaScrollTo = uiAreaScrollTo(a: UI::Area*, x: LibC::Double, y: LibC::Double, width: LibC::Double, height: LibC::Double)

  fun drawPath = uiDrawNewPath(fillMode: UI::DrawFillMode): UI::DrawPath*
  fun drawFreePath = uiDrawFreePath(p: UI::DrawPath*)
  fun drawPathNewFigure = uiDrawPathNewFigure(p: UI::DrawPath*, x: LibC::Double, y: LibC::Double)
  fun drawPathNewfigureWithArc = uiDrawPathNewFigureWithArc(p: UI::DrawPath*, xCenter: LibC::Double, yCenter: LibC::Double, radius: LibC::Double, startAngle: LibC::Double, sweep: LibC::Double, negative: LibC::Int)
  fun drawPathLineTo = uiDrawPathLineTo(p: UI::DrawPath*, x: LibC::Double, y: LibC::Double)
  fun drawPathArcTo = uiDrawPathArcTo(p: UI::DrawPath*, xCenter: LibC::Double*, yCenter: LibC::Double*, radius: LibC::Double, startAngle: LibC::Double, sweep: LibC::Double, negative: LibC::Int)
  fun drawPathBezierTo = uiDrawPathBezierTo(p: UI::DrawPath*, c1x: LibC::Double, c1y: LibC::Double, c2x: LibC::Double, c2y: LibC::Double, endX: LibC::Double, endY: LibC::Double)
  fun drawPathCloseFigure = uiDrawPathCloseFigure(p: UI::DrawPath*)
  fun drawPathAddRectangle = uiDrawPathAddRectangle(p: UI::DrawPath*, x: LibC::Double, y: LibC::Double, width: LibC::Double, height: LibC::Double)
  fun drawPathEnd = uiDrawPathEnd(p: UI::DrawPath*)
  fun drawPathStroke = uiDrawStroke(c: UI::DrawContext*, path: UI::DrawPath*, b: UI::DrawBrush*, p: UI::DrawStrokeParams*)
  fun drawFill = uiDrawFill(c: UI::DrawContext*, path: UI::DrawPath*, b: UI::DrawBrush*)
  fun drawMatrixSetIdentity = uiDrawMatrixSetIdentity(m: UI::DrawMatrix*)
  fun drawMatrixTranslate = uiDrawMatrixTranslate(m: UI::DrawMatrix*, x: LibC::Double, y: LibC::Double)
  fun drawMatrixScale = uiDrawMatrixScale(m: UI::DrawMatrix*, xCenter: LibC::Double*, yCenter: LibC::Double*, x: LibC::Double, y: LibC::Double)
  fun drawMatrixRotate = uiDrawMatrixRotate(m: UI::DrawMatrix*, x: LibC::Double, y: LibC::Double, amount: LibC::Double)
  fun drawMatrixSkew =  uiDrawMatrixSkew(m: UI::DrawMatrix*, x: LibC::Double, y: LibC::Double, xamount: LibC::Double, yamount: LibC::Double)
  fun drawMatrixMultiply = uiDrawMatrixMultiply(dest: UI::DrawMatrix*, src: UI::DrawMatrix*)
  fun drawMatrixInvertible = uiDrawMatrixInvertible(m: UI::DrawMatrix*): LibC::Int
  fun drawMatrixInvert =  uiDrawMatrixInvert(m: UI::DrawMatrix*): LibC::Int
  fun drawMatrixTransformPoint = uiDrawMatrixTransformPoint(m: UI::DrawMatrix*, x: LibC::Double*, y: LibC::Double*)
  fun drawMatrixTransformSize = uiDrawMatrixTransformSize(m: UI::DrawMatrix*, x: LibC::Double*, y: LibC::Double*)
  fun drawTransform = uiDrawTransform(c: UI::DrawContext*, m: UI::DrawMatrix*)
  fun drawClip = uiDrawClip(c: UI::DrawContext*, path: UI::DrawPath*)
  fun drawSave = uiDrawSave(c: UI::DrawContext*)
  fun drawRestore = uiDrawRestore(c: UI::DrawContext*)
  fun drawFontFamilies = uiDrawListFontFamilies: UI::DrawFontFamilies*
  fun drawFontFamiliesNumFamilies = uiDrawFontFamiliesNumFamilies(ff: UI::DrawFontFamilies*): UInt64
  fun drawFontFamiliesFamiliy = uiDrawFontFamiliesFamily(ff: UI::DrawFontFamilies*, n: UInt64): UInt8*
  fun drawFreeFrontFamilies = uiDrawFreeFontFamilies(ff: UI::DrawFontFamilies*)
  fun drawLoadClosestFont = uiDrawLoadClosestFont(desc: UI::DrawTextFontDescriptor*): UI::DrawTextFont*
  fun drawFreeTextFont = uiDrawFreeTextFont(font: UI::DrawTextFont*)
  fun drawTextFontHandle = uiDrawTextFontHandle(font: UI::DrawTextFont*): UInt64
  fun drawTextFontDescribe = uiDrawTextFontDescribe(font: UI::DrawTextFont*, desc: UI::DrawTextFontDescriptor*)
  fun drawTextFontGetMetrics = uiDrawTextFontGetMetrics(font: UI::DrawTextFont*, metrics: UI::DrawTextFontMetrics*)
  fun drawNewTextLayout = uiDrawNewTextLayout(text: UInt8*, defaultFont: UI::DrawTextFont*, width: LibC::Double): UI::DrawTextLayout*
  fun drawFreeTextLayout = uiDrawFreeTextLayout(layout: UI::DrawTextLayout*)
  fun drawTextLayoutSetWidth = uiDrawTextLayoutSetWidth(layout: UI::DrawTextLayout*, width: LibC::Double)
  fun drawTextLayoutExtents = uiDrawTextLayoutExtents(layout: UI::DrawTextLayout*, width: LibC::Double*, height: LibC::Double*);
  fun drawTextLayoutSetColor = uiDrawTextLayoutSetColor(layout: UI::DrawTextLayout*, startChar: Int64, endChar: Int64, r: LibC::Double, g: LibC::Double, b: LibC::Double, a: LibC::Double)
  fun drawText = uiDrawText(c: UI::DrawContext*, x: LibC::Double, y: LibC::Double, layout: UI::DrawTextLayout*)

  # Generic Control Handling

  fun allocControl = uiAllocControl(n: LibC::SizeT, ossig: LibC::Int, typesig: LibC::Int, typenamestr: UInt8*): UI::Control*
  fun freeControl = uiFreeControl(c: UI::Control*)
  fun controlVerifyDestroy = uiControlVerifyDestroy(c: UI::Control*)
  fun controlVerifySetParent = uiControlVerifySetParent(c: UI::Control*, p: UI::Control*)
  fun controlEnabledToUser = uiControlEnabledToUser(c: UI::Control*): LibC::Int
  fun controlShow = uiControlShow(c: UI::Control*)
  fun controlDestroy = uiControlDestroy(c: UI::Control*)
  fun controlHandle = uiControlHandle(c: UI::Control*): UInt64
  fun controlParent = uiControlParent(c: UI::Control*): UI::Control*
  fun controlSetParent = uiControlSetParent(c: UI::Control*, p: UI::Control*)
  fun controlTopLevel = uiControlToplevel(c: UI::Control*): LibC::Int
  fun controlVisible = uiControlVisible(c: UI::Control*): LibC::Int
  fun controlShow = uiControlShow(c: UI::Control*)
  fun controlHide = uiControlHide(c: UI::Control*)
  fun controlEnabled = uiControlEnabled(c: UI::Control*): LibC::Int
  fun controlEnable = uiControlEnable(c: UI::Control*)
  fun controlDisable = uiControlDisable(c: UI::Control*)
end


# Some Sugar

macro uiControl(control)
  {{control}} as UI::Control*
end

macro uiNil?(ptr)
  {{ptr}}.null?
end
