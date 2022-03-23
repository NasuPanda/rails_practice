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
        fill_in "Password confirmation", with: valid_user_params[:password_confirmation]
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
        fill_in "Password confirmation", with: "rack"
        click_button "Create my account"

        expect(page).to have_selector "div#error_explanation"
        expect(page).to have_selector "div.alert-danger"
      end
    end
  end

  describe '#index' do
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
    end
  end
end
