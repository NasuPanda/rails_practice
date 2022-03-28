require "rails_helper"

RSpec.describe "StaticPages", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "/root" do
    it "has two links to root and a link to help, about, contact" do
      visit root_path
      links_to_root = page.find_all("a[href=\"#{root_path}\"]")

      expect(links_to_root.length).to eq 2
      expect(page).to have_link "Help" , href: help_path
      expect(page).to have_link "About" , href: about_path
      expect(page).to have_link "Contact" , href: contact_path
    end
  end
end