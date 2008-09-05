class TemplatePart < ActiveRecord::Base
  belongs_to :template
  belongs_to :part_type
  
  validates_presence_of :name, :part_type_id
  validates_exclusion_of :name, :in => %w{body}, :message => "cannot be named 'body'"

  def index
    @index ||=  new_record? ? "0#{rand(1000)}" : id
  end
  
  def part_type_name=(name)
    self.part_type = PartType.find_by_name(name)
  end
end
