class StaticPagesController < ApplicationController

  def home
    @challenges = Challenge.where(date:(Date.today.beginning_of_year..Date.today.end_of_year)).order(:time_allowed)
  end

  def results
    @challenges = Challenge.where(date:(Date.today.beginning_of_year..Date.today.end_of_year)).order(:time_allowed)
  end

  def rules
  end

  def about
  end
end
