require 'rails_helper'

RSpec.describe DweedsController, type: :controller do
  let(:content) { 'This is not a tweet. It\'s a dweed' }
  let(:user) { FactoryGirl.build(:user) }
  let(:dweed) { user.dweeds.build(content: content) }
  let(:save_flag) {}

  describe '#create' do
    subject do
      post :create, params: { dweed: FactoryGirl.attributes_for(:dweed) }
    end

    before do
      allow(controller).to receive(:logged_in?).and_return(true)
      allow(controller).to receive(:current_user).and_return(user)
      allow_any_instance_of(Dweed).to receive(:save).and_return(save_flag)
    end

    context 'dweed is successfully created' do
      let(:save_flag) { true }

      it 'shows the flash message' do
        subject
        expect(flash[:success]).to eq('Dweed posted!')
      end

      it 'redirects the user to current path' do
        request.env['HTTP_REFERER'] = 'request_origin'
        subject
        expect(response).to redirect_to('request_origin')
      end

      it 'redirects to the dweed show users page' do
        subject
        expect(controller).to redirect_to root_url
      end
    end

    context 'dweed failed to be created' do
      let(:save_flag) { false }

      it 'shows the flash message' do
        subject
        expect(flash[:danger]).to eq('Sorry. Failed to dweed.')
      end

      it 'redirects to the root' do
        subject
        expect(controller).to redirect_to root_url
      end
    end
  end

  describe '#destroy' do
    let(:dweed) { FactoryGirl.build(:dweed) }

    subject do
      delete :destroy, params: { id: dweed.id }
    end

    before do
      allow_any_instance_of(Dweed).to receive(:destroy)
      allow(controller).to receive(:current_user).and_return(user)
      allow(user).to receive(:dweeds).and_return(user.dweeds)
      allow(user.dweeds).to receive(:find_by).and_return(dweed)
    end

    it 'shows the flash message' do
      subject
      expect(flash[:success]).to eq('Dweed deleted.')
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
