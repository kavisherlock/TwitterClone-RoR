require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  let(:user) { FactoryGirl.build(:user) }
  let(:user2) { FactoryGirl.build(:user2) }

  describe('#log_in') do
    context 'session id for user is saved' do
      it do
        log_in user
        expect(session[:user_id]).to eq(user.id)
      end
    end
  end

  describe('#remember') do
    context 'cookies for user are saved' do
      let(:remember_token) { 'remember token' }
      before do
        allow_any_instance_of(User).to receive(:remember)
        allow_any_instance_of(User).to receive(:remember_token)
          .and_return(remember_token)
        remember user
      end

      it 'calls the user remember method' do
        expect(user).to have_received(:remember)
      end

      it 'saves the cookies appropriately' do
        expect(cookies.permanent.signed[:user_id]).to eq(user.id)
        expect(cookies.permanent[:remember_token]).to eq(user.remember_token)
      end
    end
  end

  describe('#current_user') do
    before do
      allow(User).to receive(:find_by).and_return(user)
    end

    context 'user is logged into the session' do
      it 'saves the current user correctly' do
        session[:user_id] = user.id
        expect(current_user).to eq(user)
      end
    end

    context 'user is saved in the cookies' do
      before do
        session[:user_id] = nil
        cookies.signed[:user_id] = user.id
      end

      context 'user is authenticated' do
        before do
          allow_any_instance_of(User).to receive(:authenticated?)
            .and_return(true)
          allow(helper).to receive(:log_in)
          current_user
        end

        it 'calls the log_in method' do
          expect(session[:user_id]).to eq(user.id)
        end

        it 'saves the current user correctly' do
          expect(current_user).to eq(user)
        end
      end

      context 'user is not authenticated' do
        before do
          allow_any_instance_of(User).to receive(:authenticated?)
            .and_return(false)
          current_user
        end

        it 'current user stays nil' do
          expect(current_user).to eq(nil)
        end
      end
    end
  end

  describe('#current_user?') do
    context 'user is the current user' do
      let(:current_user) { user }

      it 'returns true' do
        expect(current_user?(user)).to be true
      end
    end

    context 'user is not the current user' do
      let(:current_user) { user2 }

      it 'returns false' do
        expect(current_user?(user)).to be false
      end
    end
  end

  describe('#logged_in?') do
    context 'user is logged in' do
      let(:current_user) { user }

      it 'returns true' do
        expect(logged_in?).to be true
      end
    end

    context 'user is not logged in' do
      let(:current_user) { nil }

      it 'returns false' do
        expect(logged_in?).to be false
      end
    end
  end

  describe('#forget') do
    context 'cookies for user are saved' do
      before do
        allow_any_instance_of(User).to receive(:forget)
        forget user
      end

      it 'calls the user forget method' do
        expect(user).to have_received(:forget)
      end

      it 'deletes the cookies appropriately' do
        expect(cookies).to_not have_key(:user_id)
        expect(cookies).to_not have_key(:remember_token)
      end
    end
  end

  describe('#log_out') do
    let(:current_user) { user }

    context 'user logs out' do
      before do
        allow(helper).to receive(:forget)
        log_out
      end

      it 'session id for user is deleted' do
        expect(session).to_not have_key(:user_id)
      end

      it 'current user becomes nil' do
        expect(helper.current_user).to eq(nil)
      end
    end
  end
end
