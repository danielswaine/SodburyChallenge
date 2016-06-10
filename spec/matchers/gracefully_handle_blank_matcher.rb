# Test whether a model gracefully handles blank values for a certain attribute.
#
# 'Gracefully' in this context means that a single error message will be raised
# when a blank value is supplied. This is designed to be used with attributes
# that have both their presence and format validated, but where it is desired
# that the format validation only takes place if the value is non-blank.
#
# By default, the matcher expects the error message to be "can't be blank".
# An alternative error message can be supplied by chaining `with_message`.
#
# @example A User class with an email address
#   class User
#     include ActiveModel::Model
#     attr_accessor :email_address
#
#     validates_presence_of :email_address
#     validates_email_format_of :email_address, if: 'email_address.present?'
#   end
#
#   RSpec.describe User do
#     it { is_expected.to validate_presence_of(:email_address) }
#     it { is_expected.to validate_email_format_of(:email_address) }
#
#     # This example would fail without the `:if` option in the model.
#     it { is_expected.to gracefully_handle_blank(:email_address) }
#   end
RSpec::Matchers.define :gracefully_handle_blank do |attribute|
  # These values will all respond `true` to `blank?`, and are chosen to be
  # agnostic of general length requirements.
  BLANKS = {
    the_value_nil:       nil,
    an_empty_string:     '',
    a_single_space:      ' ',
    ten_spaces:          ' ' * 10,
    one_hundred_spaces:  ' ' * 100,
    one_thousand_spaces: ' ' * 1000
  }.freeze

  chain(:with_message) do |message|
    @message = message
  end

  match do |model|
    @attribute = attribute
    @model = model

    @errors = []
    @message ||= "can't be blank"

    BLANKS.each { |description, value| try_with(value, description) }

    @errors.empty?
  end

  failure_message do
    message = %Q(
      expected blank values of #{@attribute.inspect} to be invalid, with
      exactly one error that matches #{@message.inspect}, but found that:
    ).gsub(/^\s*/, '')
    message << '- ' << @errors.join("\n- ")
  end

  description do
    "handle blank values of #{@attribute.inspect} gracefully"
  end

  # Add an error message to the `@errors` array.
  #
  # @param description [String] a String representation of the attribute value
  #   that was tested.
  # @param message [String] an explanation of why the test failed.
  # @return [void]
  # @private
  def add_error(description, message)
    @errors.push(description.to_s.humanize.downcase << ' ' << message)
  end

  # Run validations on `@model` with the supplied value for `@attribute`.
  #
  # Adds an error message if the value is valid; if it caused more than one
  # error message; or if the resulting error message doesn't match the string
  # supplied via `with_message` (if any) or the default string "can't be
  # blank".
  #
  # @param value [#blank?] the attribute value to be tested.
  # @return [void]
  # @private
  def try_with(value, description)
    @model[@attribute] = value

    if @model.valid?
      add_error(description, 'was valid')
    elsif (count = @model.errors.size) != 1
      add_error(description, "caused #{count} error messages")
    elsif @message
      actual_message = @model.errors.messages[@attribute].first

      unless actual_message.include?(@message)
        add_error(description, "caused the message #{actual_message.inspect}")
      end
    end
  end
end
