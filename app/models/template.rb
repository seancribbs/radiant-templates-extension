class Template < ActiveRecord::Base
  acts_as_list
  begin
    default_scope :order => "position ASC"
  rescue
    named_scope :default, :order => "position"
  end
  
  class << self
    def reordering
      @reordering = true
      yield
      @reordering = false
    end
    
    def reordering?
      @reordering
    end
  end
  
  has_many :pages, :dependent => :nullify
  has_many :template_parts, :dependent => :destroy, :order => "id ASC"
  belongs_to :layout
  
  validates_presence_of :name, :layout_id
  validate :valid_page_class_name
  
  before_validation :create_template_parts
  after_update :update_pages
  
  def template_parts_with_hash=(value)
    if value.is_a? Hash
      @add_template_parts = order_and_extract(value)
    else
      template_parts_without_hash=(value)
    end
  end
  
  alias_method_chain :template_parts=, :hash
  
  private
    def create_template_parts
      if @add_template_parts
        self.template_parts.clear
        @add_template_parts.each do |part|
          self.template_parts << TemplatePart.new(part)
        end
      end
      @add_template_parts = nil
    end
    
    def order_and_extract(hash)
      hash.to_a.sort_by(&:first).map(&:last)
    end
    
    def update_pages
      unless self.class.reordering?
        self.pages.each do |page|
          page.parts.each do |part|
            if part.name == 'body'
              attrs = {:content => self.content}
              attrs[:draft_content] = self.content if defined?(ConcurrentDraftExtension)
              part.update_attributes(attrs)
            else
              unless self.template_parts.map(&:name).include?(part.name)
                part.destroy
              end
            end
          end
          page.update_attributes(:layout_id => self.layout_id, :class_name => (self.page_class_name.blank? ? page.class_name : self.page_class_name))
        end
      end
    end
    
    def valid_page_class_name
      unless Page.is_descendant_class_name?(page_class_name)
        errors.add :page_class_name, "must be set to a valid descendant of Page"
      end
    end
end
