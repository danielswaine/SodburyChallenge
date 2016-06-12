# App users can manage the list of checkpoints, challenges and teams. They can
# also submit scores and add and remove other users.
#
# TODO: Rename :email table column to :email_address.
class User < ActiveRecord::Base
  # Add authentication functionality.
  has_secure_password

  # Perform basic input normalisation prior to validation.
  before_validation do
    # Remove surplus whitespace from the name.
    name.squish! if name.present?

    # Remove leading and trailing whitespace from the email address, and
    # convert the domain part to lower-case.
    #
    # The regex matches everything from just after the last non-comment `@`
    # until the last domain-name character.
    if email.present?
      self.email = email.strip.sub(/(?<=@)[^@]*?(?=(?:\(.*\))?\z)/, &:downcase)
    end
  end

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
  validates(
    :password,
    presence: true,
    # HACK: `has_secure_password` implements presence validation for nil and
    #   empty passwords, but *not* for non-empty blanks like ' '.
    unless: 'password.nil? || password.empty?'
  )
  validates :password, length: { minimum: 8 }, if: 'password.present?'
end
