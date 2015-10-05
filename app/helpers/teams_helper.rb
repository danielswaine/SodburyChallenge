module TeamsHelper

  # Returns the most accurate start time of a team.
  def start_time(team)
    if has_started? team
      team.actual_start_time
    else
      team.nominal_start_time
    end
  end

  # Returns the most accurate phone-in time for a team.
  def phone_in_time(team)
    if has_phoned_in? team
      team.phone_in_time
    else
      start_time = Time.parse("#{team.challenge.date}T#{start_time(team)}")
      (start_time + team.challenge.time_allowed * 1800).strftime("%R")
    end
  end

  # Returns the most accurate finish time of a team.
  def finish_time(team)
    if has_finished? team
      team.finish_time
    else
      start_time = Time.parse("#{team.challenge.date}T#{start_time(team)}")
      (start_time + team.challenge.time_allowed * 3600).strftime("%R")
    end
  end

  # Returns a string representing the current status of a team.
  def current_status(team)
    if has_finished? team
      "Finished"
    elsif has_phoned_in? team
      "Phoned in"
    elsif has_started? team
      "On course"
    else
      nil
    end
  end


  # Returns true if a team has started on the course.
  def has_started?(team)
    !team.actual_start_time.nil?
  end

  # Returns true if a team has phoned in.
  def has_phoned_in?(team)
    !team.phone_in_time.nil?
  end

  # Returns true if a team has finished.
  def has_finished?(team)
    !team.finish_time.nil?
  end

end
