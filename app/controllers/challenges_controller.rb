class ChallengesController < ApplicationController
  before_action :user_logged_in?
  before_action :user_is_admin?
  before_action :find_challenge, only: [:edit, :update, :destroy]

  def index
    @challenges = Challenge.all.order(:date)
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

  def edit
  end

  def update
    if @challenge.update(challenge_params)
      flash[:success] = "Challenge updated."
      redirect_to challenges_path
    else
      render 'edit'
    end
  end


  private

    def find_challenge
      @challenge = Challenge.find(params[:id])
    end

    def challenge_params
      params.require(:challenge).permit(
                                         :date, :time_allowed#, :bonus_one, :bonus_two,
                                         #:bonus_three, :bonus_four, :bonus_five
      )
    end

    def user_logged_in?
      unless logged_in?
        store_location
        flash[:danger] = "Please log in to manage challenges."
        redirect_to login_url
      end
    end

    def user_is_admin?
      unless current_user.admin?
        flash[:warning] = "Sorry, challenges are currently a development feature."
        redirect_to root_url
      end
    end

end
