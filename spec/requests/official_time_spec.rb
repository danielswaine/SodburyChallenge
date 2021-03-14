require 'rails_helper'

RSpec.describe OfficialTimeController, type: :request do
  describe 'index' do
    it 'should respond with JSON' do
      get time_path
      expect(response.content_type).to eq('application/json')
    end

    it 'should return a time object' do
      time = Time.new(Date.today.year, 1, 1)
      travel_to time do
        get time_path
        expect(response.body).to eq(
          {
            zone: time.gmtoff * 1000,
            unix: (time.to_f * 1000).round
          }.to_json
        )
      end
    end
  end
end
