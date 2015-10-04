class DefaultCompulsoryToFalse < ActiveRecord::Migration
  def up
    change_column :goals, :compulsory, :boolean, default: false
  end
  def down
    change_column :goals, :compulsory, :boolean, default: nil
  end
end
