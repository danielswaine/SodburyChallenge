class DefaultStartToFalse < ActiveRecord::Migration
  def up
    change_column :goals, :start_point, :boolean, default: false
  end

  def down
    change_column :goals, :start_point, :boolean, default: nil
  end
end
