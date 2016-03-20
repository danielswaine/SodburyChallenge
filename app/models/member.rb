class Member < ActiveRecord::Base
  belongs_to :team, inverse_of: :members

  validates :name, presence: true
  validates :team_id, presence: true

end
