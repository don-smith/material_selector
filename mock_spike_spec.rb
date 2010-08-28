require 'spec'

class ObjectReader
  def initialize(obj)
    @obj = obj
  end
  
  def mystring
    @obj.mystring
  end
end

describe ObjectReader do
  it "should read a string property" do
    parent = double(:parent)
    parent.stub(:mystring).and_return("my string")
    reader = ObjectReader.new(parent)
    reader.mystring.should == "my string"
  end
  
  it "should invoke a method"
  it "should get an object property"
  it "should invoke a method on a child object"
end