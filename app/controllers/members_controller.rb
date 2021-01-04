class MembersController < ApplicationController
  before_action :user_logged_in?
  before_action :set_member, only: [:edit, :update, :destroy]

  def new
    @member = Member.new
  end

  def edit; end

  def create
    @member = Member.new(member_params)
    if @member.save
      flash[:success] = 'Member added.'
      redirect_to edit_team_path(@member.team_id)
    else
      render 'new'
    end
  end

  def update
    if @member.update(member_params)
      flash[:success] = 'Member updated.'
      redirect_to edit_team_path(@member.team_id)
    else
      render 'edit'
    end
  end

  def destroy
    @member.destroy
    flash[:success] = 'Member removed.'
    redirect_to edit_team_path(@member.team_id)
  end

  private

  def set_member
    @member = Member.find(params[:id])
  end

  def member_params
    params.require(:member).permit(:name, :team_id)
  end

  def user_logged_in?
    unless logged_in?
      store_location
      flash[:danger] = 'Please log in to manage members.'
      redirect_to login_url
    end
  end
end
