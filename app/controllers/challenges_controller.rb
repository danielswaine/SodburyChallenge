class ChallengesController < ApplicationController
  before_action :user_logged_in?
  before_action :find_challenge, only: [:show, :results, :update, :publish, :destroy, :statistics, :clipper, :master_list]
  before_action :locations, only: :map_update
  before_action :all_teams_scored?, only: [:publish]

  def index
    @challenges = Challenge.all.order(:date, :time_allowed)
  end

  def show
    @goals ||= @challenge.goals
    respond_to do |format|
      format.html # show.html.erb
      format.pdf # show.pdf.prawn
    end
  end

  def clipper
  end

  def master_list
    @challenges = Challenge.all
  end

  def team_certificates
    @challenges = Challenge.where(date: params[:date])
  end

  def new
    @challenge = Challenge.new
  end

  def create
    @challenge = Challenge.new(challenge_params)
    if @challenge.save
      flash[:success] = "Challenge created successfully."
      redirect_to challenges_path
    else
      render 'new'
    end
  end

  def destroy
    @challenge.destroy
    flash[:success] = "Challenge deleted."
    redirect_to challenges_path
  end

  def update
    if @challenge.update(challenge_params)
      flash[:success] = "Challenge updated."
      redirect_to challenges_path
    else
      @goals = @challenge.goals
      flash[:danger] = "Bonus is incorrectly formatted."
      render 'show'
    end
  end

  def publish
    if @challenge.update({ id: params[:id], published: true })
      flash[:success] = "Results published successfully."
      redirect_to results_path
    else
      flash[:danger] = "Results could not be published."
      redirect_to challenges_path
    end
  end

  # GET /challenges/:id/statistics
  def statistics
  end

  def map_update
    @challenges = Challenge.where(date: @challenge.date)
    @goals = @challenges.map {
      |c| c.goals.includes(:checkpoint).pluck(:number, :grid_reference, :description, :points_value).map {
        |n, gf, d, p| {
          number: n, grid_reference: gf, description: d, points_value: p
        }
      }
    }.flatten
    render json: {goals: @goals, locations: @locations}
  end

  def map
  end

  private

    def locations
      find_challenge
      dt = DateTime.new(@challenge.date.year)
      boy = dt.beginning_of_year
      eoy = dt.end_of_year
      latest_ids = Message.where(date: boy..eoy).group(:team_number)
                                                .maximum(:id)
                                                .values
      @locations = Message.where(id: latest_ids).order(:team_number)
    end

    def find_challenge
      @challenge = Challenge.find(params[:id])
    end

    def challenge_params
      params.require(:challenge).permit(
                                         :date, :time_allowed, :bonus_one, :bonus_two,
                                         :bonus_three, :bonus_four, :bonus_five
      )
    end

    def user_logged_in?
      unless logged_in?
        store_location
        flash[:danger] = "Please log in to manage challenges."
        redirect_to login_url
      end
    end

    def all_teams_scored?
      ready = @challenge.teams.reduce(true) { |memo, team| memo && !team.score.nil? }
      unless ready
        flash[:danger] = "Please score all teams in the challenge before publishing results."
        redirect_to teams_path
      end
    end

end
