class StaticPagesController < ApplicationController
  before_action :find_challenge, only: %i[home results]

  def home; end

  def results; end

  def rules; end

  def about; end

  def archive
    @challenges = Challenge.where(published: true)
                           .order(date: :desc)
                           .group_by(&:date)
  end

  def year_archive
    date = DateTime.new(params[:year].to_i)
    @challenges = Challenge.where(
      published: true,
      date: date.beginning_of_year..date.end_of_year
    ).order(:time_allowed)
  end

  private

  def find_challenge
    @challenges = Challenge.where(
      date: (Date.today.beginning_of_year..Date.today.end_of_year)
    ).order(:time_allowed)
  end
end
