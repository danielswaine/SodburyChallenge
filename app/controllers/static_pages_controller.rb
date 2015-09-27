class StaticPagesController < ApplicationController

  def home
    @teams = Team.all
  end

  def rules
  end

  def about
  end
end
