require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { FactoryGirl.build(:user) }

  describe '#create' do
    let(:remember_me) { '1' }

    subject do
      post :create, params: { session: {
        email: user.email,
        remember_me: remember_me
      } }
    end

    before do
      allow(User).to receive(:find_by).and_return(user)
    end

    context 'user is authenticated' do
      before do
        allow_any_instance_of(User).to receive(:authenticate).and_return(true)
        allow(controller).to receive(:log_in)
        allow(controller).to receive(:remember)
        allow(controller).to receive(:forget)
        subject
      end

      it 'displays the success flash' do
        expect(flash[:success]).to eq('Welcome ' + user.name + '!!')
      end

      context 'remember me is true' do
        let(:remember_me) { '1' }

        it 'calls the remember function' do
          expect(controller).to have_received(:remember).with(user)
        end
      end

      context 'remember me is false' do
        let(:remember_me) { '0' }

        it 'calls the forget function' do
          expect(controller).to have_received(:forget).with(user)
        end
      end

      it 'redirects to user on login' do
        expect(controller).to redirect_to home_path
      end
    end

    context 'user is not authenticated' do
      before do
        allow_any_instance_of(User).to receive(:authenticate).and_return(false)
        subject
      end

      it 'displays the danger flash' do
        expect(flash[:danger]).to eq('Invalid email/password combination')
      end

      it 'renders a new session' do
        expect(controller).to render_template(:new)
      end
    end
  end

  describe('#destroy') do
    subject { delete :destroy }

    context 'user is logged in' do
      before do
        allow(controller).to receive(:logged_in?).and_return(true)
        allow(controller).to receive(:log_out)
        subject
      end

      it 'calls the log out method' do
        expect(controller).to have_received(:log_out)
      end

      it 'redirects to root url' do
        expect(controller).to redirect_to root_url
      end
    end

    context 'user is not logged in' do
      before do
        allow(controller).to receive(:logged_in?).and_return(false)
        subject
      end

      it 'redirects to root url' do
        expect(controller).to redirect_to root_url
      end
    end
  end
end
