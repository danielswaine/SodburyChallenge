require 'rails_helper'

RSpec.describe GoalsHelper, type: :helper do
  describe 'get_type' do
    context 'when given a start goal' do
      it 'should return goal type' do
        goal = build_stubbed(:goal, :start_point)
        expect(get_type(goal)).to eq('Start')
      end
    end

    context 'when given a compulsory goal' do
      it 'should return goal type' do
        goal = build_stubbed(:goal, :compulsory)
        expect(get_type(goal)).to eq('Compulsory')
      end
    end

    context 'when given a normal goal' do
      it 'should return nothing' do
        goal = build_stubbed(:goal)
        expect(get_type(goal)).to eq('')
      end
    end
  end
end
