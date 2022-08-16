require 'rails_helper'

RSpec.describe Team, type: :model do
  subject { build_stubbed(:team) }
  let(:groups) do
    [:scouts, :explorers, :non_competitive,
     :network, :leaders, :guides, :rangers]
  end

  describe 'associations' do
    it { is_expected.to belong_to(:challenge).inverse_of(:teams) }

    it do
      is_expected.to have_many(:members).inverse_of(:team).dependent(:destroy)
    end
  end

  describe 'validations' do
    context 'when given a new name' do
      it 'it tidies the format' do
        team = create(:team, name: 'a RandomTeam_name')
        team.valid?
        expect(team.name).to eq('A Random Team Name')
      end

      it { is_expected.to validate_presence_of(:name) }

      it do
        is_expected.to validate_length_of(:name)
          .is_at_least(5).with_short_message('is too short')
          .is_at_most(70).with_long_message('is too long')
      end

      # Non-ascii character?
      it 'should not allow invalid characters'
    end

    context 'when given visited checkpoints' do
      it 'tidies the given values' do
        team = create(:team, visited: '  1, 5,2,1  ,9 ,5')
        team.valid?
        expect(team.visited).to eq('1, 2, 5, 9')
      end

      VALID_VISITED_CHECKPOINTS = [
        '1, 2, 3, 4, 5',
        '1,2,3,4,5',
        '1 ,2,3 ,4,5'
      ].freeze

      NON_CSV_VISITED_CHECKPOINTS = [
        ',1 ,2,3 ,4,5',
        '1,2 ,3,4, 5,'
      ].freeze

      INVALID_CHARS_IN_VISITED_CHECKPOINTS = [
        '!,1,2,3, 4,5',
        '1,2,@,3,4,5',
        '1;,2,3,4,5'
      ].freeze

      it do
        is_expected.to allow_values(*VALID_VISITED_CHECKPOINTS).for(:visited)
      end

      it do
        is_expected.not_to allow_values(*NON_CSV_VISITED_CHECKPOINTS)
          .for(:visited)
          .with_message('checkpoints must be a comma-separated list')
      end

      it do
        is_expected.not_to allow_values(*INVALID_CHARS_IN_VISITED_CHECKPOINTS)
          .for(:visited)
          .with_message('checkpoints list contains invalid characters')
      end
    end

    it { is_expected.to validate_presence_of(:challenge_id) }

    context 'when given a new group' do
      it do
        is_expected.to define_enum_for(:group).with(groups)
      end

      it { is_expected.to validate_presence_of(:group) }
    end

    context 'when given a new time' do
      VALID_TIMES = [
        '00:00',
        '09:00',
        '10:00',
        '19:00',
        '20:00',
        '23:00',
        '10:00',
        '10:09',
        '10:50',
        '10:59'
      ].freeze

      INVALID_TIMES = [
        '24:00',
        '29:00',
        '31:00',
        '41:00',
        '51:00',
        '61:00',
        '71:00',
        '81:00',
        '91:00',
        '00:60',
        '00:70',
        '00:80',
        '00:90'
      ].freeze

      it { is_expected.to validate_presence_of(:planned_start_time) }

      [:planned_start_time, :actual_start_time, :phone_in_time, :finish_time]
        .each do |time|
        it { is_expected.to allow_values(*VALID_TIMES).for(time) }

        it do
          is_expected.not_to allow_values(*INVALID_TIMES)
            .for(time)
            .with_message('must be a valid 24-hour time')
        end
      end
    end

    context 'when given a new score' do
      it { is_expected.to allow_value('', nil).for(:score) }

      it do
        should validate_numericality_of(:score)
          .only_integer
          .with_message('must be an integer')
      end
    end
  end

  describe '#calculate_score' do
    let(:five_hour_challenge) { create(:challenge_with_goals_and_team) }
    let(:team) { five_hour_challenge.teams.first }
    let(:compulsory) do
      five_hour_challenge.goals.where(compulsory: true)
                         .map { |g| g.checkpoint.number }
                         .to_s.tr('[]', '') + ', '
    end
    let(:goals) do
      five_hour_challenge.goals.where(compulsory: false)
                         .map { |g| g.checkpoint.number }
                         .sample(3).to_s.tr('[]', '')
    end

    context 'when visited empty' do
      it 'should not calculate score' do
        team = create(:team, visited: nil)
        team.valid?
        expect(team.score).to eq(nil)
      end
    end

    context 'when visited not empty' do
      it 'should calculate score' do
        team.update(
          visited: compulsory + goals,
          actual_start_time: '18:00',
          phone_in_time: '20:30',
          finish_time: '23:00'
        )
        team.valid?
        expect(team.disqualified).to eq(false)
        expect(team.score).to eq(140)
      end
    end

    context 'when team does not visit compulsory' do
      it 'should disqualify team' do
        team.update(
          visited: goals,
          actual_start_time: '18:00',
          phone_in_time: '20:30',
          finish_time: '23:00'
        )
        team.valid?
        expect(team.disqualified).to eq(true)
        expect(team.score).to eq(90)
      end
    end

    BONUSES = [
      :bonus_one, :bonus_two, :bonus_three, :bonus_four, :bonus_five
    ].freeze

    context 'when team gets bonus based on specific checkpoints' do
      BONUSES.each do |bonus|
        it "should add #{bonus} points to their score" do
          specific_checkpoint_bonus = "{ visit: [#{goals}], value: 50}"
          five_hour_challenge.update_attribute(bonus, specific_checkpoint_bonus)
          five_hour_challenge.valid?
          team.update(
            visited: compulsory + goals,
            actual_start_time: '18:00',
            phone_in_time: '20:30',
            finish_time: '23:00'
          )
          team.valid?
          expect(team.disqualified).to eq(false)
          expect(team.score).to eq(190)
        end
      end
    end

    context 'when team gets bonus based on total visited' do
      BONUSES.each do |bonus|
        it "should add #{bonus} points to their score" do
          total_visited_bonus = '{ visit: 2, value: 50}'
          five_hour_challenge.update_attribute(bonus, total_visited_bonus)
          five_hour_challenge.valid?
          team.update(
            visited: compulsory + goals,
            actual_start_time: '18:00',
            phone_in_time: '20:30',
            finish_time: '23:00'
          )
          team.valid?
          expect(team.disqualified).to eq(false)
          expect(team.score).to eq(190)
        end
      end
    end

    context 'when team does not phone in' do
      it 'should disqualify team' do
        team.update(
          visited: compulsory + goals,
          actual_start_time: '18:00',
          finish_time: '23:00',
          forgot_to_phone_in: true
        )
        team.valid?
        expect(team.disqualified).to eq(true)
        expect(team.score).to eq(110)
      end
    end

    context 'when team phones in late' do
      it 'should remove some of 30 point bonus (after planned phone in)' do
        team.update(
          visited: compulsory + goals,
          actual_start_time: '18:00',
          phone_in_time: '20:45',
          finish_time: '23:00'
        )
        team.valid?
        expect(team.disqualified).to eq(false)
        expect(team.score).to eq(125)
      end
    end

    context 'when team phones in late' do
      it 'should remove some of 30 point bonus (before planned phone in)' do
        team.update(
          visited: compulsory + goals,
          actual_start_time: '18:00',
          phone_in_time: '20:15',
          finish_time: '23:00'
        )
        team.valid?
        expect(team.disqualified).to eq(false)
        expect(team.score).to eq(125)
      end
    end

    context 'when team phones in on time' do
      it 'should give full 30 point bonus' do
        team.update(
          visited: compulsory + goals,
          actual_start_time: '18:00',
          phone_in_time: '20:30',
          finish_time: '23:00'
        )
        team.valid?
        expect(team.disqualified).to eq(false)
        expect(team.score).to eq(140)
      end
    end

    context 'when team returns late' do
      it 'should disqualify team' do
        team.update(
          visited: compulsory + goals,
          actual_start_time: '18:00',
          phone_in_time: '20:30',
          finish_time: '23:45'
        )
        team.valid?
        expect(team.disqualified).to eq(true)
        expect(team.score).to eq(110)
      end
    end

    context 'when team returns within 30 minute limit' do
      it 'should remove some of 30 point bonus' do
        team.update(
          visited: compulsory + goals,
          actual_start_time: '18:00',
          phone_in_time: '20:30',
          finish_time: '23:15'
        )
        team.valid?
        expect(team.disqualified).to eq(false)
        expect(team.score).to eq(125)
      end
    end

    context 'when team returns on time' do
      it 'should give full 30 point bonus' do
        team.update(
          visited: compulsory + goals,
          actual_start_time: '18:00',
          phone_in_time: '20:30',
          finish_time: '23:00'
        )
        team.valid?
        expect(team.disqualified).to eq(false)
        expect(team.score).to eq(140)
      end
    end

    context 'when team returns early' do
      it 'should give full 30 point bonus' do
        team.update(
          visited: compulsory + goals,
          actual_start_time: '18:00',
          phone_in_time: '20:30',
          finish_time: '22:30'
        )
        team.valid?
        expect(team.disqualified).to eq(false)
        expect(team.score).to eq(140)
      end
    end

    context 'when team drops out' do
      it 'should disqualify team' do
        team.update(
          visited: compulsory + goals,
          actual_start_time: '18:00',
          phone_in_time: '20:30',
          dropped_out: true
        )
        team.valid?
        expect(team.disqualified).to eq(true)
        expect(team.score).to eq(110)
      end
    end

    it 'should handle times >= 12 hours (lateness_in_minutes)'
  end
end
