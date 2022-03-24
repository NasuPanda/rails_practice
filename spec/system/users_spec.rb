require "rails_helper"

RSpec.describe "Users", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "POST /users" do
    context "with valid information" do
      it "has a info message" do
        valid_user_params = FactoryBot.attributes_for(:user)

        visit signup_path
        fill_in "Name", with: valid_user_params[:name]
        fill_in "Email", with: valid_user_params[:email]
        fill_in "Password", with: valid_user_params[:password]
        fill_in "Password confirmation", with: valid_user_params[:password_confirmation]
        click_button "Create my account"

        expect(page).to have_selector "div.alert-info"
      end
    end

    context "with invalid information" do
      it "has a error message" do
        visit signup_path
        fill_in "Name", with: ""
        fill_in "Email", with: "address@invalid"
        fill_in "Password", with: "short"
        fill_in "Password confirmation", with: "rack"
        click_button "Create my account"

        expect(page).to have_selector "div#error_explanation"
        expect(page).to have_selector "div.alert-danger"
      end
    end
  end

  describe "GET /users" do
    let!(:admin) { FactoryBot.create(:user) }
    let!(:non_admin_user) { FactoryBot.create(:other_user) }

    context "as a admin user" do
      it "has a link to delete" do
        log_in admin
        visit users_path

        expect(page).to have_link "delete"
      end
    end

    context "as a non-admin user" do
      it "doesn't have a link to delete" do
        log_in non_admin_user
        visit users_path

        expect(page).to_not have_link "delete"
      end

      it "doesn't display inactivated user" do
        inactivated_user = FactoryBot.create(:inactivated_user)
        log_in non_admin_user
        get users_path
        expect(response.body).to_not include inactivated_user.name
      end
    end
  end
end
