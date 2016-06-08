class AddTeamToMember < ActiveRecord::Migration
  def change
    add_reference :members, :team, index: true, foreign_key: true
  end
end
