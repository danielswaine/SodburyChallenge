class ChangeTimesToStrings < ActiveRecord::Migration
  def change
    change_table :teams do |t|
      t.change :nominal_start_time, :string
      t.change :actual_start_time, :string
      t.change :phone_in_time, :string
      t.change :finish_time, :string
    end
  end
end
