require 'rails_helper'

RSpec.describe Challenge, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:goals) }

    it { is_expected.to have_many(:checkpoints).through(:goals) }

    it do
      is_expected.to have_many(:teams)
        .inverse_of(:challenge)
        .dependent(:destroy)
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:date) }

    context 'when given a new time allowed value' do
      it do
        should validate_numericality_of(:time_allowed)
          .is_greater_than(0)
          .only_integer
          .with_message('must be an integer number of hours')
      end
    end

    # Valid bonus formats.
    VALID_BONUS_FORMATS = [
      # Based on total checkpoints.
      '{ visit: 1, value: 1 }',
      '{ visit: 10, value: 50 }',
      '{ visit: 999, value: 99 }',
      # Based on visiting a specific subset of checkpoints.
      '{ visit: [1], value: 1 }',
      '{ visit: [1, 99], value: 50 }',
      '{ visit: [1, 99, 999], value: 99 }'
    ].freeze

    # Invalid total checkpoints visited bonus format.
    INVALID_BONUS_FORMATS = [
      # Based on total checkpoints.
      '{ visit: 0, value: 1 }',
      '{ visit: 01, value: 10 }',
      '{ visit: 001, value: 200 }',
      '{ visit: 1, value: 0 }',
      '{ visit: 10, value: 01 }',
      '{ visit: 100, value: 001 }',
      # Based on visiting a specific subset of checkpoints.
      '{ visit: [0, 1, 10], value: 1}',
      '{ visit: [1, 01, 10], value: 50}',
      '{ visit: [1, 10, 001], value: 900}',
      '{ visit: [1, 50, 99], value: 0}',
      '{ visit: [1, 50, 99], value: 01}',
      '{ visit: [1, 50, 99], value: 001}'
    ].freeze

    # Invalid characters in bonus string.
    INVALID_BONUS_CHARACTER_FORMATS = [
      # Based on total checkpoints.
      '{ visit: 1-, value: 1 }',
      '{ visit: 10, value: 50! }',
      '{ visit: 99;9, value: 99 }',
      # Based on visiting a specific subset of checkpoints.
      '{ visit: [1@], value: 1 }',
      '{ visit: [1, 99], value: (50 }',
      '{ visit: [1, 99, 999"], value: 99 }'
    ].freeze

    BONUS_ATTRIBUTES = %i[bonus_one bonus_two bonus_three
                          bonus_four bonus_five].freeze
    TEST_BONUS_STRING = '{ visit: [1, 99, 999], value: 99 }'.freeze

    context 'when given a new bonus' do
      BONUS_ATTRIBUTES.each do |bonus|
        it { is_expected.to allow_values(*VALID_BONUS_FORMATS).for(bonus) }

        it do
          is_expected.not_to allow_values(*INVALID_BONUS_FORMATS)
            .for(bonus)
            .with_message('does not have a valid format')
        end

        it do
          is_expected.not_to allow_values(*INVALID_BONUS_CHARACTER_FORMATS)
            .for(bonus)
            .with_message('contains invalid characters')
        end

        it 'prettifies the bonus string' do
          challenge = create(:challenge)
          challenge.update_attribute(bonus, TEST_BONUS_STRING)
          challenge.valid?
          expect(challenge[bonus]).to eq(TEST_BONUS_STRING)
        end
      end
    end
  end

  describe '.find_goals_from_same_challenge_date' do
    context 'with goal from one challenge' do
      it 'should include the goal data' do
        challenge = create(:challenge)
        goal = create(:goal, challenge: challenge)
        expect(Challenge.find_goals_from_same_challenge_date(challenge.date)).to eq(
          [
            {
              number: goal.checkpoint.number,
              grid_reference: goal.checkpoint.grid_reference,
              description: goal.checkpoint.description,
              points_value: [{
                time_allowed: goal.challenge.time_allowed,
                points_value: goal.points_value,
                start: goal.start_point,
                compulsory: goal.compulsory
              }]
            }
          ]
        )
      end
    end

    context 'with same goal on different challenge dates' do
      it 'should include the goal data from one challenge' do
        challenge = create(:challenge, date: Date.today)
        challenge1 = create(:challenge, date: Date.today - 1.day)
        goal = create(:goal, challenge: challenge)
        create(:goal, challenge: challenge1)
        expect(Challenge.find_goals_from_same_challenge_date(challenge.date)).to eq(
          [
            {
              number: goal.checkpoint.number,
              grid_reference: goal.checkpoint.grid_reference,
              description: goal.checkpoint.description,
              points_value: [{
                time_allowed: goal.challenge.time_allowed,
                points_value: goal.points_value,
                start: goal.start_point,
                compulsory: goal.compulsory
              }]
            }
          ]
        )
      end
    end

    context 'with same goal in multiple challenges' do
      it 'should format all goals' do
        checkpoint = create(:checkpoint)
        challenge = create(:challenge, date: Date.today)
        challenge2 = create(:challenge, :eight_hour, date: Date.today)
        goal  = create(:goal, checkpoint: checkpoint, challenge: challenge)
        goal2 = create(:goal, checkpoint: checkpoint, challenge: challenge2, points_value: 20)
        expect(Challenge.find_goals_from_same_challenge_date(challenge.date)).to eq(
          [
            {
              number: goal.checkpoint.number,
              grid_reference: goal.checkpoint.grid_reference,
              description: goal.checkpoint.description,
              points_value: [
                {
                  time_allowed: goal.challenge.time_allowed,
                  points_value: goal.points_value,
                  start: goal.start_point,
                  compulsory: goal.compulsory
                },
                {
                  time_allowed: goal2.challenge.time_allowed,
                  points_value: goal2.points_value,
                  start: goal2.start_point,
                  compulsory: goal2.compulsory
                }
              ]
            }
          ]
        )
      end
    end

    context 'with start goal' do
      it 'should format data as start' do
        challenge = create(:challenge)
        goal = create(:goal, :start_point, challenge: challenge)
        expect(Challenge.find_goals_from_same_challenge_date(challenge.date)).to eq(
          [
            {
              number: goal.checkpoint.number,
              grid_reference: goal.checkpoint.grid_reference,
              description: goal.checkpoint.description,
              points_value: [{
                time_allowed: goal.challenge.time_allowed,
                points_value: goal.points_value,
                start: goal.start_point,
                compulsory: goal.compulsory
              }]
            }
          ]
        )
      end
    end

    context 'with compulsory goal' do
      it 'should format data as compulsory' do
        challenge = create(:challenge)
        goal = create(:goal, :compulsory, challenge: challenge)
        expect(Challenge.find_goals_from_same_challenge_date(challenge.date)).to eq(
          [
            {
              number: goal.checkpoint.number,
              grid_reference: goal.checkpoint.grid_reference,
              description: goal.checkpoint.description,
              points_value: [{
                time_allowed: goal.challenge.time_allowed,
                points_value: goal.points_value,
                start: goal.start_point,
                compulsory: goal.compulsory
              }]
            }
          ]
        )
      end
    end
  end
end
