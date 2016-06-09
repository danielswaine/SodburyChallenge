require 'rails_helper'

RSpec.describe User, type: :model do
  before(:all) { create(:user) }
  subject { build_stubbed(:user) }

  context 'when given a new email address' do
    it { is_expected.to validate_presence_of(:email) }

    it do
      is_expected.to validate_uniqueness_of(:email)
        .ignoring_case_sensitivity
        .with_message('is already registered')
    end

    # Shortest possible email is `a@b.cd` (6 characters). Longest has 64
    # characters before the `@` and 255 after it (320 characters).
    it do
      is_expected.to validate_length_of(:email)
        .is_at_least(6).with_short_message('is too short')
        .is_at_most(320).with_long_message('is too long')
    end

    it 'converts the address to lowercase' do
      raw_email = 'User-99@eXample.COM'
      user = create(:user, email: raw_email)

      expect(user.email).to eq(raw_email.downcase)
    end

    it do
      is_expected.to allow_values(
        'A_US-ER@foo.bar.org',
        'USER@foo.COM',
        'alice+bob@baz.cn',
        'first.last@foo.jp',
        'user99@example.com'
      ).for(:email)
    end

    # Rails provides an email form helper which prevents the vast majority of
    # invalid email formats from being submitted, and gives the user a
    # (generally) helpful pop-over explaining why.
    #
    # There is no point in duplicating this behaviour in the model: it would be
    # tedious to implement, and only beneficial when manipulating email
    # addresses programmatically or interactively via the command line, which
    # there is almost never a need to do.
    #
    # There are a relatively small number of invalid email address formats that
    # the form helper misses, though, and these should be rejected with an
    # appropriate error message.
    context "that the form helper won't catch" do
      it do
        is_expected.not_to allow_value('user1' * 13 + '@example.com')
          .for(:email)
          .with_message("has too many characters before the '@'")
      end

      it do
        is_expected.not_to allow_value('user2@localhost')
          .for(:email)
          .with_message('must be fully qualified')
      end

      it do
        is_expected.not_to allow_value('user3@local.h')
          .for(:email)
          .with_message('must be fully qualified')
      end

      it do
        is_expected.not_to allow_value('.foo@bar.baz')
          .for(:email)
          .with_message('cannot start with a period')
      end

      it do
        is_expected.not_to allow_value('name.@example.com')
          .for(:email)
          .with_message("cannot contain '.@'")
      end

      it do
        is_expected.not_to allow_value('foo..bar@baz.qux')
          .for(:email)
          .with_message('cannot contain consecutive periods')
      end
    end
  end
end
