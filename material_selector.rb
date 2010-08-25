require 'sketchup.rb'

class MaterialSelector 
  
  def select_with(entity, material, &block)
    case entity.typename
      when 'Face'
        yield entity if entity.material.display_name == material.display_name
      when 'Group'
        entity.entities.each { |e| select_with e, material, &block }
      when 'Component Instance'
        entity.definition.entities.each { |sub_entity| select_with sub_entity, material, &block }
      else
        return false # => can ignore edges and other things that don't have materials
    end
  end

  def select(material)
    model = Sketchup.active_model
    model.selection.clear
    
    model.entities.each do |entity|
      select_with entity, material do |e|
        model.selection.add e
      end
    end
  end

  def part_of_an_initializer
    if( not file_loaded?("color_selector.rb") )
        edit_menu = UI.menu 'Edit'
        edit_menu.add_separator
        edit_menu.add_item('Select all by material') { select_all_by_material }
    end
    file_loaded 'color_selector.rb'
  end
  
end

