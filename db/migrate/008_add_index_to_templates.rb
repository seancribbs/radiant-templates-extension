class AddIndexToTemplates < ActiveRecord::Migration
  def self.up
    add_index :templates, :position
  end
  
  def self.down
    remove_index :templates, :position
  end
end