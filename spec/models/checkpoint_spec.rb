require 'rails_helper'

RSpec.describe Checkpoint, type: :model do
  describe '#to_param' do
    it 'uses number as default identifier for routes' do
      checkpoint = build(:checkpoint, number: 5)
      expect(checkpoint.to_param).to eq('5')
    end
  end

  describe 'associations' do
    it { should have_many(:goals) }

    it { should have_many(:challenges).through(:goals) }
  end

  describe 'validations' do
    context 'when given a new number' do
      it do
        should validate_uniqueness_of(:number).ignoring_case_sensitivity
      end

      it do
        should validate_numericality_of(:number)
          .only_integer
          .with_message('must be a positive integer')
      end

      it do
        should validate_numericality_of(:number)
          .is_greater_than_or_equal_to(1)
          .with_message('must be a positive integer')
      end
    end

    context 'when given a new grid reference' do
      # Valid grid references.
      VALID_GRID_REFERENCES = [
        '9380-0190',
        '9380-0195',
        '9385-0190',
        '9385-0195'
      ].freeze

      # Invalid grid references due to length.
      INVALID_LENGTH_GRID_REFERENCES = [
        '9382-01970',
        '93840-0192',
        '93810-01900'
      ].freeze

      # Invalid grid references due to final digit of each part must
      # be a 0 or 5.
      INVALID_FORMAT_GRID_REFERENCES = [
        '9380-0193',
        '9387-0190',
        '9383-0198'
      ].freeze

      it {
        is_expected.to allow_values(*VALID_GRID_REFERENCES).for(:grid_reference)
      }

      it {
        is_expected.not_to allow_values(*INVALID_LENGTH_GRID_REFERENCES)
          .for(:grid_reference)
          .with_message('must look like 2345-7890')
      }

      it {
        is_expected.not_to allow_values(*INVALID_FORMAT_GRID_REFERENCES)
          .for(:grid_reference)
          .with_message('parts must end in a 0 or a 5')
      }
    end

    context 'when given a new description' do
      it 'removes surplus whitespace' do
        checkpoint = build_stubbed(
          :checkpoint, description: "   Some  Random \tDescription  \r\n "
        )
        checkpoint.valid?
        expect(checkpoint.description).to eq('Some Random Description')
      end

      it do
        is_expected.to validate_length_of(:description)
          .is_at_least(5).with_short_message('is too short')
          .is_at_most(400).with_long_message('is too long')
      end
    end
  end
end
