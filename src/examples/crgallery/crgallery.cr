require "../../libui/libui.cr"
require "../../libui/cui.cr"

class CRGallery
  def initialize
    o = UI::InitOptions.new
    err = UI.init pointerof(o)
    if !ui_nil?(err)
      puts "error initializing ui: #{err}"
      exit 1
    end

    # ----------------------------------------------------------------------------
    # Create menubar entries. Note that YAML files can contain menubar and
    # controls and we will pick the right root.
    # ----------------------------------------------------------------------------
    CUI.menubar File.join(__DIR__, "main.yml")

    # ----------------------------------------------------------------------------
    # Create main window and content. Children will be added to
    # appropriate component (retrieved using its name)
    # ----------------------------------------------------------------------------
    top_components = CUI.inflate File.join(__DIR__, "main.yml")
    container = CUI.get!("contains_children").as(UI::Box*)

    # ----------------------------------------------------------------------------
    # This file describes basic controls. No fancy bindings here.
    # ----------------------------------------------------------------------------
    basic_controls = CUI.inflate File.join(__DIR__, "basic_controls.yml")
    basic_controls.each do |basic_control|
      UI.box_append container, basic_control.component, 1
    end

    # ----------------------------------------------------------------------------
    # These will be more advanced controls. Note how we will use late bindings
    # in order to avoid playing with not yet realized components.
    # ----------------------------------------------------------------------------
    other_controls = CUI.inflate File.join(__DIR__, "other_controls.yml")
    other_controls.each do |other_control|
      UI.box_append container, other_control.component, 1
    end

    # ----------------------------------------------------------------------------
    # Attach a few tabs to this last group
    # ----------------------------------------------------------------------------
    a_few_tabs = CUI.inflate File.join(__DIR__, "tabs.yml")
    tabs = UI.new_tab
    UI.tab_append tabs, "Page 1", CUI.get! "tab1"
    UI.tab_append tabs, "Page 2", CUI.get! "tab2"
    UI.tab_append tabs, "Page 3", CUI.get! "tab3"
    UI.box_append ui_box(CUI.get! "vertical_children"), ui_control(tabs), 1

    # ----------------------------------------------------------------------------
    # Attach to display now. Avoid flicker.
    # ----------------------------------------------------------------------------
    top_components.each do |component|
      UI.control_show ui_control component.component
    end

    # ----------------------------------------------------------------------------
    # All bindings
    # ----------------------------------------------------------------------------

    UI.menu_item_on_clicked CUI.get_as_menuitem("open"),
      ->(item : UI::MenuItem*, w : UI::Window*, data : Void*) {
        mainwin = CUI.get_mainwindow!
        filename = UI.open_file mainwin
        if ui_nil?(filename)
          UI.msg_box_error mainwin, "No file selected", "Don't be alarmed!"
        else
          UI.msg_box mainwin, "File selected", filename
          UI.free_text filename
        end
      },
      nil

    UI.menu_item_on_clicked CUI.get_as_menuitem("save"),
      ->(item : UI::MenuItem*, w : UI::Window*, data : Void*) {
        mainwin = CUI.get_mainwindow!
        filename = UI.save_file mainwin
        if ui_nil?(filename)
          UI.msg_box_error mainwin, "No file selected", "Don't be alarmed!"
        else
          UI.msg_box mainwin, "File selected (don't worry, it's still there)", filename
          UI.free_text filename
        end
      },
      nil

    UI.on_should_quit ->(data : Void*) {
      UI.control_destroy ui_control CUI.get_mainwindow!
      1
    },
      nil

    UI.window_on_closing CUI.get_mainwindow!,
      ->(w : UI::Window*, data : Void*) {
        UI.control_destroy ui_control CUI.get_mainwindow!
        UI.quit
        0
      },
      nil

    UI.spinbox_on_changed CUI.get!("spinbox").as(UI::Spinbox*),
      ->(s : UI::Spinbox*, data : Void*) {
        value = UI.spinbox_value CUI.get!("spinbox").as(UI::Spinbox*)
        UI.slider_set_value CUI.get!("slider").as(UI::Slider*), value
        UI.progress_bar_set_value CUI.get!("progress_bar").as(UI::ProgressBar*), value
      },
      nil

    UI.slider_on_changed CUI.get!("slider").as(UI::Slider*),
      ->(s : UI::Slider*, data : Void*) {
        value = UI.slider_value CUI.get!("slider").as(UI::Slider*)
        UI.spinbox_set_value CUI.get!("spinbox").as(UI::Spinbox*), value
        UI.progress_bar_set_value CUI.get!("progress_bar").as(UI::ProgressBar*), value
      },
      nil

    UI.main
    UI.uninit
  end
end

CRGallery.new
