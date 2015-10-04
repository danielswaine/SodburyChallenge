class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.date :date
      t.integer :time_allowed
      t.text :bonus_one
      t.text :bonus_two
      t.text :bonus_three
      t.text :bonus_four
      t.text :bonus_five

      t.timestamps null: false
    end
  end
end
