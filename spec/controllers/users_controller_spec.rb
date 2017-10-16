require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:id) { 1 }
  let(:name) { 'Test User' }
  let(:email) { 'validemail@twitter.com' }
  let(:handle) { 'TestUser' }
  let(:password) { 'Password' }
  let(:password_confirmation) { 'Password' }

  let(:user) do
    User.new(
      id: id,
      name: name,
      email: email,
      handle: handle,
      password: password,
      password_confirmation: password_confirmation
    )
  end

  describe '#show' do
    subject { get :show, params: { id: user.id } }

    before do
      allow(User).to receive(:find).with(user.id.to_s).and_return(user)
    end

    it 'gets the user with the associated id' do
      subject
      expect(assigns(:user)).to eq(user)
    end

    it 'redirect to user profile page' do
      subject
      expect(response).to render_template(:show)
    end

    context 'user is not found' do
      before do
        allow(User).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
      end

      it 'shows the flash danger method' do
        subject
        expect(flash[:danger]).to eq('User not found.')
      end

      it 'redirects the user to current path' do
        request.env['HTTP_REFERER'] = 'request_origin'
        subject
        expect(response).to redirect_to('request_origin')
      end

      it 'redirects the user to fallback path' do
        subject
        expect(response).to redirect_to(root_url)
        expect(response).to_not have_http_status(:ok)
      end
    end
  end

  describe '#create' do
    subject do
      post :create, params: { user: FactoryGirl.attributes_for(:user) }
    end

    let(:save_flag) {}

    before do
      allow(User).to receive(:create).and_return(user)
      allow_any_instance_of(User).to receive(:save).and_return(save_flag)
    end

    context 'user is successfully created' do
      let(:save_flag) { true }

      it 'redirects to the user show users page' do
        subject
        expect(controller).to redirect_to user
      end
    end

    context 'user failed to be created' do
      let(:save_flag) { false }

      it 'redirects to the user show users page' do
        subject
        expect(controller).to_not redirect_to user
      end
    end
  end

  describe '#new' do
    before do
      get :new
    end

    it 'expects response to have http status ok' do
      expect(response).to have_http_status(:ok)
    end
  end
end
