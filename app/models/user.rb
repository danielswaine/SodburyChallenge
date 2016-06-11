# TODO: Rename :email table column to :email_address.
# TODO: Add a `novalidate` attribute to the User forms so to prevent the
#   Bootstrap email validator running in addition to the Rails ones. Also add
#   integration tests to verify that this is working!
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
