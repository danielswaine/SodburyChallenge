module ChallengesHelper

  def points_available(challenge)

    start_with = 30
    phone_in_bonus = 30

    from_goals = challenge.goals.reduce(0) do |tally, goal|
      tally += goal.points_value
    end

    from_bonuses = challenge.time_allowed > 5 ? 85 : 0  # TODO

    start_with + phone_in_bonus + from_goals + from_bonuses
  end

end
