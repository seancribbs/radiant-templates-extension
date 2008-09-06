class CreateDefaultPartTypes < ActiveRecord::Migration
  def self.up
    [
      {:name => "One-line", :field_type => "text_field", :field_class => "text"},
      {:name => "Plain textarea", :field_type => "text_area", :field_class => "textarea"},
      {:name => "Boolean", :field_type => "check_box"}
    ].each {|a| PartType.create(a) }
  end
  
  def self.down
    PartType.destroy_all
  end
end