require 'rails_helper'

RSpec.describe "Layouts", type: :system do
  before do
    driven_by(:rack_test)
  end
  let(:user) { FactoryBot.create(:user) }

  describe "header" do
    context "as a logged in user" do
      before do
        log_in user
        visit root_path
      end

      describe "Account" do
        before do
          click_link "Account"
        end

        it "click the Profile to move to user's profile" do
          click_link 'Profile'
          expect(page).to have_current_path user_path(user)
        end

        it "click the Sessings to move to user's setting" do
          click_link 'Settings'
          expect(page).to have_current_path edit_user_path(user)
        end

        it "click the Log out to move to log out" do
          click_link 'Log out'
          expect(page).to have_current_path root_path
        end
      end

      it "click the sample app to move to root" do
        # rootに遷移することを確認したいのでhelpに移動する
        click_link "Help"
        click_link "sample app"
        expect(page).to have_current_path root_path
      end

      it "click the Home to move to root" do
        # rootに遷移することを確認したいのでhelpに移動する
        click_link "Help"
        click_link "Home"
        expect(page).to have_current_path root_path
      end

      it "click the Help to move to help" do
        click_link "Help"
        expect(page).to have_current_path help_path
      end
    end

    context "as a non logged in user" do
      before do
        visit root_path
      end

      it "click the Log in to move to log in" do
        click_link 'Log in'
        expect(page).to have_current_path login_path
      end

      it "click the sample app to move to root" do
        # rootに遷移することを確認したいのでhelpに移動する
        click_link "Help"
        click_link "sample app"
        expect(page).to have_current_path root_path
      end

      it "click the Home to move to root" do
        # rootに遷移することを確認したいのでhelpに移動する
        click_link "Help"
        click_link "Home"
        expect(page).to have_current_path root_path
      end

      it "click the Help to move to help" do
        click_link "Help"
        expect(page).to have_current_path help_path
      end
    end
  end

  describe "footer" do
    context "as a logged in user" do
      before do
        log_in user
        visit root_path
      end

      it "click the About to move to about" do
        click_link "About"
        expect(page).to have_current_path about_path
      end

      it "click the Contact to move to contact" do
        click_link "Contact"
        expect(page).to have_current_path contact_path
      end
    end

    context "as a non logged in user" do
      before do
        visit root_path
      end

      it "click the About to move to about" do
        click_link "About"
        expect(page).to have_current_path about_path
      end

      it "click the Contact to move to contact" do
        click_link "Contact"
        expect(page).to have_current_path contact_path
      end
    end
  end
end
