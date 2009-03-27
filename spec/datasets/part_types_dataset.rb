class PartTypesDataset < Dataset::Base
  def load
    create_part_type "One-line", :field_type => "text_field", :field_class => "text", :field_styles => "width: 500px"
    create_part_type "Plaintext", :field_type => "text_area", :field_class => "plain"
    create_part_type "WYSIWYG", :field_type => "text_area", :field_class => "textarea", :field_styles => "width: 100%"
    create_part_type "Boolean", :field_type => "radio_button"
    create_part_type "Asset", :field_type => "hidden", :field_class => "asset"
  end
  
  helpers do
    def create_part_type(name, attributes={})
      create_model PartType, name.symbolize, attributes.merge(:name => name)
    end
  end
end