class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.belongs_to :challenge
      t.belongs_to :checkpoint
      t.integer :points_value
      t.boolean :compulsory

      t.timestamps null: false
    end
  end
end
