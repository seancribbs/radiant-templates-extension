class CreateTemplates < ActiveRecord::Migration
  def self.up
    create_table :templates do |t|
      t.column :name, :string
      t.column :sublayout, :text
      t.column :layout_id, :integer
    end
    add_index :templates, :name
    
    add_column :pages, :template_id, :integer
  end

  def self.down
    drop_table :templates
    remove_column :pages, :template_id
  end
end
