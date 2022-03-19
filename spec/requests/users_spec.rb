require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "#new" do
    it "responds successfully" do
      get signup_path
      expect(response).to have_http_status :ok
    end

    it "have a correct title" do
      get signup_path
      expect(response.body).to include full_title("Sign up")
    end
  end

  describe "#create" do
    let(:valid_user_params) { FactoryBot.attributes_for(:user) }

    context "with valid information" do
      it "creates a user" do
        get signup_path
        expect{
          post users_path, params: { user: valid_user_params }
        }.to change(User, :count).by 1
      end

      it "redirects to users/id" do
        post users_path, params: { user: valid_user_params }
        created_user = User.last
        expect(response).to redirect_to created_user
      end
    end

    context "with invalid information" do
      it "doesn't create a user" do
        get signup_path
        expect{
          post users_path, params: { user: { name: "",
                                      email: "address@invalid",
                                      password: "short",
                                      password_confirmtaion: "rack" }}
        }.to_not change(User, :count)
      end


    end

  end

end