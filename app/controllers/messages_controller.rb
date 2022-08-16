class MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token, if: :valid_token?

  def sms
    data = params[:Body].split(' ')

    formatted_params = create_params_from_webhook_data(data)

    # TODO: Validate data and only create Message if okay
    Message.create(message_params(formatted_params)) if data.count == 11

    render nothing: true
  end

  private

  def valid_token?
    params[:token] == ENV['TWILIO_APP_TOKEN']
  end

  def create_params_from_webhook_data(data)
    ActionController::Parameters.new(
      {
        message: {
          team_number: data[0],
          gps_fix_timestamp: Message.format_date(data[1], data[2]),
          latitude: Message.convert_to_latitude(data[3], data[4]).to_s,
          longitude: Message.convert_to_longitude(data[5], data[6]).to_s,
          speed: Message.convert_to_kph(data[7]).to_s,
          battery_voltage: data[8],
          battery_level: data[9],
          rssi: data[10],
          mobile_number: params[:From]
        }
      }
    )
  end

  def message_params(formatted)
    formatted.require(:message).permit(
      :team_number, :gps_fix_timestamp, :latitude, :longitude, :speed,
      :battery_voltage, :battery_level, :rssi, :mobile_number
    )
  end
end
