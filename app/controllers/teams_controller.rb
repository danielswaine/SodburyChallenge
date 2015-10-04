class TeamsController < ApplicationController
  before_action :user_logged_in?
  before_action :find_team, only: [:edit, :update, :destroy]

  # GET /teams
  def index
    @teams = Team.all
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
      redirect_to @team
    else
      render 'new'
    end
  end

  # PATCH|PUT /teams/:id
  def update
    if @team.update(team_params)
      flash[:success] = "Team updated sucessfully."
      redirect_to @team
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
      params.require(:team).permit()
    end

    def user_logged_in?
      unless logged_in?
        store_location
        flash[:danger] = "Please log in to manage teams."
        redirect_to login_url
      end
    end

end
