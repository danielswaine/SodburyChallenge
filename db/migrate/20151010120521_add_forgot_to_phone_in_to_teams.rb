class AddForgotToPhoneInToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :forgot_to_phone_in, :boolean, default: false
  end
end
