class AddDescriptionToTemplateParts < ActiveRecord::Migration
  def self.up
    add_column :template_parts, :description, :string
  end
  
  def self.down
    remove_column :template_parts, :description
  end
end
