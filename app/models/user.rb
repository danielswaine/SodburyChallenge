# TODO: Rename :email table column to :email_address.
class User < ActiveRecord::Base
  # Add authentication functionality.
  has_secure_password

  # Validate name.
  validates :name, presence: true
  validates(
    :name,
    length: {
      in: 3..70,
      too_short: 'is too short',
      too_long: 'is too long'
    },
    if: 'name.present?'
  )
  # validates_each :name do |record, attr, value|
  #   if value =~ /[^[[:alpha:]]., -]/
  #     record.errors.add(attr, 'contains invalid characters')
  #   elsif value =~ /(\A[., -]|\.[[[:alpha:]].-]|,[[[:alpha:]].,-]| [., -]|-[., -]|[, -]\z)/
  #     record.errors.add(attr, 'contains invalid punctuation')
  #   end
  # end

  # Validate email address.
  before_save { self.email = email.downcase }
  validates(
    :email,
    presence: true,
    uniqueness: {
      case_sensitive: false,
      message: 'is already registered'
    }
  )
  validates_email_format_of(
    :email,
    message: "doesn't appear to be valid",
    if: 'email.present?'
  )

  # Validate password.
  validates :password, allow_nil: true, length: { in: 8..40 }
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
