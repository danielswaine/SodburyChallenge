class ChangeLongStringsToText < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.change :email, :text
    end
    change_table :checkpoints do |t|
      t.change :description, :text
    end
  end
  def down
    change_table :users do |t|
      t.change :email, :string
    end
    change_table :checkpoints do |t|
      t.change :description, :string
    end
  end
end
