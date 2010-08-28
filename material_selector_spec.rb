require 'spec'
require 'material_selector_without_env'

describe MaterialSelector do

  before :each do
    @brown_material = double(:material)
    @brown_material.stub(:display_name).and_return("brown")
    brown_face = double(:face)
    brown_face.stub(:typename).and_return("Face")
    brown_face.stub(:material).and_return(@brown_material)

    selection = double(:selection)
    selection.should_receive(:clear).and_return(nil)
    selection.should_receive(:add).with(brown_face)
    
    @model = double(:model)
    @model.stub(:selection).and_return(selection)
    @model.stub(:active_entities).and_return([brown_face, black_face])
  end
  
  it "should select faces directly in the active model" do
    selector = MaterialSelector.new
    selector.select(@model, @brown_material)
    @model.selection.first.display_name.should == @brown_material.display_name
  end

end