require 'rails_helper'

RSpec.describe Team, type: :request do
  let(:user) { create(:user) }
  let(:challenge) { create(:challenge) }
  let(:team) { create(:team) }

  describe 'non-logged in user' do
    after(:each) do
      follow_redirect!
      expect(flash[:danger]).to be_present
      expect(response.body).to include('Please log in to manage teams.')
    end

    describe 'get index' do
      before { get teams_path }
      it { expect(response).to redirect_to login_path }
    end

    describe 'get index' do
      before { get teams_path }
      it { expect(response).to redirect_to login_path }
    end

    describe 'get public_times' do
      before { get public_times_path }
      it { expect(response).to redirect_to login_path }
    end

    describe 'get new' do
      before { get new_team_path }
      it { expect(response).to redirect_to login_path }
    end

    describe 'get edit' do
      before { get edit_team_path(team) }
      it { expect(response).to redirect_to login_path }
    end

    describe 'get log' do
      before { get log_team_path(team) }
      it { expect(response).to redirect_to login_path }
    end

    describe 'get update_times' do
      before { patch log_team_path(team) }
      it { expect(response).to redirect_to login_path }
    end

    describe 'get score' do
      before { get score_team_path(team) }
      it { expect(response).to redirect_to login_path }
    end

    describe 'get update_score' do
      before { patch score_team_path(team) }
      it { expect(response).to redirect_to login_path }
    end

    describe 'submitting to create action' do
      before { post teams_path }
      it { expect(response).to redirect_to login_path }
    end

    describe 'submitting to update action' do
      before { patch team_path(team) }
      it { expect(response).to redirect_to login_path }
    end

    describe 'submitting to destroy action' do
      before { delete team_path(team) }
      it { expect(response).to redirect_to login_path }
    end
  end

  describe 'logged in' do
    before { sign_in user }

    describe 'index' do
      context 'html format' do
        it 'should assign @challenges' do
          challenge = create(:challenge)
          second_challenge = create(:challenge)
          get teams_path, format: :html
          expect(assigns(:challenges).to_a).to eq([challenge, second_challenge])
        end
      end

      context 'pdf format' do
        it 'should assign @challenges' do
          challenge = create(:challenge)
          second_challenge = create(:challenge)
          get teams_path, format: :pdf
          expect(assigns(:challenges).to_a).to eq([challenge, second_challenge])
          expect(response.content_type).to eq('application/pdf')
        end
      end
    end

    describe 'public_times' do
      it 'should assign @challenges' do
        challenge = create(:challenge)
        second_challenge = create(:challenge)
        get public_times_path, format: :pdf
        expect(assigns(:challenges).to_a).to eq([challenge, second_challenge])
        expect(response.content_type).to eq('application/pdf')
      end
    end

    describe 'log' do
      it do
        get log_team_path(team)
        expect(response.body).to include('Log Actual Times')
      end
    end

    describe 'update_times' do
      context 'with invalid information' do
        it 'should not update times' do
          patch log_team_path(team), { team: { actual_start_time: '12:' } }
          expect(response).to render_template(:log)
          expect(team.actual_start_time).to eq(nil)
        end
      end

      context 'with valid information' do
        it 'should update times' do
          patch log_team_path(team), { team: { actual_start_time: '18:05' } }
          expect(response).to redirect_to root_path
          follow_redirect!
          expect(flash[:success]).to be_present
          expect(response.body).to include('Team times saved.')
        end
      end
    end

    describe 'score' do
      context 'when all information completed' do
        it 'should allow team to be scored' do
          team.update(
            actual_start_time: '18:00',
            phone_in_time: '20:00',
            finish_time: '23:00'
          )
          get score_team_path(team)
          expect(response.body).to include('Score Team')
        end
      end

      context 'when actual start time has not been entered' do
        it 'should not allow team to be scored' do
          get score_team_path(team)
          expect(response).to redirect_to log_team_path(team)
          follow_redirect!
          expect(flash[:danger]).to be_present
          expect(response.body).to include(
            'Please submit team start time before scoring.'
          )
        end
      end

      context 'when phone in time has not been entered' do
        it 'should not allow team to be scored' do
          team.update(actual_start_time: '18:00')
          get score_team_path(team)
          expect(response).to redirect_to log_team_path(team)
          follow_redirect!
          expect(flash[:danger]).to be_present
          expect(response.body).to include(
            'Please submit phone in time (or mark as forgotten) before scoring.'
          )
        end
      end

      context 'when team forgot to phone in' do
        it 'should allow team to be scored' do
          team.update(
            actual_start_time: '18:00',
            forgot_to_phone_in: true,
            finish_time: '23:00'
          )
          get score_team_path(team)
          expect(response.body).to include('Score Team')
        end
      end

      context 'when finish time has not been entered' do
        it 'should not allow team to be scored' do
          team.update(actual_start_time: '18:00', phone_in_time: '20:30')
          get score_team_path(team)
          expect(response).to redirect_to log_team_path(team)
          follow_redirect!
          expect(flash[:danger]).to be_present
          expect(response.body).to include(
            'Please submit finish time (or mark as dropped out) before scoring.'
          )
        end
      end

      context 'when team dropped out' do
        it 'should allow team to be scored' do
          team.update(
            actual_start_time: '18:00',
            phone_in_time: '20:30',
            dropped_out: true
          )
          get score_team_path(team)
          expect(response.body).to include('Score Team')
        end
      end
    end

    describe 'update_score' do
      context 'with valid information' do
        it 'should allow team to be scored' do
          team.update(
            actual_start_time: '18:00',
            phone_in_time: '20:00',
            finish_time: '23:00'
          )
          patch score_team_path(team), { team: { visited: '1, 2, 3' } }
          expect(response).to redirect_to teams_path
          follow_redirect!
          expect(flash[:success]).to be_present
          expect(response.body).to include('Team score saved.')
        end
      end

      context 'with invalid information' do
        it 'should not allow team to be scored' do
          team.update(
            actual_start_time: '18:00',
            phone_in_time: '20:00',
            finish_time: '23:00'
          )
          patch score_team_path(team), { team: { visited: '£$%' } }
          expect(response).to render_template(:score)
        end
      end

      context 'when actual start time has not been entered' do
        it 'should not allow team to be scored' do
          patch score_team_path(team), { team: { visited: '1, 2, 3' } }
          expect(response).to redirect_to log_team_path(team)
          follow_redirect!
          expect(flash[:danger]).to be_present
          expect(response.body).to include(
            'Please submit team start time before scoring.'
          )
        end
      end

      context 'when phone in time has not been entered' do
        it 'should not allow team to be scored' do
          team.update(actual_start_time: '18:00')
          patch score_team_path(team), { team: { visited: '1, 2, 3' } }
          expect(response).to redirect_to log_team_path(team)
          follow_redirect!
          expect(flash[:danger]).to be_present
          expect(response.body).to include(
            'Please submit phone in time (or mark as forgotten) before scoring.'
          )
        end
      end

      context 'when team forgot to phone in' do
        it 'should allow team to be scored' do
          team.update(
            actual_start_time: '18:00',
            forgot_to_phone_in: true,
            finish_time: '23:00'
          )
          patch score_team_path(team), { team: { visted: '1, 2, 3' } }
          expect(response).to redirect_to teams_path
          follow_redirect!
          expect(flash[:success]).to be_present
          expect(response.body).to include('Team score saved.')
        end
      end

      context 'when finish time has not been entered' do
        it 'should not allow team to be scored' do
          team.update(actual_start_time: '18:00', phone_in_time: '20:30')
          patch score_team_path(team), { team: { visited: '1, 2, 3' } }
          expect(response).to redirect_to log_team_path(team)
          follow_redirect!
          expect(flash[:danger]).to be_present
          expect(response.body).to include(
            'Please submit finish time (or mark as dropped out) before scoring.'
          )
        end
      end

      context 'when team dropped out' do
        it 'should allow team to be scored' do
          team.update(
            actual_start_time: '18:00',
            phone_in_time: '20:30',
            dropped_out: true,
          )
          patch score_team_path(team), { team: { visited: '1, 2, 3' } }
          expect(response).to redirect_to teams_path
          follow_redirect!
          expect(flash[:success]).to be_present
          expect(response.body).to include('Team score saved.')
        end
      end
    end

    describe 'new' do
      it 'should assign new team' do
        get new_team_path
        expect(assigns(:team)).to be_a_new(Team)
      end
    end

    describe 'create' do
      context 'with invalid information' do
        it 'should not create a team' do
          post teams_path, { team: { planned_start_time: '' } }
          expect(Team.count).to eq(0)
          expect(response).to render_template(:new)
        end
      end

      context 'with valid information' do
        it 'should create a team' do
          post teams_path, { team: {
            challenge_id: challenge.id,
            name: 'Test Team Name',
            group: :scouts,
            planned_start_time: '19:00'
          } }
          expect(Team.count).to eq(1)
          expect(response).to redirect_to teams_path
          follow_redirect!
          expect(flash[:success]).to be_present
          expect(response.body).to include('Team created successfully.')
          expect(response.body).to include('Test Team Name')
        end
      end
    end

    describe 'edit' do
      it do
        get edit_team_path(team)
        expect(response.body).to include('Edit Team')
      end
    end

    describe 'update' do
      context 'with invalid information' do
        it 'should not update team' do
          old_name = team.name
          patch team_path(team), { team: { name: '' } }
          expect(response).to render_template(:edit)
          expect(team.name).to eq(old_name)
        end
      end

      context 'with valid information' do
        it 'should update team' do
          patch team_path(team), { team: { name: 'New Team Name' } }
          expect(Team.count).to eq(1)
          expect(response).to redirect_to teams_path
          follow_redirect!
          expect(flash[:success]).to be_present
          expect(response.body).to include('Team updated successfully.')
          expect(response.body).to include('New Team Name')
        end
      end
    end

    describe 'destroy' do
      it 'should destroy team' do
        delete team_path(team)
        expect(Team.count).to eq(0)
        expect(response).to redirect_to teams_path
        follow_redirect!
        expect(flash[:success]).to be_present
        expect(response.body).to include('Team deleted successfully.')
      end
    end
  end
end
