class TeamsController < ApplicationController
  before_action :user_logged_in?
  before_action :find_team, only: [:edit, :update, :destroy]

  # GET /teams
  def index
    @challenges = Challenge.all
    respond_to do |format|
      format.html # index.html.erb
      format.pdf # index.pdf.prawn
    end
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/:id/edit
  def edit
  end

  # POST /teams
  def create
    @team = Team.new(team_params)
    if @team.save
      flash[:success] = "Team created sucessfully."
      redirect_to teams_url
    else
      render 'new'
    end
  end

  # PATCH|PUT /teams/:id
  def update
    if @team.update(team_params)
      flash[:success] = "Team updated sucessfully."
      redirect_to teams_url
    else
      render 'edit'
    end
  end

  # DELETE /teams/:id
  def destroy
    @team.destroy
    flash[:success] = "Team deleted successfully."
    redirect_to teams_url
  end

  private

    def find_team
      @team = Team.find(params[:id])
    end

    def team_params
      params.require(:team).permit(
                                    :challenge_id, :group, :name, :nominal_start_time,
                                    :actual_start_time, :phone_in_time, :finish_time,
                                    :visited, :score, :disqualified
                                  )
    end

    def user_logged_in?
      unless logged_in?
        store_location
        flash[:danger] = "Please log in to manage teams."
        redirect_to login_url
      end
    end

end
