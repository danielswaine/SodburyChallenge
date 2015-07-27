class CreateCheckpoints < ActiveRecord::Migration
  def change
    create_table :checkpoints do |t|
      t.integer :CheckpointID
      t.string :GridReference
      t.string :CheckpointDescription

      t.timestamps null: false
    end
  end
end
