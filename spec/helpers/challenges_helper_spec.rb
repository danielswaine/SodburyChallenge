require 'rails_helper'

RSpec.describe ChallengesHelper, type: :helper do
  describe 'points_available' do
    let(:challenge) { create(:challenge) }

    HELPER_BONUSES = [:bonus_one, :bonus_two, :bonus_three,
                        :bonus_four, :bonus_five].freeze
    HELPER_BONUS_STRING = '{ visit: [1, 2], value: 10 }'.freeze

    context 'when no goals' do
      it 'should only return baseline score' do
        expect(points_available(challenge)).to eq(60)
      end
    end

    context 'when challenge only has goals' do
      it 'should return baseline score plus goal scores' do
        create(:goal, challenge: challenge)
        expect(points_available(challenge)).to eq(70)
      end
    end

    context 'when challenge only has bonuses' do
      HELPER_BONUSES.each do |bonus|
        it 'should return baseline score plus bonuses' do
          challenge.update_attribute(bonus, HELPER_BONUS_STRING)
          expect(points_available(challenge)).to eq(70)
        end
      end
    end

    context 'when challenge has goals and bonuses' do
      HELPER_BONUSES.each do |bonus|
        it 'should return baseline score plus goal scores plus bonuses' do
          challenge.update_attribute(bonus, HELPER_BONUS_STRING)
          create(:goal, challenge: challenge)
          expect(points_available(challenge)).to eq(80)
        end
      end
    end
  end
end
