class CreateTemplateParts < ActiveRecord::Migration
  def self.up
    create_table :template_parts do |t|
      t.column :template_id, :integer
      t.column :name, :string
      t.column :filter_id, :string
    end
    
    add_index :template_parts, :template_id, :name => 'template_parts_on_template_id'
  end

  def self.down
    drop_table :template_parts
  end
end
