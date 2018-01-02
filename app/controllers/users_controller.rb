# Used to manage user profiles and dweeds
class UsersController < ApplicationController
  USERS_PER_PAGE = 10
  TWEATS_PER_PAGE = 20
  before_action :logged_in_user,        only: [:index, :edit, :update,
                                               :delete, :following, :followers]
  before_action :correct_user,          only: [:edit, :update]
  before_action :admin_user,            only: :destroy

  def index
    @users = User.paginate(page: params[:page], per_page: USERS_PER_PAGE)
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])
    @dweed = current_user.dweeds.build if logged_in?
    @dweeds = @user.dweeds.paginate(page: params[:page],
                                    per_page: TWEATS_PER_PAGE)
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'User not found.'
    redirect_to request.referrer || root_url
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

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = 'Profile updated.'
      redirect_to user_path
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    if current_user?(@user)
      flash[:info] = 'Can\'t delete yourself.'
    else
      @user.destroy
      flash[:success] = 'User deleted.'
    end
    redirect_to users_url
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'User not found.'
    redirect_to request.referrer || users_url
  end

  def following
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    @title = "People followed by #{@user.name}"
    @emptymessage = 'You aren\'t following anyone :('
    render 'showfollow'
  end

  def followers
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    @title = "People following #{@user.name}"
    @emptymessage = 'You have no followers :(\nTry following some people!'
    render 'showfollow'
  end

  private

  # Never trust parameters from the `scary internet, only allow the white list.
  def user_params
    params.require(:user)
          .permit(:name, :email, :handle, :password, :password_confirmation)
  end

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    unless current_user?(@user)
      flash[:info] = 'You do not have access to that page.'
      redirect_to request.referrer || root_url
    end
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'User not found.'
    redirect_to request.referrer || root_url
  end

  # Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
