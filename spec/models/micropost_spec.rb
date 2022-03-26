require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:micropost) { Micropost.new(content: "Test post", user_id: user.id) }

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

    it "is invalid without content" do
      micropost.content = ""
      expect(micropost).to_not be_valid
    end

    it "is invalid with a too long content" do
      micropost.content = "a" * 141
      expect(micropost).to_not be_valid
    end
  end
end
