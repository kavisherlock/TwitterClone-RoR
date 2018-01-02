require 'rails_helper'

MAX_TWEAT_LEN = 140

RSpec.describe Dweed, type: :model do
  let(:content) { 'This is not a tweet. It\'s a dweed' }
  let(:user) { FactoryGirl.build(:user) }
  let(:dweed) { user.dweeds.build(content: content) }

  describe 'validations' do
    subject { dweed }

    context 'dweed is valid' do
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
        dweed.user_id = nil
        is_expected.to be_invalid
      end
    end
  end
end
