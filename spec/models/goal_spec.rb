require 'rails_helper'

RSpec.describe Goal, type: :model do
  subject { build_stubbed(:goal) }

  describe 'associations' do
    it { is_expected.to belong_to(:challenge) }

    it { is_expected.to belong_to(:checkpoint) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:challenge_id) }

    it { is_expected.to validate_presence_of(:checkpoint_id) }

    context 'when given a new points value' do
      it do
        should validate_numericality_of(:points_value)
          .is_greater_than_or_equal_to(0)
          .only_integer
          .with_message('must be a non-negative integer')
      end
    end
  end
end
