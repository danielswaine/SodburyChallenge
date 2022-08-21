class AddIndexToTeamStartTime < ActiveRecord::Migration
  def change
    add_index :teams, %i[challenge_id planned_start_time], unique: true
  end
end
