class OfficialTimeController < ApplicationController

  def index
    render json: time_object.to_json
  end

  def time_object
    zone = Time.now.gmtoff * 1000  # Server UTC offset in milliseconds
    unix = (Time.now.to_f * 1000).round  # Server Unix time in milliseconds
    { zone: zone, unix: unix }
  end

end
