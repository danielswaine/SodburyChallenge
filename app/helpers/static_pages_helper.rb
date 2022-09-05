module StaticPagesHelper
  # Return a unique list of groups associated with the teams of a challenge
  def group_list(teams)
    teams.map { |c| c.group.capitalize }
         .uniq
         .to_sentence(two_words_connector: ' & ', last_word_connector: ' & ')
  end

  # Return a result table that handles order, equal scores and lateness
  def results_table(teams)
    results = []
    sorted = teams.order(:score).reverse.group_by(&:score)
    position = 1

    sorted.each do |_score, arr|
      if arr.size > 1 # More than one team has the same score.
        sorted_lateness = arr.sort_by { |t| lateness_in_minutes(expected_finish_time(t), t.finish_time) }
        minutes_late = lateness_in_minutes(expected_finish_time(arr.first), arr.first.finish_time)

        sorted_lateness.each_with_index do |team, index|
          # All teams finished at the same time, so have equal scores.
          if arr.all? { |a| lateness_in_minutes(expected_finish_time(a), a.finish_time) == minutes_late }
            results.push(
              {
                position: "#{position.ordinalize}=",
                name: team.name,
                score: team.score,
                minutes_late: lateness_in_minutes(expected_finish_time(team), team.finish_time)
              }
            )
            position += 1 if arr.size - 1 == index
          else
            # Teams finished at different times.
            results.push(
              {
                position: position.ordinalize,
                name: team.name,
                score: team.score,
                minutes_late: lateness_in_minutes(expected_finish_time(team), team.finish_time)
              }
            )
            position += 1
          end
        end
      else
        results.push(
          {
            position: position.ordinalize,
            name: arr.first.name,
            score: arr.first.score,
            minutes_late: nil
          }
        )
        position += 1
      end
    end

    results
  end

  def format_minutes_late(minutes)
    if minutes.nil?
      ''
    elsif minutes < 0
      "(finished #{minutes.abs} minutes early)"
    elsif minutes == 0
      '(finished exactly on time)'
    elsif minutes > 0
      "(finished #{minutes.abs} minutes late)"
    end
  end
end
