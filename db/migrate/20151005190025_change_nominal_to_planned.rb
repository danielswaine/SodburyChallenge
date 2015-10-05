class ChangeNominalToPlanned < ActiveRecord::Migration
  def change
    rename_column :teams, :nominal_start_time, :planned_start_time
  end
end
