require 'rails_helper'

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
end
