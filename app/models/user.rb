class User < ActiveRecord::Base

  # Adds authentication functionality.
  has_secure_password

  before_save { self.email = email.downcase }

  validates :name, length: {
                             in: 3..70,
                             too_short: 'is too short',
                             too_long: 'is too long'
                           }

  validates_each :name do |record, attr, value|
    if value =~ /[^[[:alpha:]]., -]/
      record.errors.add(attr, 'contains invalid characters')
    elsif value =~ /(\A[., -]|\.[[[:alpha:]].-]|,[[[:alpha:]].,-]| [., -]|-[., -]|[, -]\z)/
      record.errors.add(attr, 'contains invalid punctuation')
    end
  end

  validates :email, uniqueness: { case_sensitive: false },
                    length: {
                              in: 6..320,
                              too_short: 'address is too short',
                              too_long: 'address is too long'
                            }

  validates_each :email do |record, attr, value|

    # Form helper takes care of most of the RFC3696 complaince.

    if value =~ /@.+\..+/
      if value =~ /\A\./
        record.errors.add(attr, 'address cannot start with a period')
      elsif value =~ /\.@/
        record.errors.add(attr, 'address cannot contain \'.@\'')
      elsif value =~ /\.{2,}/
        record.errors.add(attr, 'address cannot contain consecutive periods')
      end
    else
      record.errors.add(attr, 'address must be fully qualified')
    end

  end

  validates :password, allow_nil: true,
                       length: { in: 8..40 }

  validates_each :password do |record, attr, value|

    unless value.nil?
      if value =~ /[^[[:alpha:]]]/
        if value =~ /[^ -~]/
          record.errors.add(attr, 'contains invalid characters')
        end
      else
        record.errors.add(attr, 'must contain a number or symbol')
      end
    end

  end

end
