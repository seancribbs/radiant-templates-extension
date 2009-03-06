class TemplatesDataset < Dataset::Base
  uses :part_types, :layouts
  
  def load
    create_template "Sample" do
      create_template_part "Part 1", :part_type_id => part_type_id(:wysiwyg)
      create_template_part "extended", :part_type_id => part_type_id(:plaintext)
      create_template_part "featured?", :part_type_id => part_type_id(:boolean)
      create_template_part "Feature image", :part_type_id => part_type_id(:asset)
      create_template_part "Tagline", :part_type_id => part_type_id(:one_line)
    end
    create_template "Another", :page_class_name => "FileNotFoundPage"
  end
  
  helpers do
    def create_template(name, attributes={})
      @current_template = create_model Template, name.symbolize, template_params(attributes.reverse_merge(:name => name))
      yield if block_given?
      @current_template = nil
    end
    
    def template_params(attributes={})
      {
        :content => "Content for #{attributes[:name]}.",
        :page_class_name => nil,
        :layout_id => layout_id(:main),
      }.merge(attributes.symbolize_keys)
    end
    
    def create_template_part(name, attributes={})
      create_model TemplatePart, name.symbolize, attributes.reverse_merge(:name => name, :template_id => (@current_template ? @current_template.id : nil))
    end
  end
end