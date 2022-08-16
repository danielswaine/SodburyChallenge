require 'rails_helper'

RSpec.describe Checkpoint, type: :request do
  let(:user) { create(:user) }
  let(:checkpoint) { create(:checkpoint) }

  describe 'non-logged in user' do
    after(:each) do
      follow_redirect!
      expect(flash[:danger]).to be_present
      expect(response.body).to include('Please log in to manage checkpoints.')
    end

    describe 'get index' do
      before { get checkpoints_path }
      it { expect(response).to redirect_to login_path }
    end

    describe 'get new' do
      before { get new_checkpoint_path }
      it { expect(response).to redirect_to login_path }
    end

    describe 'get edit' do
      before { get edit_checkpoint_path(checkpoint) }
      it { expect(response).to redirect_to login_path }
    end

    describe 'submitting to create action' do
      before { post checkpoints_path }
      it { expect(response).to redirect_to login_path }
    end

    describe 'submitting to update action' do
      before { patch checkpoint_path(checkpoint) }
      it { expect(response).to redirect_to login_path }
    end

    describe 'submitting to destroy action' do
      before { delete checkpoint_path(checkpoint) }
      it { expect(response).to redirect_to login_path }
    end
  end

  describe 'logged in' do
    before { sign_in user }

    describe 'index' do
      context 'html format' do
        it 'should paginate all checkpoints' do
          create_list(:checkpoint, 40)
          get checkpoints_path
          expect(response.body).to have_selector('div.pagination')
        end

        it 'should list each checkpoint' do
          create_list(:checkpoint, 20)
          get checkpoints_path
          Checkpoint.paginate(page: 1, per_page: 20).each do |checkpoint|
            expect(response.body).to have_selector(
              'td', text: checkpoint.number
            )
          end
        end

        it 'should order by checkpoint number' do
          cp = create(:checkpoint, number: 6)
          cp2 = create(:checkpoint, number: 9)
          cp3 = create(:checkpoint, number: 1)

          get checkpoints_path
          expect(assigns(:checkpoints).to_a).to eq [cp3, cp, cp2]
        end
      end

      context 'pdf format' do
        context 'when no checkpoints to display' do
          it 'should download pdf' do
            get checkpoints_path, format: :pdf
            expect(response.content_type).to eq('application/pdf')
          end
        end

        context 'when checkpoints to display' do
          it 'should download pdf' do
            create(:checkpoint)
            get checkpoints_path, format: :pdf
            expect(response.content_type).to eq('application/pdf')
          end
        end
      end
    end

    describe 'new' do
      context 'when no checkpoints exist' do
        it 'should assign first checkpoint number as 1' do
          get new_checkpoint_path
          expect(assigns(:checkpoint)).to be_a_new(Checkpoint)
          expect(assigns(:checkpoint).number).to eq(1)
        end
      end

      context 'when checkpoints exists' do
        it 'should assign new checkpoint with next available number' do
          second_checkpoint = create(:checkpoint)
          get new_checkpoint_path
          expect(assigns(:checkpoint)).to be_a_new(Checkpoint)
          expect(assigns(:checkpoint).number).to eq(
            second_checkpoint.number + 1
          )
        end
      end

      context 'when checkpoints have a gap in numbering' do
        it 'should assign the max number' do
          create(:checkpoint, number: 5)
          create(:checkpoint, number: 10)
          get new_checkpoint_path
          expect(assigns(:checkpoint)).to be_a_new(Checkpoint)
          expect(assigns(:checkpoint).number).to eq(11)
        end
      end
    end

    describe 'create' do
      context 'with invalid information' do
        it 'should not create a goal' do
          post checkpoints_path, { checkpoint: { description: '' } }
          expect(Checkpoint.count).to eq(0)
          expect(response).to render_template(:new)
        end
      end

      context 'with valid information' do
        it 'should create a checkpoint' do
          next_number = checkpoint.number + 1
          post checkpoints_path, { checkpoint: {
            number: next_number,
            grid_reference: '2345-6780',
            description: 'This is a description.'
          } }
          expect(Checkpoint.count).to eq(2)
          expect(response).to redirect_to checkpoints_path
          follow_redirect!
          expect(flash[:success]).to be_present
          expect(response.body).to include(
            "Checkpoint \##{next_number} saved."
          )
          expect(response.body).to include((checkpoint.number + 1).to_s)
        end
      end
    end

    describe 'edit' do
      it do
        get edit_checkpoint_path(checkpoint)
        expect(response.body).to include("Checkpoint \##{checkpoint.number}")
      end
    end

    describe 'update' do
      context 'with invalid information' do
        it 'should not update checkpoint' do
          old_description = checkpoint.description
          patch checkpoint_path(checkpoint), { checkpoint: { description: '' } }
          expect(response).to render_template(:edit)
          expect(checkpoint.description).to eq(old_description)
        end
      end

      context 'with valid information' do
        it 'should update checkpoint' do
          patch checkpoint_path(checkpoint), { checkpoint: {
            description: 'On fence'
          } }
          expect(Checkpoint.count).to eq(1)
          expect(response).to redirect_to checkpoints_path
          follow_redirect!
          expect(flash[:success]).to be_present
          expect(response.body).to include(
            "Checkpoint \##{checkpoint.number} updated."
          )
          expect(response.body).to include('On fence')
        end
      end
    end

    describe 'destroy' do
      it 'should destroy checkpoint' do
        old_number = checkpoint.number
        delete checkpoint_path(checkpoint)
        expect(Checkpoint.count).to eq(0)
        expect(response).to redirect_to checkpoints_path
        follow_redirect!
        expect(flash[:success]).to be_present
        expect(response.body).to include("Checkpoint \##{old_number} deleted.")
      end
    end
  end
end
