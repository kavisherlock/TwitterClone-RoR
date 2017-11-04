require 'rails_helper'
include SessionsHelper

MAX_NAME_LEN = 127
MAX_EMAIL_LEN = 255
MAX_HANDLE_LEN = 15
MIN_PASSWORD_LEN = 6

RSpec.describe User, type: :model do
  let(:name) { 'Test User' }
  let(:email) { 'validemail@twitter.com' }
  let(:invalid_email) { 'invalidemail$twitter.com' }
  let(:handle) { 'TestUser' }
  let(:password) { 'Password' }
  let(:password_confirmation) { 'Password' }
  let(:remember_digest) { nil }

  let(:user) do
    User.new(
      id: 1,
      name: name,
      email: email,
      handle: handle,
      password: password,
      password_confirmation: password_confirmation,
      remember_digest: remember_digest
    )
  end

  describe 'validations' do
    subject { user }

    context 'user is valid' do
      it { is_expected.to be_valid }
    end

    context 'name cannot be nil' do
      let(:name) { nil }
      it { is_expected.to be_invalid }
    end

    context 'name cannot be more than 127 characters' do
      let(:name) { 'a' * (MAX_NAME_LEN + 1) }
      it { is_expected.to be_invalid }
    end

    context 'email cannot be nil' do
      let(:email) { nil }
      it { is_expected.to be_invalid }
    end

    context 'email cannot be invalid' do
      let(:email) { invalid_email }
      it { is_expected.to be_invalid }
    end

    context 'email cannot be more than 255 characters' do
      let(:email) { ('a' * (MAX_EMAIL_LEN - 11)) + '@twitter.com' }
      it { is_expected.to be_invalid }
    end

    context 'email is unique' do
      it do
        should validate_uniqueness_of(:email)
          .with_message('duplicate email')
          .case_insensitive
      end
    end

    context 'handle cannot be nil' do
      let(:handle) { nil }
      it { is_expected.to be_invalid }
    end

    context 'handle cannot be more than 15 characters' do
      let(:handle) { 'a' * (MAX_HANDLE_LEN + 1) }
      it { is_expected.to be_invalid }
    end

    context 'handle is unique' do
      it do
        should validate_uniqueness_of(:handle)
          .with_message('duplicate handle')
          .case_insensitive
      end
    end

    context 'password cannot be nil' do
      let(:password) { nil }
      it { is_expected.to be_invalid }
    end

    context 'password must be equal to password_confirmation' do
      let(:password_confirmation) { 'NotPassword' }
      it { is_expected.to be_invalid }
    end

    context 'password cannot be less than six characters' do
      let(:password) { 'a' * (MIN_PASSWORD_LEN - 1) }
      let(:password_confirmation) { 'a' * (MIN_PASSWORD_LEN - 1) }
      it { is_expected.to be_invalid }
    end
  end

  describe '#self.digest' do
    context 'Returns a valid hash digest for given string' do
      it 'min cost is not nil' do
        expect(User.digest('string')).to_not be_nil
      end

      it 'min cost is nil' do
        allow(ActiveModel::SecurePassword).to receive(:min_cost).and_return(nil)
        expect(User.digest('string')).to_not be_nil
      end
    end
  end

  describe '#self.new_token' do
    context 'Returns a valid random token' do
      it do
        expect(User.new_token).to_not be_nil
      end
    end
  end

  describe '#remember' do
    context 'Remember a user correctly' do
      let(:remember_token) { 'remember token' }
      let(:new_remember_digest) { 'remember digest' }

      before do
        allow(User).to receive(:new_token).and_return(remember_token)
        allow(User).to receive(:digest)
          .with(remember_token)
          .and_return(new_remember_digest)
      end

      it do
        user.remember
        expect(user.remember_digest).to eq(new_remember_digest)
      end
    end
  end

  describe '#authenticated?' do
    let(:remember_digest) { 'remember digest' }

    before do
      allow_any_instance_of(User).to receive(:logged_in?).and_return(false)
      allow(BCrypt::Password).to receive(:new)
        .and_return(BCrypt::Password.create(remember_digest))
    end

    it 'User is authenticated' do
      expect(user.authenticated?(remember_digest)).to be true
    end

    it 'User is not authenticated' do
      expect(user.authenticated?('invalid')).to be false
    end
  end

  describe '#forget' do
    context 'Remember a user correctly' do
      let(:remember_digest) { 'remember digest' }

      it do
        expect(user.remember_digest).to eq(remember_digest)
        user.forget
        expect(user.remember_digest).to be_nil
      end
    end
  end

  describe 'dependent destroy' do
    context 'user gets destoryed' do
      let(:user) { FactoryGirl.create(:user) }
      let(:tweat) { user.tweats.build(content: 'content') }

      it 'tweat gets destroyed with user' do
        expect { user.destroy.to change { Tweat.count }.by(-1) }
      end
    end
  end
end
