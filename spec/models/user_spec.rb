require 'rails_helper'

RSpec.describe User, type: :model do
  let (:user) { FactoryBot.build(:user) }

  it "saves an email as lower case" do
    mixed_case_email = "Foo@ExAmPle.coM"
    user.email = mixed_case_email
    user.save
    expect(mixed_case_email.downcase).to eq user.reload.email
  end

  # 有効なユーザーのテスト
  context "with valid attributes" do

    it "is valid with a name, email and password" do
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

    it "is invalid witout an email" do
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

    it "is invalid with a duplicate email" do
      duplicate_user = user.dup
      duplicate_user.email = user.email.upcase
      user.save
      expect(duplicate_user).to_not be_valid
    end

    it "is invalid without a password" do
      user.password = user.password_confirmation = "" * 6
      expect(user).not_to be_valid
    end

    it "is invalid with a too short password" do
      user.password = user.password_confirmation = "abcde"
      expect(user).not_to be_valid
    end

  end
end
