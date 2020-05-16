class Checkpoint < ActiveRecord::Base
  has_many :goals
  has_many :challenges, through: :goals

  # Use number to construct the URL to this object.
  def to_param
    number.to_s
  end

  before_validation do
    # Remove surplus whitespace from the description.
    description.squish! if description.present?
  end

  # Validate number.
  validates :number, presence: true
  validates(
    :number,
    uniqueness: true,
    numericality: {
      greater_than_or_equal_to: 1,
      only_integer: true,
      message: 'must be a positive integer'
    },
    if: 'number.present?'
  )

  # Validate grid reference.
  validates_each :grid_reference do |record, attr, value|
    if value =~ /\A\d{4}-\d{4}\z/
      if value =~ /\d{3}[1-46-9]/
        record.errors.add(attr, 'parts must end in a 0 or a 5')
      end
    else
      record.errors.add(attr, 'must look like 2345-7890')
    end
  end

  # Validate description.
  validates :description, presence: true
  validates(
    :description,
    length: {
      in: 5..400,
      too_short: 'is too short',
      too_long: 'is too long'
    },
    if: 'description.present?'
  )
end
