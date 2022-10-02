class Message < ActiveRecord::Base
  # Convert from degrees, minutes, seconds to latitude
  def self.convert_to_latitude(latitude, ns)
    converted_latitude = (latitude[0..1].to_f + latitude[2..-1].to_f / 60).round(5)
    converted_latitude *= -1 if ns == 'S'
    converted_latitude
  end

  # Convert from degrees, minutes, seconds to longitude
  def self.convert_to_longitude(longitude, ew)
    converted_longitude = (longitude[0..2].to_f + longitude[3..-1].to_f / 60).round(5)
    converted_longitude *= -1 if ew == 'W'
    converted_longitude
  end

  # Convert knots to kph
  def self.convert_to_kph(knots)
    (knots.to_f * 1.852).round(1)
  end

  # Convert date and time into UTC format
  def self.format_date(date, time)
    day = date[0, 2]
    month = date[2, 2]
    year = date[4, 2]
    t = time.first(6)
    Time.parse("20#{year}#{month}#{day}T#{t}Z")
  end

  def self.battery_character_to_word(battery)
    case battery
    when 'G'
      'Good'
    when 'L'
      'Low'
    when 'D'
      'Dead'
    else
      'Unknown'
    end
  end

  def self.scale_rssi(rssi, from_min, from_max, to_min, to_max)
    ((to_max - to_min) * (rssi - from_min)) / (from_max - from_min) + to_min
  end

  def self.dbm_to_word(dbm)
    if dbm >= -70
      'Excellent'
    elsif dbm <= -70 && dbm >= -85
      'Good'
    elsif dbm <= -86 && dbm >= -100
      'Fair'
    elsif dbm <= -100
      'Poor'
    else
      'Unknown'
    end
  end

  def self.rssi_to_dbm(rssi)
    case rssi
    when 0
      '<= -113dBm'
    when 1
      '-111dBm'
    when 2..30
      scaled = scale_rssi(rssi, 2, 30, -109, -53)
      "#{scaled} dBm"
    when 31
      '>= -51dBm'
    else
      'Unknown'
    end
  end

  def self.find_messages_from_challenge_date(date)
    messages = Message.where(gps_fix_timestamp: (date - 1.week)..(date + 1.week))
                      .order(:team_number)
                      .order(gps_fix_timestamp: :desc)
                      .group_by(&:team_number)

    messages.map do |group, array|
      arr = array.sort_by(&:gps_fix_timestamp).reverse
      latest = arr.first

      {
        team_number: group,
        latest: format_message(latest),
        route: arr.map { |m| format_message(m) },
      }
    end
  end

  def self.format_message(message)
    battery_level = battery_character_to_word(message.battery_level)
    timestamp = message.gps_fix_timestamp
    dbm = rssi_to_dbm(message.rssi)

    # Remove less/greater than from string
    dbm_word = dbm_to_word(dbm.gsub(/([<>]= )?/, '').to_i)

    {
      id: message.id,
      team_number: message.team_number,
      timestamp: timestamp,
      latitude: message.latitude,
      longitude: message.longitude,
      battery: "#{battery_level} (#{message.battery_voltage}V)",
      speed: message.speed,
      rssi: "#{dbm} (#{dbm_word})",
      mobile_number: message.mobile_number
    }
  end
end
