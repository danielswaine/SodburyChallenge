require 'rails_helper'

RSpec.describe Goal, type: :request do
  let(:user) { create(:user) }
  let(:goal) { create(:goal) }
  let(:spare_checkpoint) { create(:checkpoint) }

  describe 'non-logged in user' do
    after(:each) do
      follow_redirect!
      expect(flash[:danger]).to be_present
      expect(response.body).to include('Please log in to manage goals.')
    end

    describe 'get new' do
      before { get new_goal_path }
      it { expect(response).to redirect_to login_path }
    end

    describe 'get edit' do
      before { get edit_goal_path(goal) }
      it { expect(response).to redirect_to login_path }
    end

    describe 'submitting to create action' do
      before { post goals_path }
      it { expect(response).to redirect_to login_path }
    end

    describe 'submitting to update action' do
      before { patch goal_path(goal) }
      it { expect(response).to redirect_to login_path }
    end

    describe 'submitting to destroy action' do
      before { delete goal_path(goal) }
      it { expect(response).to redirect_to login_path }
    end
  end

  describe 'logged in user' do
    before { sign_in user }

    describe 'new' do
      it 'should assign new goal' do
        get new_goal_path, { challenge: goal.challenge.id }
        expect(assigns(:goal)).to be_a_new(Goal)
      end
    end

    describe 'create' do
      context 'with invalid information' do
        it 'should not create a goal' do
          post goals_path, { goal: { points_value: '' } }
          expect(Goal.count).to eq(0)
          expect(response).to render_template(:new)
        end
      end

      context 'with valid information' do
        it 'should create a goal' do
          post goals_path, { goal: {
            challenge_id: goal.challenge.id,
            checkpoint_id: spare_checkpoint.id,
            points_value: 55,
            start_point: false,
            compulsory: false
          } }
          expect(Goal.count).to eq(2)
          expect(response).to redirect_to challenge_path(goal.challenge)
          follow_redirect!
          expect(flash[:success]).to be_present
          expect(response.body).to include('Goal added.')
          expect(response.body).to include('55')
        end
      end
    end

    describe 'update' do
      context 'with invalid information' do
        it 'should not update goal' do
          patch goal_path(goal), { goal: { points_value: '' } }
          expect(Goal.count).to eq(1)
          expect(response).to render_template(:edit)
        end
      end

      context 'with valid information' do
        it 'should update goal' do
          patch goal_path(goal), { goal: { compulsory: true } }
          expect(Goal.count).to eq(1)
          expect(response).to redirect_to challenge_path(goal.challenge)
          follow_redirect!
          expect(flash[:success]).to be_present
          expect(response.body).to include('Goal updated.')
          expect(response.body).to include('Yes')
        end
      end
    end

    describe 'destroy' do
      it 'should destroy goal' do
        delete goal_path(goal)
        expect(Goal.count).to eq(0)
        expect(response).to redirect_to challenge_path(goal.challenge)
        follow_redirect!
        expect(flash[:success]).to be_present
        expect(response.body).to include('Goal removed.')
      end
    end
  end
end
