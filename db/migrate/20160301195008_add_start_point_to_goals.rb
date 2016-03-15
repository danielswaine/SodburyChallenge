class AddStartPointToGoals < ActiveRecord::Migration
  def change
    add_column :goals, :start_point, :boolean
  end
end
