class MessagesController < ApplicationController

  skip_before_action :verify_authenticity_token, if: :valid_token?

  def sms
    data = params[:Body].split(' ')

    # TODO: Validate data and only create Message if okay
    if data.count == 10
      Message.create(
        team_number: data[0],
        date: Date.new(Time.now.year, data[1][2..3].to_i, data[1][0..1].to_i),
        time: data[2][0..1] + ":" + data[2][2..3],
        latitude: Message.convert_to_latitude(data[3], data[4]).to_s,
        longitude: Message.convert_to_longitude(data[5], data[6]).to_s,
        speed: Message.convert_to_kph(data[7]).to_s,
        battery: data[8],
        signal_strength: Message.convert_signal_to_percentage(data[9]),
        mobile_number: params[:From]
      )
    end

    render nothing: true
  end

  private

  def valid_token?
    params[:token] == ENV["TWILIO_APP_TOKEN"]
  end

end
