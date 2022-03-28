require "rails_helper"

RSpec.describe "StaticPages", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "/root" do
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

    describe "feed" do
      let(:user) { FactoryBot.create(:user, :with_posts) }
      before do
        log_in user
      end

      it "displays correct feeds" do
        visit root_path
        user.feed.paginate(page: 1).each do |micropost|
          expect(page).to have_content(CGI.escapeHTML(micropost.content))
        end
      end
    end
  end
end