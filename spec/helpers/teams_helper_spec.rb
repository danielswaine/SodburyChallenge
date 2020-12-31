require 'rails_helper'

RSpec.describe TeamsHelper, type: :helper do
  describe 'start_time' do
    it 'should return actual_start_time if not empty' do
      team = build_stubbed(
        :team,
        planned_start_time: '16:00',
        actual_start_time: '16:30'
      )
      expect(start_time(team)).to eq('16:30')
    end

    it 'should return planned_start_time if actual_start_time empty' do
      team = build_stubbed(
        :team,
        planned_start_time: '16:00',
        actual_start_time: nil
      )
      expect(start_time(team)).to eq('16:00')
    end
  end

  describe 'phone_in_time' do
    context '5 hour' do
      let(:challenge) { build_stubbed(:challenge) }

      it 'should return phone_in_time if not empty' do
        team = build_stubbed(
          :team,
          challenge: challenge,
          phone_in_time: '20:35'
        )
        expect(phone_in_time(team)).to eq('20:35')
      end

      it 'should return expected_phone_in_time if phone_in_time empty' do
        team = build_stubbed(:team, challenge: challenge)
        expect(phone_in_time(team)).to eq('20:30')
      end
    end

    context '8 hour' do
      let(:challenge) { build_stubbed(:challenge, :eight_hour) }

      it 'should return phone_in_time if not empty' do
        team = build_stubbed(
          :team,
          challenge: challenge,
          phone_in_time: '22:05'
        )
        expect(phone_in_time(team)).to eq('22:05')
      end

      it 'should return expected_phone_in_time if phone_in_time empty' do
        team = build_stubbed(:team, challenge: challenge)
        expect(phone_in_time(team)).to eq('22:00')
      end
    end
  end

  describe 'finish_time' do
    context '5 hour' do
      let(:challenge) { build_stubbed(:challenge) }

      it 'should return finish_time if not empty' do
        team = build_stubbed(
          :team,
          challenge: challenge,
          finish_time: '23:05'
        )
        expect(finish_time(team)).to eq('23:05')
      end

      it 'should return expected_finish_time if finish_time empty' do
        team = build_stubbed(:team, challenge: challenge)
        expect(finish_time(team)).to eq('23:00')
      end
    end

    context '8 hour' do
      let(:challenge) { build_stubbed(:challenge, :eight_hour) }

      it 'should return finish_time if not empty' do
        team = build_stubbed(
          :team,
          challenge: challenge,
          finish_time: '02:05'
        )
        expect(finish_time(team)).to eq('02:05')
      end

      it 'should return expected_finish_time if finish_time empty' do
        team = build_stubbed(:team, challenge: challenge)
        expect(finish_time(team)).to eq('02:00')
      end
    end
  end

  describe 'current_status' do
    context 'new team' do
      it 'should have no status' do
        team = build_stubbed(:team)
        expect(current_status(team)).to eq(nil)
      end
    end

    context 'team on course' do
      it 'should return on course' do
        team = build_stubbed(:team, actual_start_time: '18:00')
        expect(current_status(team)).to eq('On course')
      end
    end

    context 'team phoned in' do
      it 'should return phoned in' do
        team = build_stubbed(
          :team,
          actual_start_time: '18:00',
          phone_in_time: '20:30'
        )
        expect(current_status(team)).to eq('Phoned in')
      end
    end

    context 'team finished' do
      it 'should return phoned in' do
        team = build_stubbed(
          :team,
          actual_start_time: '18:00',
          phone_in_time: '20:30',
          finish_time: '23:00'
        )
        expect(current_status(team)).to eq('Finished')
      end
    end

    context 'team dropped out' do
      it 'should return dropped out' do
        team = build_stubbed(
          :team,
          actual_start_time: '18:00',
          phone_in_time: '20:30',
          finish_time: '23:00',
          dropped_out: true
        )
        expect(current_status(team)).to eq('Dropped out')
      end
    end
  end

  describe 'reason_for_disqualification' do
    let(:five_hour_challenge) { create(:challenge_with_goals_and_team) }
    let(:goals) do
      five_hour_challenge.goals
                         .map { |g| g.checkpoint.number }
                         .to_s.tr('[]', '')
    end
    let(:team) { five_hour_challenge.teams.first }

    context 'team disqualified' do
      it 'should return disqualified' do
        team.update(
          disqualified: true,
          visited: goals,
          actual_start_time: '18:00',
          phone_in_time: '20:30',
          finish_time: '23:00'
        )
        team.valid?
        expect(reason_for_disqualification(team)).to eq('Disqualified')
      end
    end

    context 'team did not phone in' do
      it 'should return did not phone in' do
        team.update(
          disqualified: true,
          visited: goals,
          actual_start_time: '18:00',
          # phone_in_time: '20:30',
          finish_time: '23:00',
          forgot_to_phone_in: true
        )
        team.valid?
        expect(reason_for_disqualification(team)).to eq('Didn\'t phone in')
      end
    end

    context 'team finished late' do
      it 'should return finished late' do
        team.update(
          disqualified: true,
          visited: goals,
          actual_start_time: '18:00',
          phone_in_time: '20:30',
          finish_time: '23:31'
        )
        team.valid?
        expect(reason_for_disqualification(team)).to eq('Finished late')
      end
    end

    context 'team omitted compulsory' do
      it 'should return omitted compulsory' do
        team.update(
          disqualified: true,
          actual_start_time: '18:00',
          phone_in_time: '20:30',
          finish_time: '23:00'
        )
        team.valid?
        expect(reason_for_disqualification(team)).to eq('Omitted compulsory')
      end
    end

    context 'team dropped out' do
      it 'should return dropped out' do
        team.update(
          disqualified: true,
          dropped_out: true
        )
        team.valid?
        expect(reason_for_disqualification(team)).to eq('Dropped out')
      end
    end
  end

  describe 'finished_late' do
    context 'when a team is early' do
      it 'should return false' do
        team = build_stubbed(
          :team,
          actual_start_time: '18:00',
          phone_in_time: '20:30',
          finish_time: '22:59'
        )
        team.valid?
        expect(finished_late?(team)).to eq(false)
      end
    end

    context 'when a team finishes on time' do
      it 'should return false' do
        team = build_stubbed(
          :team,
          actual_start_time: '18:00',
          phone_in_time: '20:30',
          finish_time: '23:01'
        )
        team.valid?
        expect(finished_late?(team)).to eq(false)
      end
    end

    context 'when a team finishes within 30 minutes' do
      it 'should return false' do
        team = build_stubbed(
          :team,
          actual_start_time: '18:00',
          phone_in_time: '20:30',
          finish_time: '23:15'
        )
        team.valid?
        expect(finished_late?(team)).to eq(false)
      end
    end

    context 'when a team finishes on 30 minutes' do
      it 'should return false' do
        team = build_stubbed(
          :team,
          actual_start_time: '18:00',
          phone_in_time: '20:30',
          finish_time: '23:30'
        )
        team.valid?
        expect(finished_late?(team)).to eq(true)
      end
    end

    context 'when a team finished more than 30 minutes late' do
      it 'should return true' do
        team = build_stubbed(
          :team,
          actual_start_time: '18:00',
          phone_in_time: '20:30',
          finish_time: '23:31'
        )
        team.valid?
        expect(finished_late?(team)).to eq(true)
      end
    end
  end

  describe 'visited_compulsory_checkpoints' do
    let(:challenge) { create(:challenge, :with_team) }
    let(:team) { challenge.teams.first }
    let(:goal) { create(:goal, challenge: challenge) }

    context 'with no compulsory checkpoints' do
      it 'should return true if visited' do
        team.update(visited: goal.checkpoint.number, finish_time: '23:00')
        expect(visited_compulsory_checkpoints?(team)).to eq(true)
      end

      it 'should return true if not visited' do
        team.update(finish_time: '23:00')
        expect(visited_compulsory_checkpoints?(team)).to eq(true)
      end
    end

    context 'with 1 compulsory checkpoints' do
      it 'should return true if visited' do
        goal = create(:goal, :compulsory, challenge: challenge)
        team.update(visited: goal.checkpoint.number, finish_time: '23:00')
        expect(visited_compulsory_checkpoints?(team)).to eq(true)
      end

      it 'should return false if not visited' do
        create(:goal, :compulsory, challenge: challenge)
        team.update(finish_time: '23:00')
        expect(visited_compulsory_checkpoints?(team)).to eq(false)
      end
    end

    context 'with 2 compulsory checkpoints' do
      it 'should return true if visited all' do
        g1 = create(:goal, :compulsory, challenge: challenge)
        g2 = create(:goal, :compulsory, challenge: challenge)
        goals = g1.checkpoint.number.to_s + ', ' + g2.checkpoint.number.to_s

        team.update(visited: goals, finish_time: '23:00')
        expect(visited_compulsory_checkpoints?(team)).to eq(true)
      end

      it 'should return false if not visited all' do
        goal1 = create(:goal, :compulsory, challenge: challenge)
        create(:goal, :compulsory, challenge: challenge)

        team.update(visited: goal1.checkpoint.number, finish_time: '23:00')
        expect(visited_compulsory_checkpoints?(team)).to eq(false)
      end

      it 'should return false if not visited' do
        create(:goal, :compulsory, challenge: challenge)
        create(:goal, :compulsory, challenge: challenge)

        team.update(finish_time: '23:00')
        expect(visited_compulsory_checkpoints?(team)).to eq(false)
      end
    end
  end

  describe 'expected_finish_time_with_padding' do
    let(:five_hour_challenge) { create(:challenge) }
    let(:eight_hour_challenge) { create(:challenge, :eight_hour) }
    let(:team_5hr) { create(:team, challenge: five_hour_challenge) }
    let(:team_8hr) { create(:team, challenge: eight_hour_challenge) }

    it 'should return 30 minutes after finish time' do
      expect(expected_finish_time_with_padding(team_5hr)).to eq('23:30')
      expect(expected_finish_time_with_padding(team_8hr)).to eq('02:30')
    end
  end

  describe 'is_current_year' do
    let(:challenge) { build_stubbed(:challenge, date: Date.today) }

    it 'returns \'in\' if current year' do
      expect(is_current_year(challenge)).to eq(' in')
      travel 1.year
      expect(is_current_year(challenge)).to eq(nil)
    end
  end

  describe 'lateness_in_minutes' do
    hour = 1
    minutes = 10
    result = 10

    12.times do
      time = format('%<hour>02d:%<minutes>01d', hour: hour, minutes: minutes)
      returned = (Time.parse('01:00') - Time.parse(time)) / 1.minute

      it 'should return number of minutes between 01:00 and ' + time do
        expect(lateness_in_minutes('01:00', time)).to eq(-returned)
      end

      it 'should return number of minutes between ' + time + ' 01:00' do
        expect(lateness_in_minutes(time, '01:00')).to eq(returned)
      end

      minutes += 5
      minutes = 10 unless minutes < 59
      hour += 1
      result += 65
    end
  end
end
