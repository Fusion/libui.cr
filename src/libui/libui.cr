@[Link("ui")]

lib UI
  enum Align
    AlignFill
    AlignStart
    AlignCenter
    AlignEnd
  end

  enum At
    AtLeading
    AtTop
    AtTrailing
    AtBottom
  end

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
  type Form = Void*
  type Grid = Void*
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

  enum WindowResizeEdge
    WindowResizeEdgeLeft
    WindowResizeEdgeTop
    WindowResizeEdgeRight
    WindowResizeEdgeBottom
    WindowResizeEdgeTopLeft
    WindowResizeEdgeTopRight
    WindowResizeEdgeBottomLeft
    WindowResizeEdgeBottomRight
  end

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
    size : LibC::SizeT
  end

  # Life Cycle

  fun main = uiMain
  fun main_steps = uiMainSteps() : Void
  fun main_step = uiMainStep(wait : LibC::Int) : LibC::Int
  fun init = uiInit(options : UI::InitOptions*) : Char*
  fun uninit = uiUninit
  fun quit = uiQuit
  fun free_text = uiFreeText(text : UInt8*)
  fun free_init_error = uiFreeInitError(err : UInt8*)
  fun timer = uiTimer(milliseconds : LibC::Int, f : Void* ->, data : Void*) : Void
  fun on_should_quit = uiOnShouldQuit(f : Void* -> LibC::Int, data : Void*)

  # Components

  fun new_menu = uiNewMenu(name : UInt8*) : UI::Menu*
  fun menu_append_item = uiMenuAppendItem(m : UI::Menu*, name : UInt8*) : UI::MenuItem*
  fun menu_append_check_item = uiMenuAppendCheckItem(m : UI::Menu*, name : UInt8*) : UI::MenuItem*
  fun menu_append_quit_item = uiMenuAppendQuitItem(m : UI::Menu*) : UI::MenuItem*
  fun menu_append_preferences_item = uiMenuAppendPreferencesItem(m : UI::Menu*) : UI::MenuItem*
  fun menu_append_about_item = uiMenuAppendAboutItem(m : UI::Menu*) : UI::MenuItem*
  fun menu_append_separator = uiMenuAppendSeparator(m : UI::Menu*)

  fun menu_item_enable = uiMenuItemEnable(m : UI::MenuItem*)
  fun menu_item_disable = uiMenuItemDisable(m : UI::MenuItem*)
  fun menu_item_on_clicked = uiMenuItemOnClicked(m : UI::MenuItem*, f : UI::MenuItem*, UI::Window*, Void* ->, data : Void*)
  fun menu_item_checked = uiMenuItemChecked(m : UI::MenuItem*) : LibC::Int
  fun menu_item_set_checked = uiMenuItemSetChecked(m : UI::MenuItem*, checked : LibC::Int)
  fun menu_item_disable = uiMenuItemDisable(m : UI::MenuItem*)

  fun new_horizontal_separator = uiNewHorizontalSeparator : UI::Separator*

  fun new_window = uiNewWindow(title : UInt8*, width : LibC::Int, height : LibC::Int, hasMenubar : LibC::Int) : UI::Window*
  fun window_margined = uiWindowMargined(w : UI::Window*) : LibC::Int
  fun window_set_margined = uiWindowSetMargined(w : UI::Window*, margined : LibC::Int)
  fun window_content_size = uiWindowContentSize(w : UI::Window*, width : LibC::Int*, height : LibC::Int*)
  fun window_set_content_size = uiWindowSetContentSize(w : UI::Window*, width : LibC::Int, height : LibC::Int)
  fun window_fullscreen = uiWindowFullscreen(w : UI::Window*) : LibC::Int
  fun window_set_fullscreen = uiWindowSetFullscreen(w : UI::Window*, fullscreen : LibC::Int)
  fun window_on_content_size_changed = uiWindowOnContentSizeChanged(w : UI::Window*, f : UI::Window*, Void* ->, Void*)
  fun window_set_child = uiWindowSetChild(w : UI::Window*, child : UI::Control*)
  fun window_title = uiWindowTitle(w : UI::Window*) : UInt8*
  fun window_set_title = uiWindowSetTitle(w : UI::Window*, title : UInt8*)
  fun window_on_closing = uiWindowOnClosing(w : UI::Window*, f : UI::Window*, Void* -> LibC::Int, Void*)
  fun window_borderless = uiWindowBorderless(w : UI::Window*) : LibC::Int
  fun window_set_borderless = uiWindowSetBorderless(w : UI::Window*, borderless : LibC::Int)

  fun new_vertical_box = uiNewVerticalBox : UI::Box*
  fun new_horizontal_box = uiNewHorizontalBox : UI::Box*
  fun box_append = uiBoxAppend(b : UI::Box*, child : UI::Control*, stretchy : LibC::Int)
  fun box_delete = uiBoxDelete(b : UI::Box*, index : LibC::Int)
  fun box_padded = uiBoxPadded(b : UI::Box*) : LibC::Int
  fun box_set_padded = uiBoxSetPadded(b : UI::Box*, padded : LibC::Int)

  fun new_tab = uiNewTab : UI::Tab*
  fun tab_append = uiTabAppend(t : UI::Tab*, name : UInt8*, c : UI::Control*)
  fun tab_insert_at = uiTabInsertAt(t : UI::Tab*, name : UInt8*, before : UInt64, c : UI::Control*)
  fun tab_delete = uiTabDelete(t : UI::Tab*, index : UInt64)
  fun tab_num_pages = uiTabNumPages(t : UI::Tab*) : UInt64
  fun tab_margined = uiTabMargined(t : UI::Tab*, page : UInt64) : LibC::Int
  fun tab_set_margined = uiTabSetMargined(t : UI::Tab*, page : UInt64, margined : LibC::Int)

  fun new_group = uiNewGroup(title : UInt8*) : UI::Group*
  fun group_title = uiGroupTitle(g : UI::Group*) : UInt8*
  fun group_set_title = uiGroupSetTitle(g : UI::Group*, title : UInt8*)
  fun group_margined = uiGroupMargined(g : UI::Group*) : LibC::Int
  fun group_set_margined = uiGroupSetMargined(g : UI::Group*, margined : LibC::Int)
  fun group_set_child = uiGroupSetChild(g : UI::Group*, c : UI::Control*)

  fun msg_box = uiMsgBox(parent : UI::Window*, title : UInt8*, description : UInt8*)
  fun msg_box_error = uiMsgBoxError(parent : UI::Window*, title : UInt8*, description : UInt8*)

  fun open_file = uiOpenFile(parent : UI::Window*) : UInt8*
  fun save_file = uiSaveFile(parent : UI::Window*) : UInt8*

  fun new_button = uiNewButton(text : UInt8*) : UI::Button*
  fun button_text = uiButtonText(b : UI::Button*) : UInt8*
  fun button_set_text = uiButtonSetText(b : UI::Button*, text : UInt8*)
  fun button_on_clicked = uiButtonOnClicked(b : UI::Button*, f : UI::Button*, Void* ->, data : Void*)

  fun new_checkbox = uiNewCheckbox(text : UInt8*) : UI::Checkbox*
  fun checkbox_text = uiCheckboxText(c : UI::Checkbox*) : UInt8*
  fun checkbox_set_text = uiCheckboxSetText(c : UI::Checkbox*, text : UInt8*)
  fun checkbox_checked = uiCheckboxChecked(c : UI::Checkbox*) : LibC::Int
  fun checkbox_set_checked = uiCheckboxSetChecked(c : UI::Checkbox*, checked : LibC::Int)
  fun checkbox_on_toggled = uiCheckboxOnToggled(c : UI::Checkbox*, f : UI::Checkbox*, Void* ->, Void*)

  fun new_entry = uiNewEntry : UI::Entry*
  fun new_password_entry = uiNewPasswordEntry : UI::Entry*
  fun new_search_entry = uiNewSearchEntry : UI::Entry*

  fun entry_text = uiEntryText(e : UI::Entry*) : UInt8*
  fun entry_set_text = uiEntrySetText(e : UI::Entry*, text : UInt8*)
  fun entry_on_changed = uiEntryOnChanged(e : UI::Entry*, f : UI::Entry*, Void* ->, Void*)
  fun entry_read_only = uiEntryReadOnly(e : UI::Entry*) : LibC::Int
  fun entry_set_read_only = uiEntrySetReadOnly(e : UI::Entry*, readonly : LibC::Int)

  fun new_multiline_entry = uiNewMultilineEntry : UI::MultilineEntry*
  fun multiline_entry_text = uiMultilineEntryText(e : UI::MultilineEntry*) : UInt8*
  fun multiline_entry_set_text = uiMultilineEntrySetText(e : UI::MultilineEntry*, text : UInt8*)
  fun multiline_entry_append = uiMultilineEntryAppend(e : UI::MultilineEntry*, text : UInt8*)
  fun multiline_entry_on_changed = uiMultilineEntryOnChanged(e : UI::MultilineEntry*, f : UI::MultilineEntry*, Void* ->, Void*)
  fun multiline_entry_read_only = uiMultilineEntryReadOnly(e : UI::MultilineEntry*) : LibC::Int
  fun multiline_entry_set_read_only = uiMultilineEntrySetReadOnly(e : UI::MultilineEntry*, readonly : LibC::Int)

  fun new_label = uiNewLabel(text : UInt8*) : UI::Label*
  fun label_text = uiLabelText(l : UI::Label*) : UInt8*
  fun label_set_text = uiLabelSetText(l : UI::Label*, text : UInt8*)

  fun new_date_time_picker = uiNewDateTimePicker : UI::DateTimePicker*
  fun new_date_picker = uiNewDatePicker : UI::DateTimePicker*
  fun new_time_picker = uiNewTimePicker : UI::DateTimePicker*
  fun date_time_picker_time = uiDateTimePickerTime(d : UI::DateTimePicker*, tm : LibC::Tm*)
  fun date_time_picker_set_time = uiDateTimePickerSetTime(d : UI::DateTimePicker*, tm : LibC::Tm*)
  fun date_time_picker_on_changed = uiDateTimePickerOnChanged(d : UI::DateTimePicker*, f : UI::DateTimePicker*, Void* ->, data : Void*)

  fun new_spinbox = uiNewSpinbox(min : Int64, max : Int64) : UI::Spinbox*
  fun spinbox_value = uiSpinboxValue(s : UI::Spinbox*) : Int64
  fun spinbox_set_value = uiSpinboxSetValue(s : UI::Spinbox*, value : Int64)
  fun spinbox_on_changed = uiSpinboxOnChanged(s : UI::Spinbox*, f : UI::Spinbox*, Void* ->, Void*)

  fun new_progress_bar = uiNewProgressBar : UI::ProgressBar*
  fun progress_bar_value = uiProgressBarValue(p : UI::ProgressBar*) : LibC::Int
  fun progress_bar_set_value = uiProgressBarSetValue(p : UI::ProgressBar*, n : LibC::Int)

  fun new_slider = uiNewSlider(min : Int64, max : Int64) : UI::Slider*
  fun slider_value = uiSliderValue(s : UI::Slider*) : Int64
  fun slider_set_value = uiSliderSetValue(s : UI::Slider*, value : Int64)
  fun slider_on_changed = uiSliderOnChanged(s : UI::Slider*, f : UI::Slider*, Void* ->, Void*)

  fun new_combobox = uiNewCombobox : UI::Combobox*
  fun combobox_append = uiComboboxAppend(c : UI::Combobox*, text : UInt8*)
  fun combobox_selected = uiComboboxSelected(c : UI::Combobox*) : Int64
  fun combobox_set_selected = uiComboboxSetSelected(c : UI::Combobox*, n : Int64)
  fun combobox_on_selected = uiComboboxOnSelected(c : UI::Combobox*, f : UI::Combobox*, Void* ->, Void*)

  fun new_editable_combobox = uiNewEditableCombobox : UI::EditableCombobox*
  fun editable_combobox_append = uiEditableComboboxAppend(c : UI::EditableCombobox*, text : UInt8*)
  fun editable_combobox_text = uiEditableComboboxText(c : UI::EditableCombobox*) : UInt8*
  fun editable_combobox_set_text = uiEditableComboboxSetText(c : UI::EditableCombobox*, text : UInt8*)
  fun editable_combobox_on_changed = uiEditableComboboxOnChanged(c : UI::EditableCombobox*, f : UI::Combobox*, Void* ->, Void*)

  fun new_radio_buttons = uiNewRadioButtons : UI::RadioButtons*
  fun radio_buttons_append = uiRadioButtonsAppend(r : UI::RadioButtons*, text : UInt8*)
  fun radio_buttons_selected = uiRadioButtonsSelected(r : UI::RadioButtons*) : LibC::Int
  fun radio_buttons_set_selected = uiRadioButtonsSetSelected(r : UI::RadioButtons*, n : LibC::Int)
  fun radio_buttons_on_selected = uiRadioButtonsOnSelected(r : UI::RadioButtons*, f : UI::RadioButtons*, Void* ->, Void*)

  fun new_font_button = uiNewFontButton : UI::FontButton*
  fun font_button_font = uiFontButtonFont(b : UI::FontButton*) : UI::DrawTextFont*
  fun font_button_on_changed = uiFontButtonOnChanged(b : UI::FontButton*, f : UI::FontButton*, Void* ->, Void*)

  fun new_color_button = uiNewColorButton : UI::ColorButton*
  fun color_button_color = uiColorButtonColor(b : UI::ColorButton*, r : LibC::Double, g : LibC::Double, bl : LibC::Double, a : LibC::Double)
  fun color_button_set_color = uiColorButtonSetColor(b : UI::ColorButton*, r : LibC::Double, g : LibC::Double, bl : LibC::Double, a : LibC::Double)
  fun color_button_on_changed = uiColorButtonOnChanged(b : UI::ColorButton*, f : UI::ColorButton*, Void* ->, Void*)

  fun new_form = uiNewForm : UI::Form*
  fun form_append = uiFormAppend(f : UI::Form*, label : UInt8*, c : UI::Control*, stretchy : LibC::Int)
  fun form_delete = uiFormDelete(f : UI::Form*, index : LibC::Int)
  fun form_padded = uiFormPadded(f : UI::Form*) : LibC::Int
  fun form_set_padded = uiFormSetPadded(f : UI::Form*, padded : LibC::Int)

  fun new_grid = uiNewGrid : UI::Grid*
  fun grid_append = uiGridAppend(g : UI::Grid*, c : UI::Control*, left : LibC::Int, top : LibC::Int, xpan : LibC::Int, yspan : LibC::Int, hexpand : LibC::Int, halign : UI::Align, vexpand : LibC::Int, valign : UI::Align)
  fun grid_insert_at = uiGridInsertAt(g : UI::Grid*, c : UI::Control*, existing : UI::Control*, at : UI::At, xspan : LibC::Int, yspan : LibC::Int, hexpand : LibC::Int, halign : UI::Align, vexpand : LibC::Int, valign : UI::Align)
  fun grid_padded = uiGridPadded(g : UI::Grid*) : LibC::Int
  fun grid_set_padded = uiGridSetPadded(g : UI::Grid*, padded : LibC::Int)

  # Low Level

  fun new_area = uiNewArea(ah : UI::AreaHandler*) : UI::Area*
  fun new_scrolling_area = uiNewScrollingArea(ah : UI::AreaHandler*, width : Int64, height : Int64) : UI::Area*
  fun area_set_size = uiAreaSetSize(a : UI::Area*, width : Int64, height : Int64)
  fun area_queue_redrawal = uiAreaQueueRedrawAll(a : UI::Area*)
  fun area_scroll_to = uiAreaScrollTo(a : UI::Area*, x : LibC::Double, y : LibC::Double, width : LibC::Double, height : LibC::Double)
  fun area_begin_user_window_move = uiAreaBeginUserWindowMove(a : UI::Area*)
  fun area_begin_user_window_resize = uiAreaBeginUserWindowResize(a : UI::Area*, edge : WindowResizeEdge)

  fun draw_path = uiDrawNewPath(fillMode : UI::DrawFillMode) : UI::DrawPath*
  fun draw_free_path = uiDrawFreePath(p : UI::DrawPath*)
  fun draw_path_new_figure = uiDrawPathNewFigure(p : UI::DrawPath*, x : LibC::Double, y : LibC::Double)
  fun draw_path_new_figure_with_arc = uiDrawPathNewFigureWithArc(p : UI::DrawPath*, xCenter : LibC::Double, yCenter : LibC::Double, radius : LibC::Double, startAngle : LibC::Double, sweep : LibC::Double, negative : LibC::Int)
  fun draw_path_line_to = uiDrawPathLineTo(p : UI::DrawPath*, x : LibC::Double, y : LibC::Double)
  fun draw_path_arc_to = uiDrawPathArcTo(p : UI::DrawPath*, xCenter : LibC::Double*, yCenter : LibC::Double*, radius : LibC::Double, startAngle : LibC::Double, sweep : LibC::Double, negative : LibC::Int)
  fun draw_path_bezier_to = uiDrawPathBezierTo(p : UI::DrawPath*, c1x : LibC::Double, c1y : LibC::Double, c2x : LibC::Double, c2y : LibC::Double, endX : LibC::Double, endY : LibC::Double)
  fun draw_path_close_figure = uiDrawPathCloseFigure(p : UI::DrawPath*)
  fun draw_path_add_rectangle = uiDrawPathAddRectangle(p : UI::DrawPath*, x : LibC::Double, y : LibC::Double, width : LibC::Double, height : LibC::Double)
  fun draw_path_end = uiDrawPathEnd(p : UI::DrawPath*)
  fun draw_path_stroke = uiDrawStroke(c : UI::DrawContext*, path : UI::DrawPath*, b : UI::DrawBrush*, p : UI::DrawStrokeParams*)
  fun draw_fill = uiDrawFill(c : UI::DrawContext*, path : UI::DrawPath*, b : UI::DrawBrush*)
  fun draw_matrix_set_identity = uiDrawMatrixSetIdentity(m : UI::DrawMatrix*)
  fun draw_matrix_translate = uiDrawMatrixTranslate(m : UI::DrawMatrix*, x : LibC::Double, y : LibC::Double)
  fun draw_matrix_scale = uiDrawMatrixScale(m : UI::DrawMatrix*, xCenter : LibC::Double*, yCenter : LibC::Double*, x : LibC::Double, y : LibC::Double)
  fun draw_matrix_rotate = uiDrawMatrixRotate(m : UI::DrawMatrix*, x : LibC::Double, y : LibC::Double, amount : LibC::Double)
  fun draw_matrix_skew = uiDrawMatrixSkew(m : UI::DrawMatrix*, x : LibC::Double, y : LibC::Double, xamount : LibC::Double, yamount : LibC::Double)
  fun draw_matrix_multiply = uiDrawMatrixMultiply(dest : UI::DrawMatrix*, src : UI::DrawMatrix*)
  fun draw_matrix_invertible = uiDrawMatrixInvertible(m : UI::DrawMatrix*) : LibC::Int
  fun draw_matrix_invert = uiDrawMatrixInvert(m : UI::DrawMatrix*) : LibC::Int
  fun draw_matrix_transform_point = uiDrawMatrixTransformPoint(m : UI::DrawMatrix*, x : LibC::Double*, y : LibC::Double*)
  fun draw_matrix_transform_size = uiDrawMatrixTransformSize(m : UI::DrawMatrix*, x : LibC::Double*, y : LibC::Double*)
  fun draw_transform = uiDrawTransform(c : UI::DrawContext*, m : UI::DrawMatrix*)
  fun draw_clip = uiDrawClip(c : UI::DrawContext*, path : UI::DrawPath*)
  fun draw_save = uiDrawSave(c : UI::DrawContext*)
  fun draw_restore = uiDrawRestore(c : UI::DrawContext*)
  fun draw_font_families = uiDrawListFontFamilies : UI::DrawFontFamilies*
  fun draw_font_families_num_families = uiDrawFontFamiliesNumFamilies(ff : UI::DrawFontFamilies*) : UInt64
  fun draw_font_families_familiy = uiDrawFontFamiliesFamily(ff : UI::DrawFontFamilies*, n : UInt64) : UInt8*
  fun draw_free_font_families = uiDrawFreeFontFamilies(ff : UI::DrawFontFamilies*)
  fun draw_load_closest_font = uiDrawLoadClosestFont(desc : UI::DrawTextFontDescriptor*) : UI::DrawTextFont*
  fun draw_free_text_font = uiDrawFreeTextFont(font : UI::DrawTextFont*)
  fun draw_text_font_handle = uiDrawTextFontHandle(font : UI::DrawTextFont*) : UInt64
  fun draw_text_font_describe = uiDrawTextFontDescribe(font : UI::DrawTextFont*, desc : UI::DrawTextFontDescriptor*)
  fun draw_text_font_get_metrics = uiDrawTextFontGetMetrics(font : UI::DrawTextFont*, metrics : UI::DrawTextFontMetrics*)
  fun drawNew_text_layout = uiDrawNewTextLayout(text : UInt8*, defaultFont : UI::DrawTextFont*, width : LibC::Double) : UI::DrawTextLayout*
  fun drawFree_text_layout = uiDrawFreeTextLayout(layout : UI::DrawTextLayout*)
  fun draw_text_layout_set_width = uiDrawTextLayoutSetWidth(layout : UI::DrawTextLayout*, width : LibC::Double)
  fun draw_text_layout_extents = uiDrawTextLayoutExtents(layout : UI::DrawTextLayout*, width : LibC::Double*, height : LibC::Double*)
  fun draw_text_layout_set_color = uiDrawTextLayoutSetColor(layout : UI::DrawTextLayout*, startChar : Int64, endChar : Int64, r : LibC::Double, g : LibC::Double, b : LibC::Double, a : LibC::Double)
  fun draw_text = uiDrawText(c : UI::DrawContext*, x : LibC::Double, y : LibC::Double, layout : UI::DrawTextLayout*)

  # Generic Control Handling

  fun alloc_control = uiAllocControl(n : LibC::SizeT, ossig : LibC::Int, typesig : LibC::Int, typenamestr : UInt8*) : UI::Control*
  fun free_control = uiFreeControl(c : UI::Control*)
  fun control_verify_destroy = uiControlVerifyDestroy(c : UI::Control*)
  fun control_verify_set_parent = uiControlVerifySetParent(c : UI::Control*, p : UI::Control*)
  fun control_enabled_to_user = uiControlEnabledToUser(c : UI::Control*) : LibC::Int
  fun control_show = uiControlShow(c : UI::Control*)
  fun control_destroy = uiControlDestroy(c : UI::Control*)
  fun control_handle = uiControlHandle(c : UI::Control*) : UInt64
  fun control_parent = uiControlParent(c : UI::Control*) : UI::Control*
  fun control_set_parent = uiControlSetParent(c : UI::Control*, p : UI::Control*)
  fun control_top_level = uiControlToplevel(c : UI::Control*) : LibC::Int
  fun control_visible = uiControlVisible(c : UI::Control*) : LibC::Int
  fun control_show = uiControlShow(c : UI::Control*)
  fun control_hide = uiControlHide(c : UI::Control*)
  fun control_enabled = uiControlEnabled(c : UI::Control*) : LibC::Int
  fun control_enable = uiControlEnable(c : UI::Control*)
  fun control_disable = uiControlDisable(c : UI::Control*)
end

# Some Sugar

macro ui_control(control)
  {{control}}.as(UI::Control*)
end

macro ui_box(control)
  {{control}}.as(UI::Box*)
end

macro ui_nil?(ptr)
  {{ptr}}.null?
end
