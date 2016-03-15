module GoalsHelper

  # Returns  a string representing the type of goal
  def get_type(goal)
    if goal.start_point?
      "Start"
    elsif goal.compulsory?
      "Compulsory"
    else
      ""
    end
  end

end
