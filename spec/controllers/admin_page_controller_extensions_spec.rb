require File.dirname(__FILE__) + '/../spec_helper'

# We only have this spec because setting up an isolated view spec would be too
# complicated.  Instead we have a quasi-integration test.
describe Admin::PagesController, "edit view controlled by templates" do
  integrate_views
  dataset :users_and_pages, :templates
  before :each do
    @page = pages(:home)
    @page.template = templates(:sample)
    @page.stub!(:children).and_return([])
    login_as :developer
  end
  
  def do_get
    get :edit, :id => @page.id
  end

  it "should include a hidden field containing the body/structure" do
    do_get
    response.should have_tag('input', :attributes => {'type' => 'hidden', 'name' => 'part[0][name]', 'value' => 'body'})
    response.should have_tag('input', :attributes => {'type' => 'hidden', 'name' => 'part[0][content]'})
  end
  
  it "should display a template part with style and class attributes" do
    do_get
    response.should have_tag('input', :attributes => {'type' => 'hidden', 'name' => 'part[1][name]', 'value' => 'Part 1'})
    response.should have_tag('textarea', :attributes => {'name' => 'part[0][content]', 'class' => 'wysiwyg', 'style' => 'width: 100%'})
  end
  
  it "should display a textarea template part" do
    do_get
    response.should have_tag('input', :attributes => {'type' => 'hidden', 'name' => 'part[1][name]', 'value' => 'extended'})
    response.should have_tag('textarea', :attributes => {'name' => 'part[1][content]', 'class' => 'plaintext'})
  end
  
  it "should display a radio_button template part" do
    do_get
    response.should have_tag('input', :attributes => {'type' => 'hidden', 'name' => 'part[2][name]', 'value' => 'featured?'})
    response.should have_tag('input', :attributes => {'type' => 'radio_button', 'name' => 'part[2][content]', 'value' => 'true'})
    response.should have_tag('input', :attributes => {'type' => 'hidden', 'name' => 'part[2][content]', 'value' => 'false'}) 
  end
  
  it "should display a hidden template part" do
    do_get
    response.should have_tag('input', :attributes => {'type' => 'hidden', 'name' => 'part[3][name]', 'value' => 'Feature image'})
    response.should have_tag('input', :attributes => {'type' => 'hidden', 'name' => 'part[3][content]'})
  end
  
  it "should display a text field template part" do
    do_get
    response.should have_tag('input', :attributes => {'type' => 'hidden', 'name' => 'part[4][name]', 'value' => 'Tagline'})
    response.should have_tag('input', :attributes => {'type' => 'text', 'name' => 'part[4][content]'})
  end
  
  it "should override the class name field when the template has one specified" do
    @page.template = templates(:another)
    do_get
    response.should have_tag('input', :attributes => {'name' => 'page[class_name]', 'value' => 'FileNotFoundPage'})
  end
end