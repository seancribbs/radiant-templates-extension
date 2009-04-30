class UpdateBooleanPartType < ActiveRecord::Migration
  def self.up
    PartType.find_by_name("Boolean").update_attribute(:field_type, "radio_button")
  end

  def self.down
    PartType.find_by_name("Boolean").update_attribute(:field_type, "check_box")
  end
end
