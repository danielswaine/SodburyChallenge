class Goal < ActiveRecord::Base
  belongs_to :challenge
  belongs_to :checkpoint

  validates :challenge_id, presence: true

  validates(
    :checkpoint_id,
    presence: true,
    uniqueness: {
      message: 'already exists on this challenge.',
      scope: :challenge_id
    }
  )

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

  validate :goal_cannot_be_both_start_and_compulsory

  private

  def goal_cannot_be_both_start_and_compulsory
    if start_point && compulsory
      errors.add(:base, 'A goal cannot be both a start point and compulsory.')
    end
  end
end
