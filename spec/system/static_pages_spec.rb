require "rails_helper"

RSpec.describe "StaticPages", type: :system do
  before do
    # jsドライバは不要なのでrack_testを使用
    driven_by(:rack_test)
  end

  describe "root" do
    it "has two links to root and a link to help, about, contact" do
      visit root_path
      links_to_root = page.find_all("a[href=\"#{root_path}\"]")

      expect(links_to_root.length).to eq 2
      expect(page).to have_link "Help" , href: help_path
      expect(page).to have_link "About" , href: about_path
      expect(page).to have_link "Contact" , href: contact_path
    end

    describe "following and followers" do
      let(:user_with_relationships) { FactoryBot.create(:user, :with_relationships) }
      let(:following) { user_with_relationships.following.count }
      let(:followers) { user_with_relationships.followers.count }

      it "displays statistics for following and followers" do
        log_in user_with_relationships
        expect(page).to have_content("#{following} following")
        expect(page).to have_content("#{followers} followers")
      end
    end
  end
end