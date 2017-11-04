#
class TweatsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  # POST /tweats
  def create
    @tweat = current_user.tweats.build(tweat_params)
    if @tweat.save
      flash[:success] = 'Tweat posted!'
      redirect_to request.referrer || root_url
    else
      flash[:danger] = 'Sorry. Failed to tweat.'
      redirect_to root_url
    end
  end

  # DELETE /tweats/1
  def destroy
    @tweat.destroy
    flash[:success] = 'Tweat deleted.'
    redirect_to request.referrer || root_url
  end

  private

  def tweat_params
    params.require(:tweat).permit(:content)
  end

  def correct_user
    if current_user
      @tweat = current_user.tweats.find_by(id: params[:id])
      redirect_to root_url if @tweat.nil?
    end
  end
end
