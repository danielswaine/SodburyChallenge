class UpdateTeams < ActiveRecord::Migration
  def change
    change_table :teams do |t|
      t.remove_belongs_to :route
      t.belongs_to :challenge
      t.integer :group, default: 0
      t.rename :team_number, :number
      t.rename :start_time, :nominal_start_time
      t.change :nominal_start_time, :time
      t.time :actual_start_time
      t.remove :due_end_time
      t.rename :end_time, :finish_time
      t.change :finish_time, :time
      t.remove :due_phone_in_time
      t.change :phone_in_time, :time
      t.remove :team_year
      t.text :visited
      t.boolean :disqualified
    end
  end
end
