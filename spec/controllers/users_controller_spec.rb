require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:id) { 1 }
  let(:name) { 'Test User' }
  let(:email) { 'validemail@dwidder.com' }
  let(:handle) { 'TestUser' }
  let(:password) { 'Password' }
  let(:password_confirmation) { 'Password' }
  let(:admin) { false }

  let(:user) do
    User.new(
      id: id,
      name: name,
      email: email,
      handle: handle,
      password: password,
      password_confirmation: password_confirmation,
      admin: admin
    )
  end

  describe '#index' do
    let(:user1) { FactoryGirl.build(:user) }
    let(:user2) { FactoryGirl.build(:user) }
    let(:user_array) { [user1, user2] }
    let(:page) { 1 }

    before do
      allow(controller).to receive(:logged_in?).and_return(true)
      allow(User).to receive(:paginate).and_return(user_array)
      get :index, params: { page: page }
    end

    context 'Index page' do
      it 'has http status ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'ensures that users list is received' do
        expect(assigns(:users)).to eq(user_array)
      end

      it 'renders the show_users view' do
        expect(response).to render_template(:index)
      end
    end
  end

  describe '#show' do
    subject { get :show, params: { id: user.id } }

    context 'user is found' do
      before do
        allow(User).to receive(:find).with(user.id.to_s).and_return(user)
        subject
      end

      it 'gets the user with the associated id' do
        expect(assigns(:user)).to eq(user)
      end

      it 'redirect to user profile page' do
        expect(response).to render_template(:show)
      end
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

      it 'redirects to the user\'s page' do
        subject
        expect(controller).to redirect_to user
      end
    end

    context 'user failed to be created' do
      let(:save_flag) { false }

      it 'does not redirect to the user\'s page' do
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

  describe '#edit' do
    subject { get :edit, params: { id: user.id } }

    before do
      allow(controller).to receive(:logged_in?).and_return(true)
      allow(controller).to receive(:current_user?).and_return(true)
      allow(controller).to receive(:current_user).and_return(user)
    end

    context 'user not logged in' do
      before do
        allow(controller).to receive(:logged_in?).and_return(false)
      end

      it 'shows the flash message' do
        subject
        expect(flash[:danger]).to eq('Please log in.')
      end
    end

    context 'user not found' do
      before do
        allow(User).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
      end

      it 'shows the flash message' do
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

    context 'user exists' do
      before do
        allow(User).to receive(:find).with(user.id.to_s).and_return(user)
        allow(controller).to receive(:logged_in?).and_return(true)
      end

      context 'current user does not have access' do
        before do
          allow(controller).to receive(:current_user?).and_return(false)
        end

        it 'shows the flash message' do
          subject
          expect(flash[:info]).to eq('You do not have access to that page.')
        end

        it 'redirects the user to root' do
          subject
          expect(response).to redirect_to(root_url)
        end
      end

      context 'user has access' do
        before do
          allow(controller).to receive(:current_user?).and_return(true)
        end

        it 'assigns the correct user' do
          subject
          expect(assigns(:user).id).to eq(user.id)
        end
      end
    end
  end

  describe '#update' do
    let(:attrs) { FactoryGirl.attributes_for(:user) }
    let(:user) { User.new(attrs) }
    subject { put :update, params: { id: user.id } }

    before do
      allow(User).to receive(:find).and_return(user)
      allow(controller).to receive(:current_user).and_return(user)
      allow(controller).to receive(:logged_in?).and_return(true)
      allow(controller).to receive(:current_user?).and_return(true)
      allow(controller).to receive(:user_params).and_return(attrs)
    end

    context 'successful update' do
      before do
        allow_any_instance_of(User).to receive(:update_attributes)
          .and_return(true)
        subject
      end

      it 'shows the flash message' do
        expect(flash[:success]).to eq('Profile updated.')
      end

      it 'redirects to the profile page' do
        expect(controller).to redirect_to user_path
      end
    end

    context 'failed update' do
      before do
        allow(user).to receive(:update_attributes).and_return(false)
        subject
      end

      it 'renders the edit user view' do
        expect(response).to render_template(:edit)
      end
    end
  end

  describe '#destroy' do
    subject { delete :destroy, params: { id: user.id } }

    before do
      allow(controller).to receive(:current_user).and_return(user)
    end

    context 'user not found' do
      let(:admin) { true }

      before do
        allow(User).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
      end

      it 'shows the flash message' do
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
        expect(response).to redirect_to(users_path)
        expect(response).to_not have_http_status(:ok)
      end
    end

    context 'user found' do
      before do
        allow(User).to receive(:find).and_return(user)
        allow(user).to receive(:destroy)
      end

      context 'current user has access' do
        let(:admin) { true }

        before do
          allow(controller).to receive(:current_user?).and_return(false)
        end

        it 'should show a flash message' do
          subject
          expect(flash[:success]).to eq('User deleted.')
        end

        it 'redirects to user index' do
          subject
          expect(response).to redirect_to users_path
        end
      end

      context 'current user does not have access' do
        let(:admin) { false }

        it 'redirects the user to root' do
          subject
          expect(response).to redirect_to(root_url)
        end
      end

      context 'current user deleting itself' do
        let(:admin) { true }

        before do
          allow(controller).to receive(:current_user?).and_return(true)
        end

        it 'should show a flash message' do
          subject
          expect(flash[:info]).to eq('Can\'t delete yourself.')
        end

        it 'redirects to user index' do
          subject
          expect(response).to redirect_to users_path
        end
      end
    end
  end

  describe '#following' do
    let(:page) { 1 }

    before do
      allow(controller).to receive(:logged_in?).and_return(true)
      allow(User).to receive(:find).and_return(user)
      get :following, params: { id: id, page: page }
    end

    context 'Following page' do
      it 'has http status ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'ensures that title is correct' do
        expect(assigns(:title)).to eq("People followed by #{user.name}")
      end

      it 'ensures that message displayed is correct' do
        expect(assigns(:emptymessage)).to eq('You aren\'t following anyone :(')
      end

      it 'renders the showfollow view' do
        expect(response).to render_template(:showfollow)
      end
    end
  end

  describe '#followers' do
    let(:page) { 1 }

    before do
      allow(controller).to receive(:logged_in?).and_return(true)
      allow(User).to receive(:find).and_return(user)
      get :followers, params: { id: id, page: page }
    end

    context 'Followers page' do
      it 'has http status ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'ensures that title is correct' do
        expect(assigns(:title)).to eq("People following #{user.name}")
      end

      it 'ensures that message displayed is correct' do
        expect(assigns(:emptymessage))
          .to eq('You have no followers :(\nTry following some people!')
      end

      it 'renders the showfollow view' do
        expect(response).to render_template(:showfollow)
      end
    end
  end
end
