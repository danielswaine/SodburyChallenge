require 'rails_helper'

RSpec.describe StaticPagesController, type: :request do
  let(:user) { create(:user) }

  describe 'home' do
    it 'assigns @challenges' do
      create(:challenge, date: 1.year.ago)
      eight = create(:challenge, :eight_hour, date: Date.today)
      five = create(:challenge, date: Date.today)
      get root_path
      expect(assigns(:challenges).to_a).to eq([five, eight])
    end

    context 'non-logged in user' do
      it 'should have public team information' do
        get root_path
        expect(response.body).to include('Official Start Times')
        expect(response.body).not_to include('Phone In Time')
        expect(response.body).not_to include('Status')
      end

      it 'should only contain the current year\'s challenges' do
        create(:challenge, :with_team, date: Date.today)
        create(:challenge, :with_team, date: 1.year.ago)
        get root_path
        expect(response.body).to have_selector('table.table-striped', count: 1)
      end
    end

    context 'logged-in user' do
      before { sign_in user }

      it 'should have private content' do
        create(:challenge, :with_team, date: Date.today)
        get root_path
        expect(response.body).to include('Team Status')
        expect(response.body).to include('Phone In Time')
        expect(response.body).to include('Status')
      end

      it 'should only contain the current year\'s challenges' do
        create(:challenge, :with_team, date: Date.today)
        create(:challenge, :with_team, date: 1.year.ago)
        get root_path
        expect(response.body).to have_selector('table.table-striped', count: 1)
      end
    end
  end

  describe 'results' do
    it 'assigns @challenges' do
      create(:challenge, date: 1.year.ago)
      eight = create(:challenge, :eight_hour, date: Date.today)
      five = create(:challenge, date: Date.today)
      get root_path
      expect(assigns(:challenges).to_a).to eq([five, eight])
    end

    context 'non-logged in user' do
      it 'should contain the current year\'s results' do
        get results_path
        expect(response.body).to include("Official Results #{Time.now.year}")
      end

      it 'should contain challenge results table if published' do
        create(:challenge, :with_team, :published, date: Date.today)
        get results_path
        expect(response.body).to have_selector('table.table-striped')
      end

      it 'should not contain challenge results table if not published' do
        create(:challenge, :with_team, date: Date.today)
        get results_path
        expect(response.body).not_to have_selector('table.table-striped')
      end

      it 'should only contain the current year\'s challenges' do
        create(:challenge, :with_team, date: Date.today)
        create(:challenge, :with_team, date: 1.year.ago)
        get root_path
        expect(response.body).to have_selector('table.table-striped', count: 1)
      end
    end

    context 'logged-in user' do
      before { sign_in user }

      it 'should have private content' do
        create(:challenge, :with_team, date: Date.today)
        get results_path
        expect(response.body).to include('Official Results')

        # This line is split due to the \n and spaces not being matched correctly
        expect(response.body).to include(
          'These results are not visible publicly until you'
        )
        expect(response.body).to include('<a href="/challenges">publish them</a>.')
      end

      it 'should contain challenge results table if published' do
        create(:challenge, :with_team, :published, date: Date.today)
        get results_path
        expect(response.body).to have_selector('table.table-striped')
      end

      it 'should contain challenge results table if not published' do
        create(:challenge, :with_team, :published, date: Date.today)
        get results_path
        expect(response.body).to have_selector('table.table-striped')
      end

      it 'should only contain the current year\'s challenges' do
        create(:challenge, :with_team, date: Date.today)
        create(:challenge, :with_team, date: 1.year.ago)
        get root_path
        expect(response.body).to have_selector('table.table-striped', count: 1)
      end
    end
  end

  describe 'rules' do
    it 'should have content Rules' do
      get rules_path
      expect(response.body).to include('Rules')
    end
  end

  describe 'about' do
    it 'should have content About the Challenge' do
      get about_path
      expect(response.body).to include('About the Challenge')
    end
  end

  describe 'archive' do
    it 'assigns @challenges' do
      past = create(:challenge, :published, date: 1.year.ago)
      create(:challenge, date: Date.today)
      now_published = create(:challenge, :published, date: Date.today)
      get archive_path
      expect(assigns(:challenges)).to eq(
        {
          Date.today => [now_published],
          Date.today - 1.year => [past]
        }
      )
    end

    it 'should have the content Previous Results' do
      get archive_path
      expect(response.body).to include('Previous Results')
    end

    it 'should not contain a block if challenge not published' do
      now = Date.today
      past = now - 1.year
      create(:challenge, :published, date: now)
      create(:challenge, date: past)
      get archive_path
      expect(response.body).to have_selector('div.well.well-lg', count: 1)
      expect(response.body).to have_selector('h3.center', text: now.year, count: 1)
    end

    it 'should contain a block per challenge year if published' do
      now = Date.today
      past = now - 1.year
      create(:challenge, :published, date: now)
      create(:challenge, :published, date: past)
      get archive_path
      expect(response.body).to have_selector('div.well.well-lg', count: 2)
      expect(response.body).to have_selector('h3.center', text: now.year, count: 1)
      expect(response.body).to have_selector('h3.center', text: past.year, count: 1)
    end
  end

  describe 'year_archive' do
    it 'assigns @challenges' do
      now = Date.today
      create(:challenge, date: now - 1.year)
      five = create(:challenge, :published, date: now)
      eight = create(:challenge, :published, :eight_hour, date: now)
      get year_archive_path(year: now.year)
      expect(assigns(:challenges).to_a).to eq([five, eight])
    end

    it 'should have the content year results' do
      now = Date.today
      create(:challenge, :published, date: now)
      get year_archive_path(year: now.year)
      expect(response.body).to include("#{now.year} Results")
    end

    it 'should contain a table of results if published' do
      create(:challenge, :with_team, :published, date: Date.today)
      get year_archive_path(year: Date.today.year)
      expect(response.body).to have_selector('table.table-striped', count: 1)
    end

    it 'should not contain a table of results if not published' do
      create(:challenge, :with_team, date: Date.today)
      get year_archive_path(year: Date.today.year)
      expect(response.body).not_to have_selector('table.table-striped', count: 1)
    end
  end
end
