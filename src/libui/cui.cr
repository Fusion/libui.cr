require "yaml"

alias UIComponent = UI::Control* | Nil

module CUI
  extend self

  class Exception < Exception
  end

  class ComponentWrapper
    getter component, attributes

    def initialize(@component : UI::Control*, @attributes : Hash(String, String))
    end
  end

  # Disabled was added as syntactic sugar for when using objects
  enum MenuDesc
    Enabled     = 2 << 0
    Check       = 2 << 1
    Quit        = 2 << 2
    Preferences = 2 << 3
    About       = 2 << 4
    Separator   = 2 << 5
    Disabled    = 2 << 6
  end

  def init : Boolean
    o = UI::InitOptions.new
    err = UI.init pointerof(o)
    if !uiNil?(err)
      return false
    end
    true
  end

  private def idx_component(name : String, component : UI::Control*)
    @@compIdx ||= Hash(String, UI::Control*).new
    @@compIdx.not_nil![name] = component
  end

  def get(name : String) : UI::Control* | Nil
    return nil if @@compIdx.nil?
    compIdx = @@compIdx.not_nil!
    return compIdx[name] if compIdx.has_key?(name)
    nil
  end

  def get!(name : String) : UI::Control*
    m = get name
    raise CUI::Exception.new "Not found: #{name}" if m.is_a?(Nil)
    m
  end

  def get_as_menuitem(name : String) : UI::MenuItem* | Nil
    m = get name
    return nil if m.is_a?(Nil)
    m.as(UI::MenuItem*)
  end

  def get_as_menuitem!(name : String) : UI::MenuItem*
    (get! name).as(UI::MenuItem*)
  end

  def get_mainwindow : UI::Window* | Nil
    m = get "sys::mainwindow"
    return nil if m.is_a?(Nil)
    m.as UI::Window*
  end

  def get_mainwindow! : UI::Window*
    (get! "sys::mainwindow").as(UI::Window*)
  end

  # ----------------------------------------------------------------------------
  # Create and add components: windows, dialogs, etc.
  # ----------------------------------------------------------------------------

  private def rewrite_type_this_is_a_hack!(type, attributes)
    return "editable_combobox" if type == "combobox" && attributes.has_key?("editable") && attributes["editable"] == "true"
    type
  end

  # Window logic is as follow:
  # First window met becomes main -- later on we may override using 'main' or what not
  private def spawn_component(type, name, text, attributes) : UIComponent
    component = nil
    case type
    when "window"
      attributes["width"] ||= "640"
      attributes["height"] ||= "480"
      attributes["hasMenubar"] ||= "0"
      attributes["margin"] ||= "0"
      raw_component = UI.new_window text.to_s, attributes["width"].to_i, attributes["height"].to_i, attributes["hasMenubar"].to_i
      UI.window_set_margined raw_component, 1 if attributes["margin"].to_i == 1
      component = ui_control raw_component

      idx_component "sys::mainwindow", component if !get "sys::mainwindow"
    when "vertical_box"
      raw_component = UI.new_vertical_box
      UI.box_set_padded raw_component, attributes["padded"].to_i if attributes.has_key?("padded")
      component = ui_control raw_component
    when "horizontal_box"
      raw_component = UI.new_horizontal_box
      UI.box_set_padded raw_component, attributes["padded"].to_i if attributes.has_key?("padded")
      component = ui_control raw_component
    when "horizontal_separator"
      component = ui_control UI.new_horizontal_separator
    when "group"
      raw_component = UI.new_group text.to_s
      UI.group_set_margined raw_component, attributes["margined"].to_i if attributes.has_key?("margined")
      component = ui_control raw_component
    when "button"
      raw_component = UI.new_button text.to_s
      component = ui_control raw_component
    when "font_button"
      raw_component = UI.new_font_button
      component = ui_control raw_component
    when "color_button"
      raw_component = UI.new_color_button
      component = ui_control raw_component
    when "checkbox"
      raw_component = UI.new_checkbox text.to_s
      component = ui_control raw_component
    when "entry"
      raw_component = UI.new_entry
      UI.entry_set_text raw_component, text.to_s
      component = ui_control raw_component
    when "label"
      raw_component = UI.new_label text.to_s
      component = ui_control raw_component
    when "date_picker"
      raw_component = UI.new_date_picker
      component = ui_control raw_component
    when "time_picker"
      raw_component = UI.new_time_picker
      component = ui_control raw_component
    when "date_time_picker"
      raw_component = UI.new_date_time_picker
      component = ui_control raw_component
    when "spinbox"
      st, en = text.to_s.split(",").map { |v| v.strip.to_i }
      raw_component = UI.new_spinbox st, en
      component = ui_control raw_component
    when "slider"
      st, en = text.to_s.split(",").map { |v| v.strip.to_i }
      raw_component = UI.new_slider st, en
      component = ui_control raw_component
    when "progress_bar"
      raw_component = UI.new_progress_bar
      component = ui_control raw_component
    when "editable_combobox"
      raw_component = UI.new_editable_combobox
      component = ui_control raw_component
    when "combobox"
      raw_component = UI.new_combobox
      component = ui_control raw_component
    when "radio_buttons"
      raw_component = UI.new_radio_buttons
      component = ui_control raw_component
    when "tabs"
      raw_component = UI.new_tab
      component = ui_control raw_component
    else
      raise CUI::Exception.new "Trying to inflate an unknown component type: #{type}"
    end

    idx_component name.to_s, component if !name.nil? && !component.is_a?(Nil)

    component
  end

  private def add_child(type, parent : UI::Control*, attributes, child, child_attributes)
    stretched = child_attributes.has_key?("stretched") ? child_attributes["stretched"].to_i : 0

    case type
    when "window"
      UI.window_set_child parent.as(UI::Window*), child
    when "vertical_box", "horizontal_box"
      # TODO stretchy instead of 0
      UI.box_append parent.as(UI::Box*), child, stretched
    when "group"
      UI.group_set_child parent.as(UI::Group*), child
    else
      puts "## Warning: unknown child type ###"
    end
  end

  private def add_item(type, parent : UI::Control*, attributes, item)
    case type
    when "combobox"
      UI.combobox_append parent.as(UI::Combobox*), item
    when "editable_combobox"
      UI.editable_combobox_append parent.as(UI::EditableCombobox*), item
    when "radio_buttons"
      UI.radio_buttons_append parent.as(UI::RadioButtons*), item
    else
      puts "## Warning: unknown item type ###"
    end
  end

  private def inflate_component(ydesc : YAML::Any) : ComponentWrapper | Nil
    component_type = nil
    component_text = nil
    component_name = nil
    attributes = {} of String => String
    children = nil
    items = nil
    ydesc.as_h.each do |desc, data|
      # puts desc
      # puts data
      case desc
      when "children"
        children = inflate_components data
      when "items"
        items = [] of String
        data.as_a.each do |item|
          items << item["item"].to_s
        end
      when "name"
        component_name = data
      else
        if component_type.nil?
          component_type = desc
          component_text = data
        else
          attributes[desc.to_s] = data.to_s
        end
      end
    end

    # HUGE WART! Otherwise we would end up with:
    # can't cast (Pointer(UI::Combobox) | Pointer(UI::EditableCombobox)) to Pointer(UI::Control)
    # (macro in libui.cr)
    component_type = rewrite_type_this_is_a_hack! component_type, attributes

    # So now we should know what we need to know about our component_text
    # TODO check legit
    component = spawn_component component_type, component_name, component_text, attributes
    unless component.is_a?(Nil)
      unless children.nil?
        children.each do |child|
          add_child component_type, component, attributes, child.component, child.attributes
        end
      end
      unless items.nil?
        items.each do |item|
          add_item component_type, component, attributes, item
        end
      end
    end
    return nil if component.is_a?(Nil)
    ComponentWrapper.new component, attributes
    # puts "Component type=#{component_type} name=#{component_name} text=#{component_text}"
  end

  private def inflate_components(ydesc : YAML::Any) : Array(ComponentWrapper)
    component_wrappers = [] of ComponentWrapper
    ydesc.as_a.each do |desc|
      component_wrapper = inflate_component desc
      component_wrappers << component_wrapper unless component_wrapper.is_a?(Nil)
    end
    component_wrappers
  end

  # Public API

  def inflate(file_name : String)
    component_wrappers = [] of ComponentWrapper
    ydesc = YAML.parse File.read file_name
    ydesc.as_h.each do |desc, data|
      case desc
      when "windows"
        component_wrappers = inflate_components data
      when "components"
        component_wrappers = inflate_components data
      else
        raise CUI::Exception.new "Trying to inflate components that are neither windows nor components: #{desc}"
      end
    end
    component_wrappers
  end

  # ----------------------------------------------------------------------------
  # Create menubar and specialized items such as quit, preferences...
  # ----------------------------------------------------------------------------

  private def inflate_menuitems(ydesc : YAML::Any)
    components = [] of Array(String | Int32 | Nil)
    ydesc.as_a.each do |item|
      component_name = nil
      component_desc = MenuDesc::Enabled.value
      component_text = nil
      item.as_h.each do |desc, data|
        case desc
        when "name"
          component_name = data.to_s
        when "type"
          case data
          when "check"
            component_desc |= MenuDesc::Check.value
          when "quit"
            component_name = "sys#quit"
            component_desc |= MenuDesc::Quit.value
          when "preferences"
            component_name = "sys#preferences"
            component_desc |= MenuDesc::Preferences.value
          when "about"
            component_name = "sys#about"
            component_desc |= MenuDesc::About.value
          when "separator"
            component_name = "sys#separator"
            component_desc |= MenuDesc::Separator.value
          else
            raise CUI::Exception.new "Trying to decode an unsupported menu component type: #{data}"
          end
        when "enabled"
          component_desc &= ~MenuDesc::Enabled.value if data.to_s.strip != "true"
        when "item"
          component_text = data.to_s
        else
          raise CUI::Exception.new "Trying to decode an unsupported menu component attribute: #{desc}"
        end
      end
      raise CUI::Exception.new "Missing menu item information: #{component_name} -> #{component_text}" if component_name.nil? || component_text.nil?
      components << [component_name, component_text, component_desc]
    end
    components
  end

  private def inflate_menu(ydesc : YAML::Any)
    menu = nil
    children = nil
    ydesc.as_h.each do |desc, data|
      case desc
      when "items"
        children = inflate_menuitems data
      when "menu"
        menu = UI.new_menu data.to_s
      else
        raise CUI::Exception.new "Trying to inflate a menu component that is neither an item nor a submenu: #{desc}"
      end
    end
    unless menu.is_a?(Nil)
      unless children.nil?
        children.each do |child|
          name = child[0].as(String)
          text = child[1].as(String)
          desc = child[2].as(Int32)
          if (desc & MenuDesc::Check.value != 0)
            item = UI.menu_append_check_item menu, text
          elsif (desc & MenuDesc::Quit.value != 0)
            item = UI.menu_append_quit_item menu
          elsif (desc & MenuDesc::Preferences.value != 0)
            item = UI.menu_append_preferences_item menu
          elsif (desc & MenuDesc::About.value != 0)
            item = UI.menu_append_about_item menu
          elsif (desc & MenuDesc::Separator.value != 0)
            UI.menu_append_separator menu
          else
            item = UI.menu_append_item menu, text
          end
          UI.menu_item_disable item if (desc & MenuDesc::Enabled.value == 0)

          idx_component name, ui_control item unless item.is_a?(Nil)
        end
      end
    end
  end

  private def inflate_menubar(ydesc : YAML::Any)
    ydesc.as_a.each do |desc|
      inflate_menu desc
    end
  end

  # Public API

  def menubar(file_name : String)
    ydesc = YAML.parse File.read file_name
    ydesc.as_h.each do |desc, data|
      case desc
      when "menubar"
        inflate_menubar data
      else
        raise CUI::Exception.new "This is not a menubar: #{desc}"
      end
    end
  end

  # ----------------------------------------------------------------------------
  # Playground: Currently Unused.
  # ----------------------------------------------------------------------------

  # If main window was created manually, then attach it here
  # so that objects we create know where to find it.
  def attach_main_window(component)
    idx_component "sys::mainwindow", ui_control component
  end

  class Menu
    def initialize(text : String)
      @menu = UI.new_menu text
    end

    # Keep in mind that our proc's final argument is its return value as determined by the compiler
    def append(text : String, cb : Proc(UI::MenuItem*, UI::Window*, Void*, Object | Nil) | Nil = nil, data : Void* | Nil = nil, flags = MenuDesc::Enabled.value)
      # Confusing syntactic sugar...
      if (!flags.nil? && flags & MenuDesc::Disabled.value != 0)
        flags &= ~MenuDesc::Enabled.value
      else
        flags |= MenuDesc::Enabled.value
      end
      #
      if (!flags.nil? && flags & MenuDesc::Quit.value != 0)
        item = UI.menu_append_quit_item @menu
      elsif (!flags.nil? && flags & MenuDesc::Check.value != 0)
        item = UI.menu_append_check_item @menu, text
      elsif (!flags.nil? && flags & MenuDesc::Preferences.value != 0)
        item = UI.menu_append_preferences_item @menu
      elsif (!flags.nil? && flags & MenuDesc::About.value != 0)
        item = UI.menu_append_about_item @menu
      else
        item = UI.menu_append_item @menu, text
      end
      if (!flags.nil? && flags & MenuDesc::Enabled.value == 0)
        UI.menu_item_disable item
      end
      unless cb.nil?
        UI.menu_item_on_clicked item, cb, data
      end
      item
    end
  end

  class OpenFile
    getter filename

    def initialize
      @filename = UI.open_file CUI.get_mainwindow!
      # TODO: Currently we are not UI_free-ing this object.
      # We will need to figure out how to invoke this when the Crystal Team
      # settles on a GC model.
    end
  end

  class SaveFile
    getter filename

    def initialize
      @filename = UI.save_file CUI.get_mainwindow!
    end
  end

  enum MsgBoxType
    Plain
    Error
  end

  class MsgBox
    def initialize(title, text, msgboxtype = MsgBoxType::Plain)
      case msgboxtype
      when MsgBoxType::Plain
        UI.msg_box CUI.get_mainwindow!, title, text
      when MsgBoxType::Error
        UI.msg_box_error CUI.get_mainwindow!, title, text
      end
    end
  end
end
