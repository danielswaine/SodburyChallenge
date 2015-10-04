class RemoveNumberFromTeams < ActiveRecord::Migration
  def change
    remove_column :teams, :number, :integer
  end
end
