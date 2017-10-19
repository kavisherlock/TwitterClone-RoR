require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  let(:user) { FactoryGirl.build(:user) }
  describe('#home') do
    before do
      allow(controller).to receive(:current_user).and_return(user)
    end

    it 'does not redirect to home on failed login' do
      allow(controller).to receive(:logged_in?).and_return(false)
      get :home
      expect(controller).to_not redirect_to home_path
      expect(controller).to redirect_to login_path
    end
  end
end
