require "../../libui/libui.cr"

class ControlGallery

  # Note: @@mainwin is a class variable because
  # crystal does not support closures in C callbacks -- yet

  def initialize
    o = UI::InitOptions.new
    err = UI.init pointerof(o)
    if !uiNil?(err)
  		puts "error initializing ui: #{err}"
      exit 1
    end

    onClosing = ->(w: UI::Window*, data: Void*) {
      UI.controlDestroy uiControl(@@mainwin.not_nil!)
      UI.quit
      0
    }

    shouldquit = ->(data: Void*) {
      UI.controlDestroy uiControl(@@mainwin.not_nil!)
      1
    }

    openClicked = ->(item: UI::MenuItem*, w: UI::Window*, data: Void*) {
      mainwin = @@mainwin
      filename = UI.openFile mainwin
      if uiNil?(filename)
        UI.msgBoxError mainwin, "No file selected", "Don't be alarmed!"
      else
        UI.msgBox mainwin, "File selected", filename
        UI.freeText filename
      end
    }

    saveClicked = ->(item: UI::MenuItem*, w: UI::Window*, data: Void*) {
      mainwin = @@mainwin
      filename = UI.saveFile mainwin
      if uiNil?(filename)
        UI.msgBoxError mainwin, "No file selected", "Don't be alarmed!"
      else
      	UI.msgBox mainwin, "File selected (don't worry, it's still there)", filename
        UI.freeText filename
      end
    }

    onSpinboxChanged = ->(s: UI::Spinbox*, data: Void*) {
      value = UI.spinboxValue @@spinbox
      UI.sliderSetValue @@slider, value
      UI.progressBarSetValue @@progressbar, value
    }

    onSliderChanged = ->(s: UI::Slider*, data: Void*) {
      value = UI.sliderValue @@slider
      UI.spinboxSetValue @@spinbox, value
      UI.progressBarSetValue @@progressbar, value
    }

    menu = UI.newMenu "File"
    item = UI.menuAppendItem menu, "Open"
    UI.menuItemOnClicked item, openClicked, nil
    item = UI.menuAppendItem menu, "Save"
    UI.menuItemOnClicked item, saveClicked, nil
    item = UI.menuAppendQuitItem menu
    UI.onShouldQuit shouldquit, nil

    menu = UI.newMenu "Edit"
  	item = UI.menuAppendCheckItem menu, "Checkable Item"
  	UI.menuAppendSeparator menu
  	item = UI.menuAppendItem menu, "Disabled Item"
  	UI.menuItemDisable item
  	item = UI.menuAppendPreferencesItem menu

    menu = UI.newMenu "Help"
    item = UI.menuAppendItem menu, "Help"
    item = UI.menuAppendAboutItem menu

    @@mainwin = UI.newWindow "libui control gallery", 640, 480, 1
    mainwin = @@mainwin.not_nil!
    UI.windowSetMargined mainwin, 1
    UI.windowOnClosing mainwin, onClosing, nil

    box = UI.newVerticalBox
    UI.boxSetPadded box, 1
    UI.windowSetChild mainwin, uiControl(box)

    hbox = UI.newHorizontalBox
    UI.boxSetPadded hbox, 1
    UI.boxAppend box, uiControl(hbox), 1

    group = UI.newGroup "Basic Controls".to_unsafe
    UI.groupSetMargined group, 1
    UI.boxAppend hbox, uiControl(group), 0

    inner = UI.newVerticalBox
    UI.boxSetPadded inner, 1
    UI.groupSetChild group, uiControl(inner)

    UI.boxAppend inner, uiControl(UI.newButton("Button")), 0
    UI.boxAppend inner, uiControl(UI.newCheckbox("Checkbox")), 0
    entry = UI.newEntry
    UI.entrySetText entry, "Entry"
    UI.boxAppend inner, uiControl(entry), 0
    UI.boxAppend inner, uiControl(UI.newLabel "Label"), 0

    UI.boxAppend inner, uiControl(UI.newHorizontalSeparator), 0

    UI.boxAppend inner, uiControl(UI.newDatePicker), 0
    UI.boxAppend inner, uiControl(UI.newTimePicker), 0
    UI.boxAppend inner, uiControl(UI.newDateTimePicker), 0

    UI.boxAppend inner, uiControl(UI.newFontButton), 0
    UI.boxAppend inner, uiControl(UI.newColorButton), 0

    inner2 = UI.newVerticalBox
    UI.boxSetPadded inner2, 1
    UI.boxAppend hbox, uiControl(inner2), 1

    group = UI.newGroup "Numbers"
    UI.groupSetMargined group, 1
    UI.boxAppend inner2, uiControl(group), 0

    inner = UI.newVerticalBox
    UI.boxSetPadded inner, 1
    UI.groupSetChild group, uiControl(inner)

    @@spinbox = UI.newSpinbox 0, 100
    spinbox = @@spinbox.not_nil!
    UI.spinboxOnChanged spinbox, onSpinboxChanged, nil
    UI.boxAppend inner, uiControl(spinbox), 0

    @@slider = UI.newSlider 0, 100
    slider = @@slider.not_nil!
    UI.sliderOnChanged slider, onSliderChanged, nil
    UI.boxAppend inner, uiControl(slider), 0

    @@progressbar = UI.newProgressBar
    progressbar = @@progressbar.not_nil!
    UI.boxAppend inner, uiControl(progressbar), 0

  	group = UI.newGroup "Lists"
    UI.groupSetMargined group, 1
  	UI.boxAppend inner2, uiControl(group), 0

  	inner = UI.newVerticalBox
  	UI.boxSetPadded inner, 1
  	UI.groupSetChild group, uiControl(inner)

  	cbox = UI.newCombobox
  	UI.comboboxAppend cbox, "Combobox Item 1"
  	UI.comboboxAppend cbox, "Combobox Item 2"
  	UI.comboboxAppend cbox, "Combobox Item 3"
  	UI.boxAppend inner, uiControl(cbox), 0

  	cbox = UI.newEditableCombobox
  	UI.comboboxAppend cbox, "Editable Item 1"
  	UI.comboboxAppend cbox, "Editable Item 2"
  	UI.comboboxAppend cbox, "Editable Item 3"
  	UI.boxAppend inner, uiControl(cbox), 0

  	rb = UI.newRadioButtons
  	UI.radioButtonsAppend rb, "Radio Button 1"
  	UI.radioButtonsAppend rb, "Radio Button 2"
  	UI.radioButtonsAppend rb, "Radio Button 3"
  	UI.boxAppend inner, uiControl(rb), 1

  	tab = UI.newTab
  	UI.tabAppend tab, "Page 1", uiControl(UI.newHorizontalBox)
  	UI.tabAppend tab, "Page 2", uiControl(UI.newHorizontalBox)
  	UI.tabAppend tab, "Page 3", uiControl(UI.newHorizontalBox)
  	UI.boxAppend inner2, uiControl(tab), 1

    # -

    UI.controlShow uiControl(mainwin)

    UI.main
    UI.uninit
  end
end

ControlGallery.new
