require 'rails_helper'

RSpec.describe "Sessions", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "#create" do

    context "with valid information" do
      let(:user) { FactoryBot.create(:user) }

      it "hasn't a link to login and has a link to logout, user/id" do
        visit login_path
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password
        click_button "Log in"

        expect(page).to_not have_link "Log in", href: login_path
        expect(page).to have_link "Log out", href: logout_path
        expect(page).to have_link "Profile", href: user_path(user)
      end
    end

    context "with invalid information" do
      it "has a error flash" do
        visit login_path
        fill_in "Email", with: ""
        fill_in "Password", with: ""
        click_button "Log in"

        # flashが表示されているかテスト
        expect(page).to have_selector "div.alert.alert-danger"
        # flashが残っていないかテスト
        visit root_path
        expect(page).to_not have_selector 'div.alert.alert-danger'
      end
    end

  end
end
