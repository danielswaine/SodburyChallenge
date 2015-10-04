class Team < ActiveRecord::Base
  belongs_to :challenge, inverse_of: :teams

  enum :group [:scouts, :explorers, :non_competitive]

  serialize :visited, Array

  before_save { self.name = name.titleize }

  validates :challenge_id, presence: true

  validates :group, presence: true

  validates :name, length: {
                             in: 5..70,
                             too_short: 'is too short',
                             too_long: 'is too long'
                           },
                   format: {
                             with: /\A[ -~]*\z/,
                             message: 'contains invalid characters'
                           }

  validates :nominal_start_time, presence: true

end
