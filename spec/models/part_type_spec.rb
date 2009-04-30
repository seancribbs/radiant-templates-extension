require File.dirname(__FILE__) + '/../spec_helper'

describe PartType do
  before :each do
    @part_type = PartType.new :name => "Test type", :field_type => 'text_area'
  end

  it "should require a name" do
    @part_type.name = nil
    @part_type.should_not be_valid
    @part_type.should have(1).error_on(:name)
  end

  it "should require a valid field type" do
    @part_type.field_type = 'foobar'
    @part_type.should_not be_valid
    @part_type.should have(1).error_on(:field_type)
  end

  it "should be valid with correct parameters" do
    @part_type.should be_valid
  end

  it "should not allow creation of a new part type with a duplicate name" do
    @new_part_type = PartType.create :name => @part_type.name
    @new_part_type.id.should be_nil
  end
end
