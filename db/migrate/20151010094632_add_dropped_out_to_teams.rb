class AddDroppedOutToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :dropped_out, :boolean
  end
end
