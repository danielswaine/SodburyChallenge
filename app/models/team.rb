class Team < ActiveRecord::Base
  belongs_to :challenge, inverse_of: :teams

  enum group: [:scouts, :explorers, :non_competitive]

  before_save do

    self.name = name.titleize

    if visited
      self.visited = eval("[#{visited}]").uniq.sort.to_s.tr('[]', '')
    end

    calculate_score

  end

  validates :name, length: {
                             in: 5..70,
                             too_short: 'is too short',
                             too_long: 'is too long'
                           },
                   format: {
                             with: /\A[ -~]*\z/,
                             message: 'contains invalid characters'
                           }

  validates :challenge_id, presence: true

  validates :group, presence: true,
                    inclusion: { in: Team.groups.keys }

  validates :planned_start_time, presence: true,
                                 uniqueness: true

  validates_each :planned_start_time, :actual_start_time,
                 :phone_in_time, :finish_time do |record, attr, value|

    unless value.empty?
      unless value =~ /\A(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]\z/
        record.errors.add(attr, 'must be a valid 24-hour time')
      end
    end

  end

  validates :score, allow_blank: true, numericality: {
                                         only_integer: true,
                                         message: 'must be an integer'
                                       }

  validates_each :visited do |record, attr, value|
    unless value.to_s.empty?
      if value =~ /\A *([1-9][0-9]* *, *)*[1-9][0-9]* *\z/
        # Valid checkpoint list.
      elsif value =~ /[^0-9, ]/
        record.errors.add(attr, 'checkpoints list contains invalid characters')
      else
        record.errors.add(attr, 'checkpoints must be a comma-separated list')
      end
    end
  end

  private

    def calculate_score

      total_points = 30  # All teams start with 30 points.

      challenge.goals.each do |goal|
        if goal.compulsory?
          disqualify unless visited? goal.checkpoint.number
        end
        total_points += goal.points_value if visited? goal.checkpoint.number
      end

      bonuses = [
                  eval(challenge.bonus_one.to_s),
                  eval(challenge.bonus_two.to_s),
                  eval(challenge.bonus_three.to_s),
                  eval(challenge.bonus_four.to_s),
                  eval(challenge.bonus_five.to_s)
                ]

      bonuses.each do |bonus|
        succeeded = false
        if bonus && bonus[:visit].is_a?(Array)  # Bonus based on specific checkpoints.
          succeeded = bonus[:visit].reduce(true) do |memo, checkpoint_number|
            memo && visited?(checkpoint_number)
          end
        elsif bonus  # Bonus based on total number of checkpoints.
          succeeded = eval("[#{visited}]").uniq.size >= bonus[:visited]
        end
        total_points += succeeded ? bonus[:value] : 0
      end

    end

    def visited?(checkpoint_number)
      visited_checkpoints = eval("[#{visited}]")
      visited_checkpoints.include? checkpoint_number
    end

    def disqualify
      self.disqualified = true
    end

end
