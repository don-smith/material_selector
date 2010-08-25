
class MaterialSelector 

  def select(model, material)
    model.selection.clear
    model.entities.each do |entity|
      select_with entity, material do |e|
        model.selection.add e
      end
    end
  end

  private 

  def select_with(entity, material, &block)
    case entity.typename
      when 'Face'
        yield entity if entity.material.display_name == material.display_name
      when 'Group'
        entity.entities.each { |sub_entity| select_with sub_entity, material, &block }
      when 'ComponentInstance'
        entity.definition.entities.each { |sub_entity| select_with sub_entity, material, &block }
    end
  end
  
end
