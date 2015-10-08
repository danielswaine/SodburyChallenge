class Challenge < ActiveRecord::Base
  has_many :goals
  has_many :checkpoints, through: :goals
  has_many :teams, inverse_of: :challenge, dependent: :destroy

  validates :date, presence: true

  validates :time_allowed, numericality: {
                                     greater_than: 0,
                                     only_integer: true,
                                     message: 'must be an integer number of hours'
                                   }

  validates_each :bonus_one, :bonus_two, :bonus_three,
                 :bonus_four, :bonus_five do |record, attr, value|

    unless value.empty?
      if value =~ /[^{ }a-z:,0-9\[\]]/
        record.errors.add(attr, 'contains invalid characters')
      elsif value =~ /\A\{ ?visit: ?[1-9][0-9]* ?, ?value: ?[1-9][0-9]* ?}\z/
        # Valid bonus, based on total checkpoints visited.
      elsif value =~ /\A\{ ?visit: ?\[ ?([1-9][0-9]*, ?)*[1-9][0-9]* ?\] ?, ?value: ?[1-9][0-9]* ?}\z/
        # Valid bonus, based on visiting a specific subset of checkpoints.
      else
        record.errors.add(attr, 'does not have a valid format')
      end
    end

  end

end
