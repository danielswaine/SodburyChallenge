class AddPublishedToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :published, :boolean, default: false
  end
end
