require 'sketchup.rb'
require 'progressbar.rb'

# I tried to make this code read well, but since it has a 
# couple of recursive functions that crawl into and out of
# the model's object model, I provided comments to help

class MaterialSelector 

  # Main starting point for the class
  def select(model, material)
    model.selection.clear
    initialize_progress_bar model
    model.active_entities.each do |entity|
      increment_progress_bar
      select_with entity, material do |matching_entity|
        model.selection.add matching_entity if matching_entity
      end
    end
  end

  private 

  # Called by the select method and recursively calls itself
  # Starts at the entity passed in and looks for a face with the material
  def select_with(entity, material, &block)
    case entity.typename
      when 'Face'
        if entity.material && entity.material.display_name == material.display_name
          yield entity # invoke the block
          # select this face's parents so you can see where the material is used
          select_parents_of entity, &block
        end
      # recursively call this method for this entity's children to fina a match
      when 'Group'
        entity.entities.each { |sub_entity| select_with sub_entity, material, &block }
      when 'ComponentInstance'
        entity.definition.entities.each { |sub_entity| select_with sub_entity, material, &block }
    end
  end
  
  # Called by the select_with method for entities containing matching materials
  def select_parents_of(entity, &block)
    # return false unless entity.parent # in the case of a model
    case entity.parent.typename 
      when "Group"
        yield entity.parent # invoke the block
        # recursively call this method for this entity's parent to select it
        select_parents_of entity.parent, $block
      when "ComponentDefinition"
        # select all component instances
        entity.parent.instances.each { |instance| yield instance }
    end    
  end
  
  def initialize_progress_bar(model)
    @progress_bar = ProgressBar.new(model.active_entities.length, "Selecting entities ...")
    @current_entity = 1
  end
  
  def increment_progress_bar
    @current_entity += 1
    @progress_bar.update @current_entity
  end
end

# Invoked when the menu item (created below) is selected
def select_all_by_material
  model = Sketchup.active_model
  material = model.materials.current
  selector = MaterialSelector.new
  selector.select model, material
end

# Don't want to add more than one menu item
current_file = 'material_selector.rb'
if  !file_loaded? current_file
    edit_menu = UI.menu 'Edit'
    edit_menu.add_separator
    edit_menu.add_item('Select all by material') { select_all_by_material }
end
file_loaded current_file

