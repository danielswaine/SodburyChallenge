require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) { create(:user) }
  subject { build_stubbed(:user) }

  context 'when given a new name' do
    it 'removes surplus whitespace' do
      user = build_stubbed(:user, name: "   Some  Random \tPerson  \r\n ")
      user.valid?
      expect(user.name).to eq('Some Random Person')
    end

    it { is_expected.to validate_presence_of(:name) }

    it do
      is_expected.to validate_length_of(:name)
        .is_at_least(3).with_short_message('is too short')
        .is_at_most(30).with_long_message('is too long')
    end

    it { is_expected.to gracefully_handle_blank(:name) }
  end

  context 'when given a new email address' do
    it 'removes leading and trailing whitespace' do
      user = build_stubbed(:user, email: %( "example user"@website.com  \r\n))
      user.valid?
      expect(user.email).to eq('"example user"@website.com')
    end

    it 'converts the domain part to lower-case (simple address)' do
      user = build_stubbed(:user, email: 'Alpha.Beta@Gamma.COM')
      user.valid?
      expect(user.email).to eq('Alpha.Beta@gamma.com')
    end

    it 'converts the domain part to lower-case (complex address)' do
      original = 'Alpha.Beta."@Gamma@".Delta@Kappa.NET(Comment (with an @))'
      normalised = 'Alpha.Beta."@Gamma@".Delta@kappa.net(Comment (with an @))'

      user = build_stubbed(:user, email: original)
      user.valid?
      expect(user.email).to eq(normalised)
    end

    it { is_expected.to validate_presence_of(:email) }

    it do
      is_expected.to validate_email_format_of(:email)
        .with_message("doesn't appear to be valid")
    end

    it { is_expected.to gracefully_handle_blank(:email) }

    it do
      is_expected.to validate_uniqueness_of(:email)
        .ignoring_case_sensitivity
        .with_message('is already registered')
    end
  end

  # `has_secure_password` ensures that password is present on creation, and
  # that it does not exceed a maximum length. It also checks that password
  # matches password confirmation *if password confirmation is not nil*.
  it { is_expected.to have_secure_password }

  context 'when given a new password' do
    # Similar to a common password. Should probably be invalid.
    COMMON_PASSWORDS = [
      'Qw3rty1?',
      '_d4rkne55',
      'password 12345',
      'mOnKeY96969'
    ].freeze

    # Rated yellow-green according to the Password Assistant that's built in to
    # Mac OS X. Should probably be valid.
    COMPLEX_PASSWORDS = [
      'Ku3}Boca',
      'HAe6rxKQ',
      '713644618219179',
      'stwsNj_R',
      'ahtikiozoewenyofosdev',
      'louise radar'
    ].freeze

    # Rated orange-yellow according to OS X. Should probably be invalid.
    SIMPLE_PASSWORDS = [
      'To.5put',
      '7ps45b5',
      '007662063102',
      's}[_WV',
      'issynryy',
      'on 6th'
    ].freeze

    it do
      is_expected.not_to allow_values(*COMMON_PASSWORDS).for(:password)
        .with_message('is not strong enough')
    end

    it { is_expected.to allow_values(*COMPLEX_PASSWORDS).for(:password) }

    it do
      is_expected.not_to allow_values(*SIMPLE_PASSWORDS).for(:password)
        .with_message('is not strong enough')
    end

    it "doesn't check complexity when :password is nil" do
      user = build_stubbed(:user, password: nil)
      user.valid?
      expect(user.errors[:password]).to eq(["can't be blank"])
    end

    it "doesn't check complexity when :password is empty" do
      user = build_stubbed(:user, password: '')
      user.valid?
      expect(user.errors[:password]).to eq(["can't be blank"])
    end

    it "doesn't check complexity when :password is blank" do
      user = build_stubbed(:user, password: ' ')
      user.valid?
      expect(user.errors[:password]).to eq(["can't be blank"])
    end
  end
end
