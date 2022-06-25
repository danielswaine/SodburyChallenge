class Challenge < ActiveRecord::Base
  has_many :goals
  has_many :checkpoints, through: :goals
  has_many :teams, inverse_of: :challenge, dependent: :destroy

  validates :date, presence: true

  validates :time_allowed, presence: true
  validates(
    :time_allowed,
    numericality: {
      greater_than: 0,
      only_integer: true,
      message: 'must be an integer number of hours'
    },
    if: 'time_allowed.present?'
  )

  validates_each :bonus_one, :bonus_two, :bonus_three,
                 :bonus_four, :bonus_five do |record, attr, value|
    unless value.to_s.empty?
      if value =~ /[^{ }a-z:,0-9\[\]]/
        record.errors.add(attr, 'contains invalid characters')
      elsif value =~ /\A\{ *visit: *[1-9][0-9]* *, *value: *[1-9][0-9]* *}\z/
        # Valid bonus, based on total checkpoints visited.
      elsif value =~ /\A\{ *visit: *\[ *([1-9][0-9]* *, *)*[1-9][0-9]* *\] *, *value: *[1-9][0-9]* *}\z/
        # Valid bonus, based on visiting a specific subset of checkpoints.
      else
        record.errors.add(attr, 'does not have a valid format')
      end
    end
  end

  before_save do
    self.bonus_one = prettify(bonus_one) unless bonus_one.to_s.empty?
    self.bonus_two = prettify(bonus_two) unless bonus_two.to_s.empty?
    self.bonus_three = prettify(bonus_three) unless bonus_three.to_s.empty?
    self.bonus_four = prettify(bonus_four) unless bonus_four.to_s.empty?
    self.bonus_five = prettify(bonus_five) unless bonus_five.to_s.empty?
  end

  def self.find_goals_from_same_challenge_date(date)
    goals = where(date: date).map(&:goals).flatten
    goals.group_by(&:checkpoint_id).map do |_group, array|
      {
        number: array.first.checkpoint.number,
        grid_reference: array.first.checkpoint.grid_reference,
        description: array.first.checkpoint.description,
        points_value:
          array.map do |a|
            {
              time_allowed: a.challenge.time_allowed,
              points_value: a.points_value,
              start: a.start_point,
              compulsory: a.compulsory
            }
          end
      }
    end.flatten
  end

  private

  def prettify(bonuses_string)
    bonuses_hash = eval(bonuses_string)
    "{ visit: #{bonuses_hash[:visit]}, value: #{bonuses_hash[:value]} }"
  end
end
