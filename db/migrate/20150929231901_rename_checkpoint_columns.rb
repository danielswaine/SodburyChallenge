class RenameCheckpointColumns < ActiveRecord::Migration
  def change
    rename_column :checkpoints, :CheckpointID, :number
    rename_column :checkpoints, :GridReference, :grid_ref
    rename_column :checkpoints, :CheckpointDescription, :description
  end
end
