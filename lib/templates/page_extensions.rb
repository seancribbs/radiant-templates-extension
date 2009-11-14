module Templates::PageExtensions
  
  def self.included(base)
    base.class_eval do
      before_save :match_with_template
    end
  end
  
  def match_with_template
    unless self.template.blank?
      self.class_name = self.template.page_class_name
      self.layout_id = self.template.layout_id
    end
  end
  
end