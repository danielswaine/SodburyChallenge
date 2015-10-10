module ChallengesHelper

  def points_available(challenge)

    start_with = 30
    phone_in_bonus = 30

    from_goals = challenge.goals.reduce(0) do |tally, goal|
      tally + goal.points_value
    end

    from_bonuses = bonuses(challenge).reduce(0) do |tally, bonus|
      tally + (bonus ? bonus[:value] : 0)
    end

    start_with + phone_in_bonus + from_goals + from_bonuses
  end

  def bonuses(challenge)

    [
      eval(challenge.bonus_one.to_s),
      eval(challenge.bonus_two.to_s),
      eval(challenge.bonus_three.to_s),
      eval(challenge.bonus_four.to_s),
      eval(challenge.bonus_five.to_s)
    ]

  end

end
