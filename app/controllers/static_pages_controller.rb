# Used to manage the home page, and other static pages
class StaticPagesController < ApplicationController
  def home
    redirect_to login_path unless logged_in?
    @tweat = current_user.tweats.build if logged_in?
    @tweats = current_user.feed.paginate(page: params[:page]) if logged_in?
  end

  def about
  end

  def contact
  end

  def help
  end
end
