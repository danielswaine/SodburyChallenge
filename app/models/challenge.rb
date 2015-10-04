class Challenge < ActiveRecord::Base
  has_many :goals
  has_many :checkpoints, through: :goals
  has_many :teams, inverse_of: :challenge, dependent: :destroy
end
