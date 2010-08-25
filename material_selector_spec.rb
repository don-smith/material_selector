require 'rspec'
require 'material_selector_without_env'

describe MaterialSelector do
  include RSpec::Mocks

  before :each do
    @brown_material = double('material').stub('display_name').and_return('brown')
    @brown_face = double('face').stub('material').and_return(@brown_material)

    black_material = double('material').stub('display_name').and_return('black')
    @black_face = double('face').stub('material').and_return(black_material)

    selection = double('selection').should_receive(:clear).and_return(nil)
    selection.should_receive(:add).with(@brown_face)
    
    @model = double('model').stub('selection').and_return(selection)
    @model.stub('active_entities').and_return([@brown_face, @black_face])
  end
  
  it "should select faces directly in the active model" do
    selector = MaterialSelector.new
    selector.select(@model, @brown_material)
  end

end