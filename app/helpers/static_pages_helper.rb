module StaticPagesHelper

  # Return a unique list of groups associated with the teams of a challenge
  def group_list(teams)
    teams.map{|c| c.group.capitalize}
         .uniq
         .to_sentence(two_words_connector: " & ", last_word_connector: " & ")
  end

end
