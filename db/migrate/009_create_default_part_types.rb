class CreateDefaultPartTypes < ActiveRecord::Migration
  def self.defaults
    [
      {:name => "One-line", :field_type => "text_field", :field_class => "text"},
      {:name => "Plain textarea", :field_type => "text_area", :field_class => "textarea"},
      {:name => "Boolean", :field_type => "check_box"},
      {:name => "Predefined", :field_type => "predefined"}
    ]
  end

  def self.up
    self.defaults.each do |a|
      PartType.create(a)
    end
  end

  def self.down
    self.defaults.each do |a|
      pt = PartType.find_by_name(a[:name])
      pt.destroy unless pt.nil?
    end
  end
end
