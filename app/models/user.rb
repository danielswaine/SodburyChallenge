# TODO: Rename :email table column to :email_address.
class User < ActiveRecord::Base
  # Add authentication functionality.
  has_secure_password

  # Validate name.
  validates :name, presence: true
  validates(
    :name,
    length: {
      in: 3..30,
      too_short: 'is too short',
      too_long: 'is too long'
    },
    if: 'name.present?'
  )

  # Normalise email addresses by converting their domain part to lower-case.
  before_validation do
    email.sub!(/(?<=@)[^@]*?(?=(?:\(.*\))?\z)/, &:downcase) unless email.nil?
  end

  # Validate email address.
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
