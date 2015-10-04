class Challenge < ActiveRecord::Base
  has_many :goals
  has_many :checkpoints, through: :goals
  has_many :teams, inverse_of: :challenge, dependent: :destroy

  serialize :bonus_one, Hash
  serialize :bonus_two, Hash
  serialize :bonus_three, Hash
  serialize :bonus_four, Hash
  serialize :bonus_five, Hash

  validates :date, presence: true

  validates :time_allowed, presence: true,
                           numericality: {
                                           greater_than: 0,
                                           only_integer: true,
                                           message: 'must be an integer number of hours'
                           }
end
