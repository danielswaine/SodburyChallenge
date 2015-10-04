class DefaultDisqualifiedToFalse < ActiveRecord::Migration
  def up
    change_column :teams, :disqualified, :boolean, default: false
  end
  def down
    change_column :teams, :disqualified, :boolean, default: nil
  end
end
