require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "#new" do
    it "responds successfully" do
      get signup_path
      expect(response).to have_http_status :ok
    end

    it "has a correct title" do
      get signup_path
      expect(response.body).to include full_title("Sign up")
    end
  end

  describe "#create" do
    let(:user) { FactoryBot.create(:user) }
    let(:valid_user_params) { FactoryBot.attributes_for(:user) }
    let(:invalid_user_params) { FactoryBot.attributes_for(:invalid_user) }

    context "with valid information" do
      it "creates a user" do
        # get signup_path
        expect{
          post users_path, params: { user: valid_user_params }
        }.to change(User, :count).by 1
      end

      it "redirects to users/id" do
        post users_path, params: { user: valid_user_params }
        created_user = User.last
        expect(response).to redirect_to created_user
      end

      it "is logged in" do
        post users_path, params: { user: valid_user_params }
        expect(is_logged_in?).to be_truthy
      end
    end

    context "with invalid information" do
      it "doesn't create a user" do
        get signup_path
        expect{
          post users_path, params: { user: invalid_user_params }
        }.to_not change(User, :count)
      end
    end
  end

  describe "#update" do
    let(:user) { FactoryBot.create(:user) }

    context "with valid information" do
      before do
        @another_user_params = { name: "Another name",
          email: "another@gmail.com",
          password: "",
          password_confirmation: "" }
      end

      it "edits a user" do
        patch user_path(user), params: { user: @another_user_params }
        user.reload
        expect(user.name).to eq @another_user_params[:name]
        expect(user.email).to eq @another_user_params[:email]
      end

      it "redirects to users/id" do
        patch user_path(user), params: { user: @another_user_params }
        expect(response).to redirect_to user
      end

      it "has a flash" do
        patch user_path(user), params: { user: @another_user_params }
        expect(flash).to be_any
      end
    end

    context "with invalid information" do
      let(:invalid_user_params) { FactoryBot.attributes_for(:invalid_user) }
      it "doesn't edit a user" do
        patch user_path(user), params: { user: invalid_user_params }
        user.reload
        expect(user.name).to_not eq invalid_user_params[:name]
        expect(user.email).to_not eq invalid_user_params[:email]
        expect(user.password).to_not eq invalid_user_params[:password]
        expect(user.password_confirmation).to_not eq invalid_user_params[:password_confirmation]
      end

      it "redirects to edit page" do
        patch user_path(user), params: { user: invalid_user_params }
        expect(response.body).to include full_title("Edit user")
      end

      it "has correct error messages of 'The form contains 3 errors'" do
        patch user_path(user), params: { user: invalid_user_params }
        expect(response.body).to include "The form contains 3 errors"
      end
    end
  end

end