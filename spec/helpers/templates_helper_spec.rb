require File.dirname(__FILE__) + '/../spec_helper'

describe Templates::Helper do
  dataset :pages, :templates

  before :each do
    @page = pages(:home)
    helper.instance_variable_set(:@page, @page)
  end

  describe "template_part_field" do
    it "should output a text area from a template part with part-type of text_area" do
      helper.should_receive(:text_area_tag).and_return('text_area')
      helper.template_part_field(template_parts(:extended), 0).should == 'text_area'
    end

    it "should output a text field from a template part with part-type of text_field" do
      helper.should_receive(:text_field_tag).and_return('text_field')
      helper.template_part_field(template_parts(:tagline), 0).should == 'text_field'
    end

    it "should output a radio_button field from a template part with part-type of radio_button" do
      helper.should_receive(:radio_button_tag).twice.and_return('radio_button')
      helper.template_part_field(template_parts(:featured), 0).should include("radio_button")
    end

    it "should output a hidden field from a template part with part-type hidden" do
      helper.should_receive(:hidden_field_tag).and_return('hidden')
      helper.template_part_field(template_parts(:feature_image), 0).should == 'hidden'
    end

    it "should determine the field name from the given index" do
      helper.should_receive(:hidden_field_tag).with("#{helper.page_part_name(1)}[content]", '', :class => 'asset', :id => 'page_parts_1_content')
      helper.template_part_field(template_parts(:feature_image), 1)
    end

    it "should put blank content in the field if the part doesn't already exist" do
      @page.part('Tagline').should be_nil
      helper.should_receive(:text_field_tag).with("#{helper.page_part_name(1)}[content]", '', :class => 'text', :style => "width: 500px", :id => 'page_parts_1_content')
      helper.template_part_field(template_parts(:tagline), 1)
    end

    it "should put content from the existing part in the field" do
      helper.should_receive(:text_area_tag).with("#{helper.page_part_name(1)}[content]", 'Just a test.', :class => 'plain', :id => 'page_parts_1_content')
      helper.template_part_field(template_parts(:extended), 1)
    end

    if defined?(ConcurrentDraftExtension)
      it "should output the draft content and hidden live content if concurrent_draft is enabled" do
        helper.should_receive(:hidden_field_tag).with("#{helper.page_part_name(1)}[content]", 'Just a test.', :id => 'page_parts_1_content')
        helper.should_receive(:text_area_tag).with("#{helper.page_part_name(1)}[draft_content]", '', :class => 'plain', :id => 'page_parts_1_draft_content')
        helper.template_part_field(template_parts(:extended), 1, true)
      end
    end
  end
end