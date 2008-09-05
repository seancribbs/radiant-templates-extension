require File.dirname(__FILE__) + '/../spec_helper'

describe Page, "extended with templates" do
  it "should be associated to its template" do
    Page.included_modules.should include(Templates::Associations)
    Page.new.should respond_to(:template)
    Page.new.should respond_to(:template=)
  end
end