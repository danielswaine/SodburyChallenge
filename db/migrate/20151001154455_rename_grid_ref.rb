class RenameGridRef < ActiveRecord::Migration
  def change
    rename_column :checkpoints, :grid_ref, :grid_reference
  end
end
