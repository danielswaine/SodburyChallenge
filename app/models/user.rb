class User < ActiveRecord::Base

  # TODO: Rename :email table column to :email_address.

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

  validates(
    :email,
    presence: true,
    length: {
      in: 6..320,
      too_short: 'is too short',
      too_long: 'is too long'
    },
    uniqueness: {
      case_sensitive: false,
      message: 'is already registered'
    }
  )

  validates_each :email do |record, attr, value|

    # Form helper takes care of most of the RFC3696 complaince.

    if value =~ /.{65,}@/
      record.errors.add(attr, "has too many characters before the '@'")
    elsif value =~ /@.+\..{2,}\z/
      if value =~ /\A\./
        record.errors.add(attr, 'cannot start with a period')
      elsif value =~ /\.@/
        record.errors.add(attr, 'cannot contain \'.@\'')
      elsif value =~ /\.{2,}/
        record.errors.add(attr, 'cannot contain consecutive periods')
      end
    else
      record.errors.add(attr, 'must be fully qualified')
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
