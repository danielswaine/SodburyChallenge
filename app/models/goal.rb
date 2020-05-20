class Goal < ActiveRecord::Base
  belongs_to :challenge
  belongs_to :checkpoint

  validates :challenge_id, presence: true
  validates :checkpoint_id, presence: true

  validates :points_value, presence: true
  validates(
    :points_value,
    numericality: {
      greater_than_or_equal_to: 0,
      only_integer: true,
      message: 'must be a non-negative integer'
    },
    if: 'points_value.present?'
  )
end
