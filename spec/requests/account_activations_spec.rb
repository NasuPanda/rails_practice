require 'rails_helper'

RSpec.describe "AccountActivations", type: :request do
  describe "GET /account_activations/id/edit" do
    let(:valid_user_params) { FactoryBot.attributes_for(:user) }
    before do
      post users_path, params: { user: valid_user_params }
      @user = controller.instance_variable_get(:@user)
    end

    context "with valid token and email" do
      it "activates user" do
        get edit_account_activation_path(@user.activation_token, email: @user.email)
        @user.reload
        expect(@user).to be_activated
      end

      it "redirects to users/id" do
        get edit_account_activation_path(@user.activation_token, email: @user.email)
        expect(response).to redirect_to user_path(@user)
      end

      it "can loge in" do
        get edit_account_activation_path(@user.activation_token, email: @user.email)
        expect(logged_in?).to be_truthy
      end
    end

    context "with invalid attributes" do
      it "doesn't log in with invalid token" do
        get edit_account_activation_path("invalid_token", email: @user.email)
        expect(logged_in?).to_not be_truthy
      end

      it "doesn't log in with invalid email" do
        get edit_account_activation_path(@user.activation_token, email: "wrong email")
        expect(logged_in?).to_not be_truthy
      end
    end
  end
end
