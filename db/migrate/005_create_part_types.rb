class CreatePartTypes < ActiveRecord::Migration
  def self.up
    create_table :part_types do |t|
      t.column :name, :string
      t.column :field_type, :string
      t.column :field_class, :string
      t.column :field_styles, :string
    end
    
    add_column :template_parts, :part_type_id, :integer
  end

  def self.down
    drop_table :part_types
    remove_column :template_parts, :part_type_id
  end
end
