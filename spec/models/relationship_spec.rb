require 'rails_helper'
include SessionsHelper

RSpec.describe Relationship, type: :model do
  let(:follower_id) { 1 }
  let(:follower) { FactoryGirl.create(:user) }

  let(:followee_id) { 2 }
  let(:followee) { FactoryGirl.create(:user2) }

  let(:relationship) do
    Relationship.new(
      id: 1,
      follower: follower,
      followee: followee,
      follower_id: follower_id,
      followee_id: followee_id
    )
  end

  describe 'validations' do
    subject { relationship }

    context 'relationship is valid' do
      it { is_expected.to be_valid }
    end

    context 'follower_id cannot be nil' do
      let(:follower_id) { nil }
      it { is_expected.to be_invalid }
    end

    context 'follower cannot be nil' do
      let(:follower) { nil }
      it { is_expected.to be_invalid }
    end

    context 'followee_id cannot be nil' do
      let(:follower_id) { nil }
      it { is_expected.to be_invalid }
    end

    context 'followee cannot be nil' do
      let(:followee) { nil }
      it { is_expected.to be_invalid }
    end
  end
end
