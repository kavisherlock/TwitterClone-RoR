require 'rails_helper'

RSpec.describe TweatsController, type: :controller do
  let(:content) { 'This is not a tweet. It\'s a tweat' }
  let(:user) { FactoryGirl.build(:user) }
  let(:tweat) { user.tweats.build(content: content) }
  let(:save_flag) {}

  describe '#create' do
    subject do
      post :create, params: { tweat: FactoryGirl.attributes_for(:tweat) }
    end

    before do
      allow(controller).to receive(:logged_in?).and_return(true)
      allow(controller).to receive(:current_user).and_return(user)
      allow_any_instance_of(Tweat).to receive(:save).and_return(save_flag)
    end

    context 'tweat is successfully created' do
      let(:save_flag) { true }

      it 'shows the flash message' do
        subject
        expect(flash[:success]).to eq('Tweat posted!')
      end

      it 'redirects the user to current path' do
        request.env['HTTP_REFERER'] = 'request_origin'
        subject
        expect(response).to redirect_to('request_origin')
      end

      it 'redirects to the tweat show users page' do
        subject
        expect(controller).to redirect_to root_url
      end
    end

    context 'tweat failed to be created' do
      let(:save_flag) { false }

      it 'shows the flash message' do
        subject
        expect(flash[:danger]).to eq('Sorry. Failed to tweat.')
      end

      it 'redirects to the root' do
        subject
        expect(controller).to redirect_to root_url
      end
    end
  end

  describe '#destroy' do
    let(:tweat) { FactoryGirl.build(:tweat) }

    subject do
      delete :destroy, params: { id: tweat.id }
    end

    before do
      allow_any_instance_of(Tweat).to receive(:destroy)
      allow(controller).to receive(:current_user).and_return(user)
      allow(user).to receive(:tweats).and_return(user.tweats)
      allow(user.tweats).to receive(:find_by).and_return(tweat)
    end

    it 'shows the flash message' do
      subject
      expect(flash[:success]).to eq('Tweat deleted.')
    end

    it 'redirects to origin' do
      request.env['HTTP_REFERER'] = 'request_origin'
      subject
      expect(response).to redirect_to('request_origin')
    end

    it 'redirects to root if origin not given' do
      subject
      expect(response).to redirect_to(root_url)
    end
  end
end
