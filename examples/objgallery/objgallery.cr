require "../../src/libui/libui.cr"
require "../../src/libui/cui.cr"

class OBJGallery
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
      UI.control_destroy ui_control CUI.get_mainwindow!
      UI.quit
      0
    }
    menu = CUI::Menu.new "File"
    menu.append("Open", ->(item : UI::MenuItem*, w : UI::Window*, data : Void*) {
      filename = CUI::OpenFile.new.filename
      if ui_nil?(filename)
        CUI::MsgBox.new "No file selected", "Don't be alarmed!", CUI::MsgBoxType::Error
      else
        CUI::MsgBox.new "File selected", filename
      end
    }, nil)
    menu.append("Save", ->(item : UI::MenuItem*, w : UI::Window*, data : Void*) {
      filename = CUI::SaveFile.new.filename
      if ui_nil?(filename)
        CUI::MsgBox.new "No file selected", "Don't be alarmed!", CUI::MsgBoxType::Error
      else
        CUI::MsgBox.new "File selected (don't worry, it's still there)", filename
      end
    }, nil)
    menu.append "Quit", nil, nil, CUI::MenuDesc::Quit.value

    menu = CUI::Menu.new "Edit"
    menu.append "Checkable Item", nil, nil, CUI::MenuDesc::Check.value
    menu.append "Disabled Item", nil, nil, CUI::MenuDesc::Disabled.value
    menu.append "Preferences", nil, nil, CUI::MenuDesc::Preferences.value

    menu = CUI::Menu.new "Help"
    menu.append "Help"
    menu.append "About", nil, nil, CUI::MenuDesc::About.value

    @@mainwin = UI.new_window "libui control gallery", 640, 480, 1
    mainwin = @@mainwin.not_nil!
    UI.window_set_margined mainwin, 1
    UI.window_on_closing mainwin, on_closing, nil

    CUI.attach_main_window mainwin # necessary to use objects

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

    # -

    UI.control_show ui_control(mainwin)

    UI.main
    UI.uninit
  end
end

OBJGallery.new
