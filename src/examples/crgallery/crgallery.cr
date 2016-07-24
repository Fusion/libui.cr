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

    CUI.menubar "src/examples/crgallery/gallery.yml"

    top_components = CUI.inflate "src/examples/crgallery/main.yml"
    container = CUI.get! "contains_children"

    basic_controls = CUI.inflate "src/examples/crgallery/basic_controls.yml"
    basic_controls.each do |basic_control|
      UI.box_append container as UI::Box*, basic_control, 0
    end

    other_controls = CUI.inflate "src/examples/crgallery/other_controls.yml"
    other_controls.each do |other_control|
      UI.box_append container as UI::Box*, other_control, 0
    end

    top_components.each do |component|
      UI.control_show ui_control component
    end

    UI.menu_item_on_clicked \
      CUI.get_as_menuitem("open"),
      ->(item: UI::MenuItem*, w: UI::Window*, data: Void*) {
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

    UI.menu_item_on_clicked \
      CUI.get_as_menuitem("save"),
      ->(item: UI::MenuItem*, w: UI::Window*, data: Void*) {
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

    UI.on_should_quit \
      ->(data: Void*) {
        UI.control_destroy ui_control CUI.get_mainwindow!
        1
      },
      nil

    UI.window_on_closing \
      CUI.get_mainwindow!,
      ->(w: UI::Window*, data: Void*) {
        UI.control_destroy ui_control CUI.get_mainwindow!
        UI.quit
        0
      },
      nil

    UI.main
    UI.uninit
  end
end

CRGallery.new
