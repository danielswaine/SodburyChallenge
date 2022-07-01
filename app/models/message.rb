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
end
