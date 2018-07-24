require "../lib/libui/src/libui.cr"

class ControlGallery
  # Note: @@mainwin is a class variable because
  # crystal does not support closures in C callbacks -- yet

  def initialize
    o = UI::InitOptions.new
    err = UI.init pointerof(o)
    if !ui_nil?(err)
      puts "error initializing ui: #{err}"
      exit 1
    end

    on_closing = ->(w : UI::Window*, data : Void*) {
      UI.control_destroy ui_control(@@mainwin.not_nil!)
      UI.quit
      0
    }

    should_quit = ->(data : Void*) {
      UI.control_destroy ui_control(@@mainwin.not_nil!)
      1
    }

    open_clicked = ->(item : UI::MenuItem*, w : UI::Window*, data : Void*) {
      mainwin = @@mainwin
      filename = UI.open_file mainwin
      if ui_nil?(filename)
        UI.msg_box_error mainwin, "No file selected", "Don't be alarmed!"
      else
        UI.msg_box mainwin, "File selected", filename
        UI.free_text filename
      end
    }

    save_clicked = ->(item : UI::MenuItem*, w : UI::Window*, data : Void*) {
      mainwin = @@mainwin
      filename = UI.save_file mainwin
      if ui_nil?(filename)
        UI.msg_box_error mainwin, "No file selected", "Don't be alarmed!"
      else
        UI.msg_box mainwin, "File selected (don't worry, it's still there)", filename
        UI.free_text filename
      end
    }

    on_spinbox_changed = ->(s : UI::Spinbox*, data : Void*) {
      value = UI.spinbox_value @@spinbox
      UI.slider_set_value @@slider, value
      UI.progress_bar_set_value @@progressbar, value
    }

    on_slider_changed = ->(s : UI::Slider*, data : Void*) {
      value = UI.slider_value @@slider
      UI.spinbox_set_value @@spinbox, value
      UI.progress_bar_set_value @@progressbar, value
    }

    menu = UI.new_menu "File"
    item = UI.menu_append_item menu, "Open"
    UI.menu_item_on_clicked item, open_clicked, nil
    item = UI.menu_append_item menu, "Save"
    UI.menu_item_on_clicked item, save_clicked, nil
    item = UI.menu_append_quit_item menu
    UI.on_should_quit should_quit, nil

    menu = UI.new_menu "Edit"
    item = UI.menu_append_check_item menu, "Checkable Item"
    UI.menu_append_separator menu
    item = UI.menu_append_item menu, "Disabled Item"
    UI.menu_item_disable item
    item = UI.menu_append_preferences_item menu

    menu = UI.new_menu "Help"
    item = UI.menu_append_item menu, "Help"
    item = UI.menu_append_about_item menu

    @@mainwin = UI.new_window "libui control gallery", 640, 480, 1
    mainwin = @@mainwin.not_nil!
    UI.window_set_margined mainwin, 1
    UI.window_on_closing mainwin, on_closing, nil

    box = UI.new_vertical_box
    UI.box_set_padded box, 1
    UI.window_set_child mainwin, ui_control(box)

    hbox = UI.new_horizontal_box
    UI.box_set_padded hbox, 1
    UI.box_append box, ui_control(hbox), 1

    group = UI.new_group "Basic Controls".to_unsafe
    UI.group_set_margined group, 1
    UI.box_append hbox, ui_control(group), 0

    inner = UI.new_vertical_box
    UI.box_set_padded inner, 1
    UI.group_set_child group, ui_control(inner)

    UI.box_append inner, ui_control(UI.new_button("Button")), 0
    UI.box_append inner, ui_control(UI.new_checkbox("Checkbox")), 0
    entry = UI.new_entry
    UI.entry_set_text entry, "Entry"
    UI.box_append inner, ui_control(entry), 0
    UI.box_append inner, ui_control(UI.new_label "Label"), 0

    UI.box_append inner, ui_control(UI.new_horizontal_separator), 0

    UI.box_append inner, ui_control(UI.new_date_picker), 0
    UI.box_append inner, ui_control(UI.new_time_picker), 0
    UI.box_append inner, ui_control(UI.new_date_time_picker), 0

    UI.box_append inner, ui_control(UI.new_font_button), 0
    UI.box_append inner, ui_control(UI.new_color_button), 0

    inner2 = UI.new_vertical_box
    UI.box_set_padded inner2, 1
    UI.box_append hbox, ui_control(inner2), 1

    group = UI.new_group "Numbers"
    UI.group_set_margined group, 1
    UI.box_append inner2, ui_control(group), 0

    inner = UI.new_vertical_box
    UI.box_set_padded inner, 1
    UI.group_set_child group, ui_control(inner)

    @@spinbox = UI.new_spinbox 0, 100
    spinbox = @@spinbox.not_nil!
    UI.spinbox_on_changed spinbox, on_spinbox_changed, nil
    UI.box_append inner, ui_control(spinbox), 0

    @@slider = UI.new_slider 0, 100
    slider = @@slider.not_nil!
    UI.slider_on_changed slider, on_slider_changed, nil
    UI.box_append inner, ui_control(slider), 0

    @@progressbar = UI.new_progress_bar
    progressbar = @@progressbar.not_nil!
    UI.box_append inner, ui_control(progressbar), 0

    group = UI.new_group "Lists"
    UI.group_set_margined group, 1
    UI.box_append inner2, ui_control(group), 0

    inner = UI.new_vertical_box
    UI.box_set_padded inner, 1
    UI.group_set_child group, ui_control(inner)

    cbox = UI.new_combobox
    UI.combobox_append cbox, "Combobox Item 1"
    UI.combobox_append cbox, "Combobox Item 2"
    UI.combobox_append cbox, "Combobox Item 3"
    UI.box_append inner, ui_control(cbox), 0

    ecbox = UI.new_editable_combobox
    UI.editable_combobox_append ecbox, "Editable Item 1"
    UI.editable_combobox_append ecbox, "Editable Item 2"
    UI.editable_combobox_append ecbox, "Editable Item 3"
    UI.box_append inner, ui_control(ecbox), 0

    rb = UI.new_radio_buttons
    UI.radio_buttons_append rb, "Radio Button 1"
    UI.radio_buttons_append rb, "Radio Button 2"
    UI.radio_buttons_append rb, "Radio Button 3"
    UI.box_append inner, ui_control(rb), 1

    tab = UI.new_tab
    UI.tab_append tab, "Page 1", ui_control(UI.new_horizontal_box)
    UI.tab_append tab, "Page 2", ui_control(UI.new_horizontal_box)
    UI.tab_append tab, "Page 3", ui_control(UI.new_horizontal_box)
    UI.box_append inner2, ui_control(tab), 1

    # -

    UI.control_show ui_control(mainwin)

    UI.main
    UI.uninit
  end
end

ControlGallery.new
