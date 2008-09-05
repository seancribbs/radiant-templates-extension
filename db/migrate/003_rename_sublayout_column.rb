class RenameSublayoutColumn < ActiveRecord::Migration
  def self.up
    rename_column :templates, :sublayout, :content
  end
  
  def self.down
    rename_column :templates, :content, :sublayout
  end
end
