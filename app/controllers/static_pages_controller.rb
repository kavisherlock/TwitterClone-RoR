class StaticPagesController < ApplicationController
  def home
    redirect_to login_path unless logged_in?
  end

  def about
  end

  def contact
  end

  def help
  end
end
