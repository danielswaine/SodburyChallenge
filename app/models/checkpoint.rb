class Checkpoint < ActiveRecord::Base
  has_many :goals
  has_many :challenges, through: :goals

  def to_param
    number.to_s
  end

  validates :number, uniqueness: true,
                     numericality: {
                                     greater_than_or_equal_to: 1,
                                     only_integer: true,
                                     message: 'must be a positive integer'
                                   }

  validates_each :grid_reference do |record, attr, value|
    if value =~ /\A\d{4}-\d{4}\z/
      if value =~ /\d{3}[1-46-9]/
        record.errors.add(attr, 'parts must end in a 0 or a 5')
      end
    else
      record.errors.add(attr, 'must look like 2345-7890')
    end
  end

  validates :description, length: {
                                    in: 5..400,
                                    too_short: 'is too short',
                                    too_long: 'is too long'
                                  }

end
