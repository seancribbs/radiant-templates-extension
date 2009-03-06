require File.dirname(__FILE__) + '/../spec_helper'

describe TemplatePart do
  dataset :part_types
  
  before :each do
    @template_part = TemplatePart.new :template_id => 1, :name => "extended", 
                                    :filter_id => nil, :part_type_id => 1
  end
  
  it "should be valid with correct parameters" do
    @template_part.should be_valid
  end
  
  it "should require a name" do
    @template_part.name = nil
    @template_part.should_not be_valid
    @template_part.should have(1).error_on(:name)
  end
  
  it "should require a part type" do
    @template_part.part_type_id = nil
    @template_part.should_not be_valid
    @template_part.should have(1).error_on(:part_type_id)
  end
  
  it "should disallow 'body' for name" do
    @template_part.name = 'body'
    @template_part.should_not be_valid
    @template_part.should have(1).error_on(:name)
  end
  
  it "should assign a part type by name" do
    @template_part.part_type_name = "Boolean"
    @template_part.part_type.should == part_types(:boolean)
  end
end