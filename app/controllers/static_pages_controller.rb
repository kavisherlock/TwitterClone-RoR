# Used to manage the home page, and other static pages
class StaticPagesController < ApplicationController
  def home
    redirect_to login_path unless logged_in?
    @dweed = current_user.dweeds.build if logged_in?
    @dweeds = current_user.feed.paginate(page: params[:page]) if logged_in?
  end

  def about
  end

  def contact
  end

  def help
  end
end
