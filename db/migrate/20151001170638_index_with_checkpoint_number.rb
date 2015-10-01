class IndexWithCheckpointNumber < ActiveRecord::Migration
  def change
    add_index :checkpoints, :number, unique: true
  end
end
