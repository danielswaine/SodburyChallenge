class Member < ActiveRecord::Base
  belongs_to :team, inverse_of: :members
end
