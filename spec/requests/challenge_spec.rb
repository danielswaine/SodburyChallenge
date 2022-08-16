require 'rails_helper'

RSpec.describe Challenge, type: :request do
  let(:user) { create(:user) }
  let(:challenge) { create(:challenge) }

  describe 'non-logged in user' do
    after(:each) do
      follow_redirect!
      expect(flash[:danger]).to be_present
      expect(response.body).to include('Please log in to manage challenges.')
    end

    describe 'get index' do
      before { get challenges_path }
      it { expect(response).to redirect_to login_path }
    end

    describe 'get show' do
      after(:each) { expect(response).to redirect_to login_path }

      context 'html' do
        it 'should redirect to "/login"' do
          get challenge_path(challenge), format: :html
        end
      end

      context 'pdf' do
        it 'should redirect to "/login"' do
          get challenge_path(challenge), format: :pdf
        end
      end
    end

    describe 'get clipper' do
      before { get clipper_path(challenge) }
      it { expect(response).to redirect_to login_path }
    end

    describe 'get master list' do
      before { get master_list_path(challenge) }
      it { expect(response).to redirect_to login_path }
    end

    describe 'get team certificates' do
      before { get team_certificates_path(challenge) }
      it { expect(response).to redirect_to login_path }
    end

    describe 'get statistics' do
      before { get statistics_path(challenge) }
      it { expect(response).to redirect_to login_path }
    end

    describe 'get map update' do
      before { get '/challenges/1/map/update' }
      it { expect(response).to redirect_to login_path }
    end

    describe 'get map' do
      before { get map_path(challenge) }
      it { expect(response).to redirect_to login_path }
    end

    describe 'patch publish' do
      before { patch publish_path(challenge) }
      it { expect(response).to redirect_to login_path }
    end

    describe 'get new' do
      before { get new_challenge_path }
      it { expect(response).to redirect_to login_path }
    end

    describe 'submitting to create action' do
      before { post challenges_path }
      it { expect(response).to redirect_to login_path }
    end

    describe 'submitting to update action' do
      before { patch challenge_path(challenge) }
      it { expect(response).to redirect_to login_path }
    end

    describe 'submitting to destroy action' do
      before { delete challenge_path(challenge) }
      it { expect(response).to redirect_to login_path }
    end
  end

  describe 'logged in' do
    before { sign_in user }

    describe 'index' do
      it 'should order by date then time allowed' do
        ch  = create(:challenge, date: Date.yesterday)
        ch2 = create(:challenge, :eight_hour, date: Date.yesterday)
        ch3 = create(:challenge, date: Date.today)
        ch4 = create(:challenge, :eight_hour, date: Date.today)

        get challenges_path
        expect(assigns(:challenges).to_a).to eq [ch3, ch4, ch, ch2]
      end
    end

    describe 'show' do
      before { sign_in user }

      it 'assigns @goals' do
        g1 = create(:goal, challenge: challenge)
        g2 = create(:goal, challenge: challenge)
        get challenge_path(challenge)
        expect(assigns(:goals).to_a).to eq [g1, g2]
      end

      context 'html' do
        it 'should render page' do
          get challenge_path(challenge)
          expect(response.body).to include(
            "#{challenge.time_allowed} Hour Challenge #{challenge.date.year}"
          )
        end
      end

      context 'pdf' do
        context 'when no checkpoints to display' do
          it 'should download pdf' do
            get challenge_path(challenge), format: :pdf
            expect(response.content_type).to eq('application/pdf')
          end
        end

        context 'when checkpoints to display' do
          it 'should download pdf' do
            create(:goal, challenge: challenge)
            get checkpoints_path, format: :pdf
            expect(response.content_type).to eq('application/pdf')
          end
        end
      end
    end

    describe 'clipper' do
      it 'assigns @challenge' do
        get clipper_path(challenge), format: :pdf
        expect(assigns(:challenge)).to eq(challenge)
      end

      it 'should download pdf' do
        get clipper_path(challenge), format: :pdf
        expect(response.content_type).to eq('application/pdf')
      end
    end

    describe 'master_list' do
      it 'assigns @goals' do
        date = Date.today
        ch = create(:challenge, date: date - 1.day)
        create(:goal, challenge: ch)
        ch1 = create(:challenge, date: date)
        ch1_g1 = create(:goal, challenge: ch1)
        ch2 = create(:challenge, date: date)
        ch2_g1 = create(:goal, challenge: ch2)
        ch2_g2 = create(:goal, challenge: ch2, checkpoint_id: ch1_g1.checkpoint_id)

        get master_list_path(ch1, date: date), format: :pdf
        expect(assigns(:goals)).to eq(
          [
            [ch1_g1.checkpoint_id, [ch1_g1, ch2_g2]],
            [ch2_g1.checkpoint_id, [ch2_g1]]
          ]
        )
      end

      context 'when no checkpoints to display' do
        it 'should download pdf' do
          get master_list_path(challenge, date: challenge.date), format: :pdf
          expect(response.content_type).to eq('application/pdf')
        end
      end

      context 'when checkpoints to display' do
        it 'should download pdf' do
          create(:goal, challenge: challenge)
          get master_list_path(challenge, date: challenge.date), format: :pdf
          expect(response.content_type).to eq('application/pdf')
        end
      end
    end

    describe 'team_certificates' do
      it 'assigns @challenges' do
        ch1 = create(:challenge, date: Date.today)
        ch2 = create(:challenge, date: Date.today)
        create(:challenge, date: Date.yesterday)
        get team_certificates_path(challenge, date: Date.today), format: :pdf
        expect(assigns(:challenges).to_a).to eq([ch1, ch2])
      end

      it 'should download pdf' do
        get team_certificates_path(challenge, date: challenge.date), format: :pdf
        expect(response.content_type).to eq('application/pdf')
      end
    end

    describe 'new' do
      it 'should assign new challenge' do
        get new_challenge_path
        expect(assigns(:challenge)).to be_a_new(Challenge)
      end
    end

    describe 'create' do
      context 'with invalid information' do
        it 'should not create a challenge' do
          post challenges_path, { challenge: { date: '' } }
          expect(Challenge.count).to eq(0)
          expect(response).to render_template(:new)
        end
      end

      context 'with valid information' do
        it 'should create a challenge' do
          post challenges_path, { challenge: {
            date: Date.today,
            time_allowed: 5
          } }
          expect(Challenge.count).to eq(1)
          expect(response).to redirect_to challenges_path
          follow_redirect!
          expect(flash[:success]).to be_present
          expect(response.body).to include('Challenge created successfully.')
          expect(response.body).to include('Manage Challenges')
        end
      end
    end

    describe 'destroy' do
      it 'should destroy challenge' do
        get challenge_path(challenge)
        delete challenge_path(challenge)
        expect(Challenge.count).to eq(0)
        expect(response).to redirect_to challenges_path
        follow_redirect!
        expect(flash[:success]).to be_present
        expect(response.body).to include('Challenge deleted.')
      end
    end

    describe 'update' do
      bonus = '{ visit: 22, value: 15 }'.freeze

      context 'with invalid bonus' do
        it 'assigns @challenge' do
          patch challenge_path(challenge), { challenge: { bonus_one: 'invalid' } }
          expect(assigns(:challenge)).to eq(challenge)
        end

        it 'should not update challenge' do
          patch challenge_path(challenge), { challenge: { bonus_one: 'invalid' } }
          expect(response).to render_template(:show)
          expect(flash[:danger]).to be_present
          expect(response.body).to include('Bonus is incorrectly formatted.')
          expect(challenge.bonus_one).not_to eq('invalid')
        end
      end

      context 'with valid bonus' do
        it 'assigns @challenge' do
          patch challenge_path(challenge), {
            challenge: { bonus_one: bonus }
          }
          expect(assigns(:challenge)).to eq(challenge)
        end

        it 'should update challenge' do
          patch challenge_path(challenge), {
            challenge: { bonus_one: bonus }
          }
          expect(Challenge.count).to eq(1)
          expect(response).to redirect_to challenges_path
          follow_redirect!
          expect(flash[:success]).to be_present
          expect(response.body).to include('Challenge updated.')
          expect(response.body).to include('Manage Challenges')
        end
      end
    end

    describe 'publish' do
      context 'when scoring incomplete' do
        it 'should not publish' do
          create(:team, challenge: challenge, score: 10)
          create(:team, challenge: challenge)
          patch publish_path(challenge), id: challenge.id
          expect(response).to redirect_to teams_path
          follow_redirect!
          expect(flash[:danger]).to be_present
          expect(response.body).to include(
            'Please score all teams in the challenge before publishing results.'
          )
        end
      end

      context 'when scoring complete' do
        context 'with valid challenge' do
          it 'should publish results' do
            create_list(:team, 2, challenge: challenge, score: 10)
            patch publish_path(challenge)
            expect(response).to redirect_to results_path
            follow_redirect!
            expect(flash[:success]).to be_present
            expect(response.body).to include('Results published successfully.')
          end
        end

        context 'with invalid challenge' do
          it 'should not publish results' # think of a way to make the else fail
        end
      end
    end

    describe 'statistics' do
      it 'assigns @challenge' do
        get statistics_path(challenge)
        expect(assigns(:challenge)).to eq(challenge)
      end

      it 'TODO: refactor logic from view into model/controller'
    end

    describe 'map_update' do
      it 'should render json' do
        get "/challenges/#{challenge.id}/map/update"
        expect(response.content_type).to eq('application/json')
      end

      it 'should show data from challenges on the same date'
      it 'should assign goals'
      it 'should assign team locations'
      it 'TODO: refactor logic from controller into model'
    end

    describe 'map' do
      it 'TODO: think of tests here'
    end
  end
end
