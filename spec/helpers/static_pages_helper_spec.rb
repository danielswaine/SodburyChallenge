require 'rails_helper'
include TeamsHelper

RSpec.describe StaticPagesHelper, type: :helper do
  describe 'group_list' do
    let(:challenge) { create(:challenge) }

    context 'when no teams' do
      it 'should return an empty string' do
        expect(group_list(challenge.teams)).to eq('')
      end
    end

    context 'when two teams' do
      it 'should return two groups separated by an ampersand' do
        create(:team, group: :explorers, challenge: challenge)
        create(:team, group: :scouts, challenge: challenge)

        expect(group_list(challenge.teams)).to eq('Explorers & Scouts')
      end
    end

    context 'when more than two teams' do
      it 'should return a comma list with final separator being an ampersand' do
        create(:team, group: :explorers, challenge: challenge)
        create(:team, group: :scouts, challenge: challenge)
        create(:team, group: :leaders, challenge: challenge)

        expect(group_list(challenge.teams)).to eq('Explorers, Scouts & Leaders')
      end
    end
  end

  describe 'results_table' do
    context 'when teams finished early with no equal scores' do
      it 'should return ordered array of scores' do
        t1 = create(:team, actual_start_time: '18:00', finish_time: '22:59', score: 1)
        t2 = create(:team, actual_start_time: '18:05', finish_time: '23:03', score: 2)
        t3 = create(:team, actual_start_time: '18:10', finish_time: '23:07', score: 3)
        teams = Team.all

        expect(results_table(teams)).to eq(
          [
            { position: '1st', name: t3.name, score: 3, minutes_late: nil },
            { position: '2nd', name: t2.name, score: 2, minutes_late: nil },
            { position: '3rd', name: t1.name, score: 1, minutes_late: nil }
          ]
        )
      end
    end

    context 'when teams finished early with same score and time' do
      it 'should return ordered array of scores with joint position' do
        t1 = create(:team, actual_start_time: '18:00', finish_time: '22:59', score: 3)
        t2 = create(:team, actual_start_time: '18:05', finish_time: '23:04', score: 3)
        t3 = create(:team, actual_start_time: '18:10', finish_time: '23:09', score: 1)
        teams = Team.all

        expect(results_table(teams)).to eq(
          [
            { position: '1st=', name: t2.name, score: 3, minutes_late: -1 },
            { position: '1st=', name: t1.name, score: 3, minutes_late: -1 },
            { position: '2nd',  name: t3.name, score: 1, minutes_late: nil }
          ]
        )
      end
    end

    context 'when teams finished with same score but different times' do
      it 'should return ordered array of scores with joint position' do
        t1 = create(:team, actual_start_time: '18:00', finish_time: '23:05', score: 3)
        t2 = create(:team, actual_start_time: '18:05', finish_time: '23:11', score: 3)
        t3 = create(:team, actual_start_time: '18:10', finish_time: '23:17', score: 1)
        teams = Team.all

        expect(results_table(teams)).to eq(
          [
            { position: '1st', name: t1.name, score: 3, minutes_late: 5   },
            { position: '2nd', name: t2.name, score: 3, minutes_late: 6   },
            { position: '3rd', name: t3.name, score: 1, minutes_late: nil }
          ]
        )
      end
    end

    context 'when teams finished on time with same score and time' do
      it 'should return ordered array of scores with joint position' do
        t1 = create(:team, actual_start_time: '18:00', finish_time: '23:00', score: 3)
        t2 = create(:team, actual_start_time: '18:05', finish_time: '23:05', score: 1)
        t3 = create(:team, actual_start_time: '18:10', finish_time: '23:10', score: 1)
        teams = Team.all

        expect(results_table(teams)).to eq(
          [
            { position: '1st',  name: t1.name, score: 3, minutes_late: nil },
            { position: '2nd=', name: t3.name, score: 1, minutes_late: 0   },
            { position: '2nd=', name: t2.name, score: 1, minutes_late: 0   }
          ]
        )
      end
    end

    context 'when teams finished late (within 30 min allowance)' do
      it 'should return ordered array of scores with joint position' do
        t1 = create(:team, actual_start_time: '18:00', finish_time: '23:05', score: 3)
        t2 = create(:team, actual_start_time: '18:05', finish_time: '23:10', score: 1)
        t3 = create(:team, actual_start_time: '18:10', finish_time: '23:15', score: 1)
        teams = Team.all

        expect(results_table(teams)).to eq(
          [
            { position: '1st',  name: t1.name, score: 3, minutes_late: nil },
            { position: '2nd=', name: t3.name, score: 1, minutes_late: 5   },
            { position: '2nd=', name: t2.name, score: 1, minutes_late: 5   }
          ]
        )
      end
    end
  end

  describe 'format_minutes_lates' do
    context 'when minutes nil' do
      it { expect(format_minutes_late(nil)).to eq('') }
    end

    context 'when a teams finishes early' do
      it { expect(format_minutes_late(-5)).to eq('(finished 5 minutes early)') }
    end

    context 'when a teams finishes on time' do
      it { expect(format_minutes_late(0)).to eq('(finished exactly on time)') }
    end

    context 'when a teams finishes late' do
      it { expect(format_minutes_late(5)).to eq('(finished 5 minutes late)') }
    end
  end
end
