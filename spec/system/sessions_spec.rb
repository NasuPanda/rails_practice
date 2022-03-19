require 'rails_helper'

RSpec.describe "Sessions", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "#create" do
    scenario "user login with invalid information" do
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
