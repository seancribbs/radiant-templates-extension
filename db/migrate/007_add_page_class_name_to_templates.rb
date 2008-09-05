class AddPageClassNameToTemplates < ActiveRecord::Migration
  def self.up
    add_column :templates, :page_class_name, :string, :default => nil
  end
  
  def self.down
    remove_column :templates, :page_class_name
  end
end