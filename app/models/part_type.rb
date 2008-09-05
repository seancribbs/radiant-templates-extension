class PartType < ActiveRecord::Base
  has_many :template_parts
  
  validates_presence_of :name
  validates_inclusion_of :field_type, :in => %w{text_area text_field check_box hidden}
end
