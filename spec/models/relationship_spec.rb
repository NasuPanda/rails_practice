require 'rails_helper'

RSpec.describe Relationship, type: :model do
  describe "validation" do
    let(:relationship) { FactoryBot.create(:relationship) }
    subject { relationship }

    context "with valid attributes" do
      it { is_expected.to be_valid}
    end

    context "with invalid attributes" do
      it "is invalid without a follower_id" do
        relationship.follower_id = nil
        expect(relationship).to_not be_valid
      end

      it "is invalid without a followed_id" do
        relationship.followed_id = nil
        expect(relationship).to_not be_valid
      end
    end
  end

end
