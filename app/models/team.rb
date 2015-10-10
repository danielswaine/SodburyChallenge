class Team < ActiveRecord::Base
  belongs_to :challenge, inverse_of: :teams

  enum group: [:scouts, :explorers, :non_competitive]

  before_save do
    self.name = name.titleize
    if visited
      self.visited = eval("[#{visited}]").to_s.tr('[]', '')
    end
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

end
