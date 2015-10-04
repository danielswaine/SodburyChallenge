class Team < ActiveRecord::Base
  belongs_to :challenge, inverse_of: :teams
end
