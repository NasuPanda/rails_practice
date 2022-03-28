require 'rails_helper'

RSpec.describe "Microposts", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "/users/id" do
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

  describe "/root" do
    before do
      @user = FactoryBot.create(:user, :with_posts)
      log_in @user
      visit root_path
    end

    describe "sidebar" do
      it "displays micropost counts" do
        expect(page).to have_content @user.microposts.count.to_s
      end

      it "displays 0 microposts with 0 posts" do
        @user.microposts.destroy_all
        visit root_path
        expect(page).to have_content "0 microposts"
      end

      it "displays 1 micropost with a post" do
        @user.microposts.destroy_all
        fill_in "micropost_content", with: "Test Post"
        click_button "Post"
        expect(page).to have_content "1 micropost"
      end
    end

    describe "POST /microposts" do
      context "with valid attributes" do
        it "creates a post" do
          expect {
            fill_in "micropost_content", with: "Test Post"
            click_button "Post"
          }.to change(Micropost, :count).by 1

          expect(page).to have_content "Test Post"
        end

        it "uploads an image" do
          expect {
            fill_in "micropost_content", with: "Test Post"
            attach_file "micropost_image", "#{Rails.root}/spec/fixtures/kitten.jpg"
            click_button "Post"
          }.to change(Micropost, :count).by 1

          attached_post = Micropost.first
          expect(attached_post.image).to be_attached
        end
      end

      context "with invalid attributes" do
        it "doesn't create a post without a content" do
          expect {
            fill_in "micropost_content", with: ""
            click_button "Post"
          }.to_not change(Micropost, :count)

          expect(page).to have_selector 'div#error_explanation'
          expect(page).to have_link '2', href: '/?page=2'
        end
      end
    end

    describe "DELETE /micropost/id" do
      context "as a correct user" do
        it "deletes a post" do
          post = @user.microposts.first

          expect(page).to have_link "delete"
          expect {
            click_link "delete", href: micropost_path(post)
          }.to change(Micropost, :count).by -1

          expect(page).to_not have_content post.content
        end
      end

      context "as a wrong user" do
        let(:wrong_user) { FactoryBot.create(:user) }

        it "doesn't delete a post" do
          visit user_path(wrong_user)
          expect(page).to_not have_link "delete"
        end
      end
    end
  end
end