require 'rails_helper'

MAX_TWEAT_LEN = 140

RSpec.describe Tweat, type: :model do
  let(:content) { 'This is not a tweet. It\'s a tweat' }
  let(:user) { FactoryGirl.build(:user) }
  let(:tweat) { user.tweats.build(content: content) }

  describe 'validations' do
    subject { tweat }

    context 'tweat is valid' do
      it { is_expected.to be_valid }
    end

    context 'content cannot be nil' do
      let(:content) { nil }

      it { is_expected.to be_invalid }
    end

    context 'content cannot be more than 140 characters' do
      let(:content) { 'a' * (MAX_TWEAT_LEN + 1) }
      it { is_expected.to be_invalid }
    end

    context 'user id cannot be nil' do
      it do
        tweat.user_id = nil
        is_expected.to be_invalid
      end
    end
  end
end
