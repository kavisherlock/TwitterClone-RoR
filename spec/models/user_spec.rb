require 'rails_helper'

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

  let(:user) do
    User.new(
      id: 1,
      name: name,
      email: email,
      handle: handle,
      password: password,
      password_confirmation: password_confirmation
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
end
