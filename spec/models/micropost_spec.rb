require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:micropost) { FactoryBot.create(:micropost) }

  it "is sorted by newest to oldest" do
    # プライベートメソッドの呼び出し
    FactoryBot.send(:create_posts_different_posting_time)
    expect(FactoryBot.create(:micropost, :most_recent)).to eq Micropost.first
  end

  describe "association" do
    it "is destroyed when the associated user is destroyed" do
      user = micropost.user
      expect {
        user.destroy
      }.to change(Micropost, :count).by -1
    end
  end

  describe "validation" do
    context "with valid attributes" do
      it "is valid" do
        expect(micropost).to be_valid
      end

      it "is valid with content equal to the boundary value" do
        micropost.content = "a" * 140
        expect(micropost).to be_valid
      end
    end

    context "with invalid attributes" do
      it "is invalid without user_id" do
        micropost.user_id = nil
        expect(micropost).to_not be_valid
      end

      it "is invalid without a content" do
        micropost.content = ""
        expect(micropost).to_not be_valid
      end

      it "is invalid with a too long content" do
        micropost.content = "a" * 141
        expect(micropost).to_not be_valid
      end
    end
  end
end
