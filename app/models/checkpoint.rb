class Checkpoint < ActiveRecord::Base

  validates :number, presence: true,
                     uniqueness: true,
                     numericality: {
                                     greater_than_or_equal_to: 1,
                                     only_integer: true
                                   }

  validates :grid_reference, presence: true

  validates_each :grid_reference do |record, attr, value|
    if value =~ /\A\d{4}-\d{4}\z/
      if value =~ /\d{3}[1-46-9]/
        record.errors.add(attr, 'parts must end in a 0 or a 5')
      end
    else
      record.errors.add(attr, 'must look like 2345-7890')
    end
  end

  validates :description, presence: true,
                          length: { maximum: 375 }

end
