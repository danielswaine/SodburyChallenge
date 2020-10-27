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

    context 'when setting goal type' do
      it 'should validate that it cannot be a start and compulsory' do
        goal = build_stubbed(:goal, start_point: true, compulsory: true)
        goal.valid?
        expect(goal.errors[:base]).to eq(
          ['A goal cannot be both a start point and compulsory.']
        )
      end
    end

    context 'when validating if checkpoint used before' do
      it 'should validate that the goal has not been added previously' do
        challenge = create(:challenge)
        create(:goal, challenge: challenge)
        new_goal = build_stubbed(:goal, checkpoint_id: 1, challenge: challenge)
        new_goal.valid?
        expect(new_goal.errors[:checkpoint_id]).to eq(
          ['already exists on this challenge.']
        )
      end

      it 'should allow goal even if used in another challenge' do
        old_challenge = create(:challenge)
        create(:goal, challenge: old_challenge)
        new_challenge = create(:challenge)
        new_goal = build_stubbed(
          :goal, checkpoint_id: 1, challenge: new_challenge
        )
        new_goal.valid?
        expect(new_goal.errors[:checkpoint_id]).to eq([])
      end
    end
  end
end
