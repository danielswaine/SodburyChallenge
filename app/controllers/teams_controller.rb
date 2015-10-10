class TeamsController < ApplicationController
  before_action :user_logged_in?
  before_action :find_team, only: [:edit, :log, :update_times, :update,
                                   :score, :update_score, :destroy]
  before_action :team_times_saved?, only: [:score, :update_score]

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

  # GET /teams/:id/log
  def log
  end

  # PATCH /teams/:id/log
  def update_times
    if @team.update(team_params)
      flash[:success] = "Team times saved."
      redirect_to root_path
    else
      render 'log'
    end
  end


  # GET /teams/:id/score
  def score
  end

  # PATCH /teams/:id/score
  def update_score
    if @team.update(team_params)
      flash[:success] = "Team score saved."
      redirect_to teams_path
    else
      render 'score'
    end
  end

  # POST /teams
  def create
    @team = Team.new(team_params)
    if @team.save
      flash[:success] = "Team created sucessfully."
      redirect_to teams_path
    else
      render 'new'
    end
  end

  # PATCH|PUT /teams/:id
  def update
    if @team.update(team_params)
      flash[:success] = "Team updated sucessfully."
      redirect_to teams_path
    else
      render 'edit'
    end
  end

  # DELETE /teams/:id
  def destroy
    @team.destroy
    flash[:success] = "Team deleted successfully."
    redirect_to teams_path
  end

  private

    def find_team
      @team = Team.find(params[:id])
    end

    def team_params
      params.require(:team).permit(
                                    :challenge_id, :group, :name, :planned_start_time,
                                    :actual_start_time, :phone_in_time, :finish_time,
                                    :visited, :score, :disqualified, :dropped_out,
                                    :forgot_to_phone_in
                                  )
    end

    def user_logged_in?
      unless logged_in?
        store_location
        flash[:danger] = "Please log in to manage teams."
        redirect_to login_url
      end
    end

    def team_times_saved?
      if @team.actual_start_time.to_s.empty?
        flash[:danger] = "Please submit team start time before scoring."
        redirect_to log_team_path(@team)
      elsif @team.phone_in_time.to_s.empty? && !@team.forgot_to_phone_in?
        flash[:danger] = "Please submit phone in time (or mark as forgotten) before scoring."
        redirect_to log_team_path(@team)
      elsif @team.finish_time.to_s.empty? && !@team.dropped_out?
        flash[:danger] = "Please submit finish time (or mark as dropped out) before scoring."
        redirect_to log_team_path(@team)
      end
    end

end
