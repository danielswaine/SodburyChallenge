class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :team_number
      t.date :date
      t.text :time
      t.text :latitude
      t.text :longitude
      t.text :speed
      t.integer :battery
      t.integer :signal_strength
      t.text :mobile_number

      t.timestamps null: false
    end
  end
end
