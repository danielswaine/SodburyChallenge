class GoalsController < ApplicationController
  before_action :user_logged_in?
  before_action :find_goal, only: [:edit, :update, :destroy]

  def new
    @goal = Goal.new
  end

  def edit
  end

  def create
    @goal = Goal.new(goal_params)
    if @goal.save
      flash[:success] = "Goal added."
      redirect_to challenge_path(@goal.challenge_id)
    else
      render 'new'
    end
  end

  def update
    if @goal.update(goal_params)
      flash[:success] = "Goal updated."
      redirect_to challenge_path(@goal.challenge_id)
    else
      render 'edit'
    end
  end

  def destroy
    @goal.destroy
    flash[:success] = "Goal removed."
    redirect_to challenge_path(@goal.challenge_id)
  end

  private

    def find_goal
      @goal = Goal.find(params[:id])
    end

    def goal_params
      params.require(:goal).permit(
                                    :challenge_id, :checkpoint_id,
                                    :points_value, :compulsory, :start_point
                                  )
    end

    def user_logged_in?
      unless logged_in?
        store_location
        flash[:danger] = "Please log in to manage goals."
        redirect_to login_url
      end
    end

end
