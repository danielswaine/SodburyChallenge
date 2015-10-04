class UsersController < ApplicationController
  before_action :user_logged_in?
  before_action :find_user, only: [:edit, :update, :destroy]
  before_action :correct_user?, only: [:edit, :update]
  before_action :check_not_self, only: [:destroy]
  before_action :check_not_admin, only: [:destroy]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "#{@user.name} has been added to the Sodbury Challenge app!"
      redirect_to users_path
    else
      render 'new'
    end
  end

  def destroy
    old_name = @user.name
    @user.destroy
    flash[:success] = "#{old_name} has been removed."
    redirect_to users_path
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Account details updated."
      redirect_to users_path
    else
      render 'edit'
    end
  end


  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def find_user
      @user = User.find(params[:id])
    end

    def check_not_admin
      if @user.admin?
        flash[:danger] = "You cannot remove this user."
        redirect_to users_path
      end
    end

    def check_not_self
      if current_user? @user
        flash[:danger] = "You cannot remove yourself."
        redirect_to users_path
      end
    end

    def user_logged_in?
      unless logged_in?
        store_location
        flash[:danger] = "Please log in to manage users."
        redirect_to login_url
      end
    end

    def correct_user?
      unless current_user? @user
        flash[:danger] = "You can only edit your own account."
        redirect_to users_url
      end
    end

end
