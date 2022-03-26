require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe "#new" do
    it "responds successfully" do
      get login_path
      expect(response).to have_http_status :ok
    end
  end

  describe "#destroy" do
    it "can log out" do
      # ログイン
      get login_path
      post login_path params: { session: { email: user.email,
                                          password: user.password } }
      expect(is_logged_in?).to be_truthy

      # ログアウト
      delete logout_path
      expect(is_logged_in?).to_not be_truthy
    end

    it "can log out in a row" do
      # ログイン
      get login_path
      post login_path params: { session: { email: user.email,
                                          password: user.password } }
      expect(is_logged_in?).to be_truthy

      # 連続ログアウト出来る
      delete logout_path
      delete logout_path
      expect(response).to redirect_to root_path
    end
  end

  describe "remember me" do
    context "login with remember" do
      it "stores the remember token in cookies" do
        post login_path, params: { session: { email: user.email,
                                              password: user.password,
                                              remember_me: "1" }}
        expect(cookies[:remember_token]).to_not be_blank
      end
    end

    context "login without the remember" do
      it "doesn't store the remember token in cookies" do
        post login_path, params: { session: { email: user.email,
                                              password: user.password,
                                              remember_me: "0" } }
        expect(cookies[:remember_token]).to be_blank
      end
    end
  end
end
