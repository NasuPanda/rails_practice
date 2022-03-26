require 'rails_helper'

RSpec.describe "Microposts", type: :system do
  let(:user) { FactoryBot.create(:user) }

  before do
    driven_by(:rack_test)
  end

  describe "GET users/id" do
    before do
      @user = FactoryBot.create(:user, :with_posts)
      log_in @user
    end

    it "has a pagination" do
      pagination = find_all("div.pagination")
      expect(pagination.length).to eq 1
    end

    it "has 30 posts per page" do
      posts_container = within 'ol.microposts' do
        find_all('li')
      end
      expect(posts_container.length).to eq 30
    end

    it "displays micropost counts" do
      expect(page).to have_content @user.microposts.count.to_s
    end

    it "displays contents of each post" do
      @user.microposts.paginate(page: 1).each do |micropost|
        expect(page).to have_content micropost.content
      end
    end
  end
end