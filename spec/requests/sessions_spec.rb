require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "#new" do
    it "responds successfully" do
      get login_path
      expect(response).to have_http_status :ok
    end
  end

  describe "#destroy" do
    it "can log out" do
      user = FactoryBot.create(:user)

      # ログイン
      get login_path
      post login_path params: { session: { email: user.email,
                                          password: user.password } }
      expect(is_logged_in?).to be_truthy

      # ログアウト
      delete logout_path
      expect(is_logged_in?).to_not be_truthy
    end
  end
end
