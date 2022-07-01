class UpdateMessageModel < ActiveRecord::Migration
  def change
    change_table :messages do |t|
      t.change :date, :datetime
      t.rename :date, :gps_fix_timestamp
      t.remove :time
      t.rename :battery, :battery_voltage
      t.change :battery_voltage, :string
      t.column :battery_level, :string
      t.rename :signal_strength, :rssi
    end
  end
end
