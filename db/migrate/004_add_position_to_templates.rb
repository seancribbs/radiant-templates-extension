class AddPositionToTemplates < ActiveRecord::Migration
  def self.up
    add_column :templates, :position, :integer
    Template.reset_column_information
    Template.find(:all).each_with_index do |t, i|
      t.update_attribute(:position => i + 1)
    end
  end
  
  def self.down
    remove_column :templates, :position
  end
end
