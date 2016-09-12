module TeamsHelper

  # Returns the most accurate start time of a team.
  def start_time(team)
    has_started?(team) ? team.actual_start_time : team.planned_start_time
  end

  # Returns the most accurate phone-in time for a team.
  def phone_in_time(team)
    has_phoned_in?(team) ? team.phone_in_time : expected_phone_in_time(team)
  end

  # Returns the most accurate finish time of a team.
  def finish_time(team)
    has_finished?(team) ? team.finish_time : expected_finish_time(team)
  end

  # Returns a string representing the current status of a team.
  def current_status(team)
    if team.dropped_out?
      "Dropped out"
    elsif has_finished? team
      "Finished"
    elsif has_phoned_in? team
      "Phoned in"
    elsif has_started? team
      "On course"
    else
      nil
    end
  end

  # Used to only open collapsible panel for current year's challenge
  def is_current_year(challenge)
    if challenge.date.year == Time.now.year
      " in"
    else
      nil
    end
  end

  # Returns true if a team has started on the course.
  def has_started?(team)
    !team.actual_start_time.to_s.empty?
  end

  # Returns true if a team has phoned in.
  def has_phoned_in?(team)
    !team.phone_in_time.to_s.empty?
  end

  # Returns true if a team has finished.
  def has_finished?(team)
    !team.finish_time.to_s.empty?
  end

  # Returns a string explaining why a team was disqualified.
  def reason_for_disqualification(team)
    if team.disqualified?
      if team.dropped_out?
        "Dropped out"
      elsif !visited_compulsory_checkpoints?(team)
        "Omitted compulsory"
      elsif finished_late? team
        "Finished late"
      elsif team.forgot_to_phone_in
        "Didn't phone in"
      else
        "Disqualified"  # Disqualified manually for another reason.
      end
    end
  end

  # Returns true if a team finished over 30 minutes late.
  def finished_late?(team)
    if has_finished? team
      lateness_in_minutes(expected_finish_time(team), team.finish_time) >= 30
    end
  end

  # Returns true if a team visited all compulsory checkpoints.
  def visited_compulsory_checkpoints?(team)
    if has_finished? team
      visited_all = true
      team.challenge.goals.each do |goal|
        visited_checkpoint = eval("[#{team.visited}]").include?(goal.checkpoint.number)
        visited_all &&= visited_checkpoint if goal.compulsory?
      end
      visited_all
    end
  end

  # Takes a 24-hour time string and returns the number of minutes since 00:00.
  def time_to_i(time)
    time_array = eval("[#{time.to_s.tr(':', ',').gsub(/0([0-9])/, '\1')}]")
    60 * time_array[0].to_i + time_array[1].to_i
  end

  # Returns the number of minutes between two 24-hour time strings, assuming
  # that they are within 12 hours of each other.
  def lateness_in_minutes(intended_time, actual_time)
    lateness = time_to_i(actual_time) - time_to_i(intended_time)
    if lateness > 720
      lateness -= 1440
    elsif lateness < -720
      lateness += 1440
    end
    lateness
  end

  # Returns the expected phone-in time of a team.
  def expected_phone_in_time(team)
    started_at = Time.parse("#{team.challenge.date}T#{start_time(team)}")
    (started_at + team.challenge.time_allowed * 1800).strftime("%R")
  end

  # Returns the expected finish time of a team.
  def expected_finish_time(team)
    started_at = Time.parse("#{team.challenge.date}T#{start_time(team)}")
    (started_at + team.challenge.time_allowed * 3600).strftime("%R")
  end

end
