class StaticPagesController < ApplicationController

  def home
    @challenges = Challenge.all
  end

  def rules
  end

  def about
  end
end
