class OfficialTimeController < ApplicationController

  def index
    render json: time_now.to_json
  end

  def time_now
    # Returns the number of milliseconds since the Unix epoch.
    (Time.now.to_f * 1000).round
  end

end
