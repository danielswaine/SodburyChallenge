class Team < ActiveRecord::Base
  belongs_to :challenge, inverse_of: :teams

  enum group: [:scouts, :explorers, :non_competitive]
  serialize :visited, Array

  before_save { self.name = name.titleize }

  validates :name, length: {
                             in: 5..70,
                             too_short: 'is too short',
                             too_long: 'is too long'
                           },
                   format: {
                             with: /\A[ -~]*\z/,
                             message: 'contains invalid characters'
                           }

  challenges_array = Challenge.all.map { |c| c.id }

  validates :challenge_id, presence: true,
                           inclusion: { in: challenges_array }

  validates :group, presence: true,
                    inclusion: { in: Team.groups.keys }

  validates :nominal_start_time, presence: true,
                                 uniqueness: true

  validates_each :nominal_start_time, :actual_start_time,
                 :phone_in_time, :finish_time do |record, attr, value|

    unless value.nil?
      unless value =~ /\A(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]\z/
        record.errors.add(attr, 'must be a valid 24-hour time')
      end
    end

  end

end
