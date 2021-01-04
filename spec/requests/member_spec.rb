require 'rails_helper'

RSpec.describe 'Member', type: :request do
  let(:user) { create(:user) }
  let(:team) { create(:team) }
  let(:member) { create(:member, team: team) }

  describe 'non-logged in user' do
    after(:each) do
      follow_redirect!
      expect(flash[:danger]).to be_present
      expect(response.body).to include('Please log in to manage members.')
    end

    describe 'get new' do
      before { get new_member_path }
      it { expect(response).to redirect_to login_path }
    end

    describe 'get edit' do
      before { get edit_member_path(member) }
      it { expect(response).to redirect_to login_path }
    end

    describe 'submitting to create action' do
      before { post members_path }
      it { expect(response).to redirect_to login_path }
    end

    describe 'submitting to update action' do
      before { patch member_path(member) }
      it { expect(response).to redirect_to login_path }
    end

    describe 'submitting to destroy action' do
      before { delete member_path(member) }
      it { expect(response).to redirect_to login_path }
    end
  end

  describe 'logged in user' do
    before { sign_in user }

    describe 'new' do
      it 'should assign new member' do
        get new_member_path, { team: team.id }
        expect(assigns(:member)).to be_a_new(Member)
      end
    end

    describe 'create' do
      context 'with invalid information' do
        it 'should not create a member' do
          post members_path, { member: { name: '', team_id: team.id } }
          expect(Member.count).to eq(0)
          expect(response).to render_template(:new)
        end
      end

      context 'with valid information' do
        it 'should create a member' do
          post members_path, { member: { name: 'John Doe', team_id: team.id } }
          expect(Member.count).to eq(1)
          expect(response).to redirect_to edit_team_path(team)
          follow_redirect!
          expect(flash[:success]).to be_present
          expect(response.body).to include('Member added.')
          expect(response.body).to include('John Doe')
        end
      end
    end

    describe 'update' do
      context 'with invalid information' do
        it 'should not update member' do
          patch member_path(member.id), { member: { name: '' } }
          expect(Member.count).to eq(1)
          expect(response).to render_template(:edit)
        end
      end

      context 'with valid information' do
        it 'should update member' do
          patch member_path(member.id), { member: { name: 'New Name' } }
          expect(Member.count).to eq(1)
          expect(response).to redirect_to edit_team_path(team)
          follow_redirect!
          expect(flash[:success]).to be_present
          expect(response.body).to include('Member updated.')
          expect(response.body).to include('New Name')
        end
      end
    end

    describe 'destroy' do
      it 'should destroy member' do
        delete member_path(member.id)
        expect(Member.count).to eq(0)
        expect(response).to redirect_to edit_team_path(team)
        follow_redirect!
        expect(flash[:success]).to be_present
        expect(response.body).to include('Member removed.')
      end
    end
  end
end
