require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe 'full_title' do
    BASE_TITLE = "Sodbury Challenge #{Date.current.year}".freeze
    PAGE_NAME = 'About'.freeze
    let(:with_title) { full_title(PAGE_NAME) }

    context 'when page_title is empty' do
      it 'should not include a page name' do
        expect(full_title).to eq(BASE_TITLE)
      end
    end

    context 'when page_title is not empty' do
      it 'should include a page name' do
        expect(with_title).to include(PAGE_NAME)
      end

      it 'should include a hyphen' do
        expect(with_title).to include('-')
      end

      it 'should have page title first' do
        expect(with_title).to eq(PAGE_NAME + ' - ' + BASE_TITLE)
      end
    end
  end
end
