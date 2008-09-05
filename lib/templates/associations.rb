module Templates::Associations
  def self.included(base)
    base.class_eval {
      belongs_to :template
    }
  end
end
