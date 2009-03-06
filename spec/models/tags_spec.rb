require File.dirname(__FILE__) + '/../spec_helper'

describe "Templates::Tags" do
  dataset :pages
  before :each do
    @page = pages(:home)
    @page.parts.build(:name => "False", :content => 'false')
    @page.parts.build(:name => "True", :content => 'true')
  end
  
  describe "<r:boolean_part>" do
    it "should expand its contents" do
      @page.should render('<r:boolean_part>true</r:boolean_part>').as('true')
    end
  end
  
  describe "<r:boolean_part:if>" do
    it "should expand its contents if the selected part evaluates to true" do
      @page.should render('<r:boolean_part:if part="True">yes!</r:boolean_part:if>').as('yes!')
    end
    
    it "should not expand its contents if the selected part does not evaluate to true" do
      @page.should render('<r:boolean_part:if part="False">yes!</r:boolean_part:if>').as('')
    end
    
    it "should raise an error if the part attribute is missing" do
      @page.should render('<r:boolean_part:if>yes!</r:boolean_part:if>').with_error("`boolean_part:if' tag requires a 'part' attribute")
    end
  end
  
  describe "<r:boolean_part:unless>" do
    it "should not expand its contents if the selected part evaluates to true" do
      @page.should render('<r:boolean_part:unless part="True">yes!</r:boolean_part:unless>').as('')
    end
    
    it "should expand its contents if the selected part does not evaluate to true" do
      @page.should render('<r:boolean_part:unless part="False">yes!</r:boolean_part:unless>').as('yes!')
    end
    
    it "should raise an error if the part attribute is missing" do
      @page.should render('<r:boolean_part:unless>yes!</r:boolean_part:unless>').with_error("`boolean_part:unless' tag requires a 'part' attribute")
    end
  end
end