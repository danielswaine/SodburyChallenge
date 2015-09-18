class StaticPagesController < ApplicationController

  def home
    @teams = Team.all
  end

  def help
  end

  def about
  end
end
