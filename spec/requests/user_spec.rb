require 'rails_helper'

RSpec.describe User, type: :request do
  let(:admin) { create(:user, :admin) }
  let(:non_admin) { create(:user) }

  describe 'non-logged in user' do
    after(:each) do
      follow_redirect!
      expect(flash[:danger]).to be_present
      expect(response.body).to include('Please log in to manage users.')
    end

    describe 'get index' do
      before { get users_path }
      it { expect(response).to redirect_to login_path }
    end

    describe 'get new' do
      before { get new_user_path }
      it { expect(response).to redirect_to login_path }
    end

    describe 'get edit' do
      before { get edit_user_path(non_admin) }
      it { expect(response).to redirect_to login_path }
    end

    describe 'submitting to create action' do
      before { post users_path }
      it { expect(response).to redirect_to login_path }
    end

    describe 'submitting to update action' do
      before { patch user_path(non_admin) }
      it { expect(response).to redirect_to login_path }
    end

    describe 'submitting to destroy action' do
      before { delete user_path(non_admin) }
      it { expect(response).to redirect_to login_path }
    end
  end

  describe 'logged in' do
    before { sign_in admin }

    describe 'index' do
      it 'should assign @users' do
        get edit_user_path(non_admin) # Force use of non_admin in this test
        get users_path
        expect(assigns(:users).to_a).to eq([admin, non_admin])
      end
    end

    describe 'new' do
      it 'should assign new user' do
        get new_user_path
        expect(assigns(:user)).to be_a_new(User)
      end
    end

    describe 'create' do
      context 'with invalid information' do
        it 'should not create a user' do
          post users_path, { user: { email: '' } }
          expect(User.count).to eq(1)
          expect(response).to render_template(:new)
        end
      end

      context 'with valid information' do
        it 'should create a user' do
          post users_path, { user: {
            name: 'John Doe',
            email: 'john@doe.com',
            password: '!@£qsi7vjsdkjf2h@!£!%!12',
            password_confirmation: '!@£qsi7vjsdkjf2h@!£!%!12'
          } }
          expect(User.count).to eq(2)
          expect(response).to redirect_to users_path
          follow_redirect!
          expect(flash[:success]).to be_present
          expect(response.body).to include(
            'John Doe has been added to the Sodbury Challenge app!'
          )
          expect(response.body).to include('John Doe')
        end
      end
    end

    describe 'edit' do
      context 'editing own account' do
        it 'should be allowed' do
          get edit_user_path(admin)
          expect(response.body).to include('Manage Your Account')
        end
      end

      context 'editing another account' do
        it 'should not be allowed' do
          get edit_user_path(non_admin)
          follow_redirect!
          expect(flash[:danger]).to be_present
          expect(response.body).to include(
            'You can only edit your own account.'
          )
        end
      end
    end

    describe 'update' do
      context 'with invalid information' do
        it 'should not update user' do
          old_email = admin.email
          patch user_path(admin), { user: { email: '' } }
          expect(response).to render_template(:edit)
          expect(admin.email).to eq(old_email)
        end
      end

      context 'with valid information' do
        it 'should update user' do
          patch user_path(admin), { user: { name: 'John Jones' } }
          expect(User.count).to eq(1)
          expect(response).to redirect_to users_path
          follow_redirect!
          expect(flash[:success]).to be_present
          expect(response.body).to include('Account details updated.')
          expect(response.body).to include('John Jones')
        end
      end

      context 'when updating another user\'s account' do
        it 'should not be allowed' do
          original_name = non_admin.name
          patch user_path(non_admin), { user: { name: 'Test' } }
          expect(response).to redirect_to users_url
          follow_redirect!
          expect(flash[:danger]).to be_present
          expect(response.body).to include(
            'You can only edit your own account.'
          )
          expect(response.body).to include(original_name)
        end
      end
    end

    describe 'destroy' do
      context 'when deleting a non-admin' do
        it 'should destroy user' do
          old_name = non_admin.name
          delete user_path(non_admin)
          expect(User.count).to eq(1)
          expect(response).to redirect_to users_path
          follow_redirect!
          expect(flash[:success]).to be_present
          expect(response.body).to include("#{old_name} has been removed.")
        end
      end

      context 'when deleting an admin' do
        it 'should not be allowed' do
          second_admin = create(:user, :admin)
          delete user_path(second_admin)
          expect(User.count).to eq(2)
          expect(response).to redirect_to users_url
          follow_redirect!
          expect(flash[:danger]).to be_present
          expect(response.body).to include('You cannot remove this user.')
          expect(response.body).to include(second_admin.name)
        end
      end

      context 'when deleting own account' do
        it 'should not be allowed' do
          delete user_path(admin)
          expect(User.count).to eq(1)
          expect(response).to redirect_to users_url
          follow_redirect!
          expect(flash[:danger]).to be_present
          expect(response.body).to include('You cannot remove yourself.')
          expect(response.body).to include(admin.name)
        end
      end
    end
  end
end
