# Used to create and destroy dweeds posted by the user
class DweedsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  # POST /dweeds
  def create
    @dweed = current_user.dweeds.build(dweed_params)
    if @dweed.save
      flash[:success] = 'Dweed posted!'
      redirect_to request.referrer || root_url
    else
      flash[:danger] = 'Sorry. Failed to dweed.'
      redirect_to root_url
    end
  end

  # DELETE /dweeds/1
  def destroy
    @dweed.destroy
    flash[:success] = 'Dweed deleted.'
    redirect_to request.referrer || root_url
  end

  private

  # Never trust parameters from the `scary internet, only allow the white list.
  def dweed_params
    params.require(:dweed).permit(:content)
  end

  # Confirms the correct user.
  def correct_user
    if current_user
      @dweed = current_user.dweeds.find_by(id: params[:id])
      redirect_to root_url if @dweed.nil?
    end
  end
end
