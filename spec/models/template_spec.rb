require File.dirname(__FILE__) + '/../spec_helper'

describe ::Template do
  dataset :templates, :pages

  before :each do
    @template = Template.new :name => "Article", :layout_id => layout_id(:main)
  end

  it "should be valid with correct parameters" do
    @template.should be_valid
  end

  it "should require a name" do
    @template.name = nil
    @template.should_not be_valid
    @template.should have(1).error_on(:name)
  end

  it "should require a layout" do
    @template.layout = nil
    @template.should_not be_valid
    @template.should have(1).error_on(:layout_id)
  end

  it "should require a valid or empty page class name" do
    @template.page_class_name = nil
    @template.should be_valid

    @template.page_class_name = "blah"
    @template.should_not be_valid

    @template.page_class_name = "FileNotFoundPage"
    @template.should be_valid
  end

  it "should create template parts from a hash" do
    @template.template_parts = {'1' => {:name => "extended", :filter_id => nil, :part_type_id => 1}, '2' => {:name => "more", :filter_id => "Textile", :part_type_id => 3}}
    @template.should be_valid
    @template.should have(2).template_parts
  end

  describe "updating associated pages after update" do
    before :each do
      @template = templates(:sample)
      @page = pages(:home)
      @template.should_receive(:pages).and_return([@page])
      @template.update_attributes!(:layout_id => layout_id(:utf8), :page_class_name => "FileNotFoundPage")
      @page.reload
      @page.parts.reload
    end

    it "should update the layout" do
      @page.layout_id.should == layout_id(:utf8)
    end

    it "should delete page parts that do not match the template parts" do
      @page.part(:sidebar).should be_nil
      @page.part(:titles).should be_nil
    end

    it "should update the class name" do
      @page.class_name.should == 'FileNotFoundPage'
    end

    it "should update the content of the body part" do
      @page.part(:body).content.should == 'Content for Sample.'
    end
    
    if defined?(ConcurrentDraftExtension)
      it "should update the draft_content of the body part" do
        @page.part(:body).draft_content.should == 'Content for Sample.'
      end
    end
  end

  it "should return templates in default order by position" do
    Template.find(:all, :order => :position).should == Template.find(:all)
  end

  it "should not update associated pages when reordering" do
    @template = templates(:sample)
    Template.reordering do
      @template.should_not_receive(:pages)
      @template.move_to_bottom
    end
  end
end