require 'rails_helper'

RSpec.describe User, type: :model do
  before(:all) { create(:user) }
  subject { build_stubbed(:user) }

  context 'when given a new name' do
    it { is_expected.to validate_presence_of(:name) }

    it do
      is_expected.to validate_length_of(:name)
        .is_at_least(3).with_short_message('is too short')
        .is_at_most(30).with_long_message('is too long')
    end

    it { is_expected.to gracefully_handle_blank(:name) }
  end

  context 'when given a new email address' do
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
  end
end
