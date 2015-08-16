class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.integer :team_number
      t.string :name
      t.integer :route_id
      t.integer :score
      t.datetime :start_time
      t.datetime :due_end_time
      t.datetime :end_time
      t.datetime :due_phone_in_time
      t.datetime :phone_in_time
      t.datetime :team_year

      t.timestamps null: false
    end
  end
end
