require 'sketchup.rb'
require 'material_selector'

# I factor out material_selector for testing

current_file = 'material_selector_with_env'

if  !file_loaded? current_file
    edit_menu = UI.menu 'Edit'
    edit_menu.add_separator
    edit_menu.add_item('Select all by material') { select_all_by_material }
end

file_loaded current_file

model = Sketchup.active_model
material = model.materials.current
selector = MaterialSelector.new
selector.select model, material

