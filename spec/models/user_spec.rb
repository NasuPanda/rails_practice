require 'rails_helper'

RSpec.describe User, type: :model do
  let (:user) { FactoryBot.create(:user) }

  context "with valid attributes"
    it "is valid with name and email" do
      expect(user).to be_valid
    end

  context "with invalid attributes"
    it "is invalid without a name" do
      user.name = ""
      expect(user).to_not be_valid
    end

    it "is invalid witout a email" do
      user.email = ""
      expect(user).to_not be_valid
    end

    it "is invalid with too long name" do
      user.name = "a" * 51
      expect(user).to_not be_valid
    end

    it "is invalid with too long email" do
      user.email = "a" * 244 + "@example.com"
      expect(user).to_not be_valid
    end
end
