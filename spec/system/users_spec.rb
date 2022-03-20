require "rails_helper"

RSpec.describe "Users", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "#create" do
    context "with valid information" do
      it "has a success message" do
        valid_user_params = FactoryBot.attributes_for(:user)

        visit signup_path
        fill_in "Name", with: valid_user_params[:name]
        fill_in "Email", with: valid_user_params[:email]
        fill_in "Password", with: valid_user_params[:password]
        fill_in "Confirmation", with: valid_user_params[:password_confirmation]
        click_button "Create my account"

        expect(page).to have_selector "div.alert-success"
      end
    end

    context "with invalid information" do
      it "has a error message" do
        visit signup_path
        fill_in "Name", with: ""
        fill_in "Email", with: "address@invalid"
        fill_in "Password", with: "short"
        fill_in "Confirmation", with: "rack"
        click_button "Create my account"

        expect(page).to have_selector "div#error_explanation"
        expect(page).to have_selector "div.alert-danger"
      end
    end
  end
end
