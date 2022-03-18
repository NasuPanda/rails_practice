require 'rails_helper'

RSpec.describe User, type: :model do
  let (:user) { FactoryBot.create(:user) }

  # 有効なユーザーのテスト
  context "with valid attributes" do

    it "is valid with name and email" do
      expect(user).to be_valid
    end

    it "is valid with valid format emails" do
      valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
        first.last@foo.jp alice+bob@baz.cn]
      valid_addresses.each do |valid_address|
        user.email = valid_address
        expect(user).to be_valid
      end
    end

  end

  # 無効なユーザーのテスト
  context "with invalid attributes" do

    it "is invalid without a name" do
      user.name = ""
      expect(user).to_not be_valid
    end

    it "is invalid witout a email" do
      user.email = ""
      expect(user).to_not be_valid
    end

    it "is invalid with a too long name" do
      user.name = "a" * 51
      expect(user).to_not be_valid
    end

    it "is invalid with a too long email" do
      user.email = "a" * 244 + "@example.com"
      expect(user).to_not be_valid
    end

    it "is invalid with invalid format emails" do
      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
        foo@bar_baz.com foo@bar+baz.com, foo@bar..com]
      invalid_addresses.each do |invalid_address|
        user.email = invalid_address
        expect(user).to_not be_valid
      end
    end

  end
end
