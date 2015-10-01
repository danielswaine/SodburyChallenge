class User < ActiveRecord::Base
  # Adds authentication functionality.
  has_secure_password

  before_save { self.email = email.downcase }

  validates :name, presence: true,
                   length: { maximum: 70 }

  validates_each :name do |record, attr, value|
    if value =~ /[^[[:alpha:]]., -]/
      record.errors.add(attr, 'contains invalid characters')
    elsif value =~ /(\A[., -]|\.[[[:alpha:]].-]|,[[[:alpha:]].,-]| [., -]|-[., -]|[, -]\z)/
      record.errors.add(attr, 'contains invalid punctuation')
    end
  end

  validates :email, presence: true,
                    length: { maximum: 320 },
                    uniqueness: { case_sensitive: false }

  validates_each :email do |record, attr, value|
    # Form helper takes care of most of the RFC3696 complaince.
    record.errors.add(attr, 'address cannot start with a period') if value =~ /\A\./
    record.errors.add(attr, 'address cannot contain \'.@\'') if value =~ /\.@/
    record.errors.add(attr, 'address cannot contain consecutive periods') if value =~ /\.{2,}/
    record.errors.add(attr, 'address must be fully qualified') unless value =~ /@.+\..+/
  end

  validates :password, presence: true,
                       length: { in: 8..40 },
                       allow_nil: true

  validates_each :password do |record, attr, value|
    record.errors.add(attr, 'must contain a number or symbol') unless value =~ /[^[[:alpha:]]]/
    record.errors.add(attr, 'contains invalid characters') if value =~ /[^ -~]/
  end
end
