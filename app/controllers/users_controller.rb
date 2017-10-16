#
class UsersController < ApplicationController
  # GET /users/1
  def show
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'User not found.'
    redirect_back fallback_location: root_url
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = 'User successfully created'
      redirect_to @user
    else
      render :new
    end
  end

  private

  # Never trust parameters from the `scary internet, only allow the white list.
  def user_params
    params.require(:user)
          .permit(:name, :email, :handle, :password, :password_confirmation)
  end
end
