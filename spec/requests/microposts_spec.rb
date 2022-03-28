require 'rails_helper'

RSpec.describe "Microposts", type: :request do
  describe "POST /microposts" do
    let(:user) { FactoryBot.create(:user) }
    context "as a logged in user" do
      before do
        log_in user
      end

      it "creates a post" do
      expect{
        post microposts_path, params: { micropost: { content: "Test post" } }
      }.to change(Micropost, :count).by 1
      end
    end

    context "as an anonymous user" do
      it "redirects to login_path" do
        post microposts_path, params: { micropost: { content: "Test post" } }
        expect(response).to redirect_to login_path
      end

      it "doesn't create a post" do
        expect{
          post microposts_path, params: { micropost: { content: "Test post" } }
        }.to_not change(Micropost, :count)
      end
    end
  end

  describe "DELETE /microposts/id" do
    let!(:micropost) { FactoryBot.create(:micropost) }

    context "as a logged in user" do
      context "as a wrong user" do
        before do
          wrong_user = FactoryBot.create(:user)
          log_in(wrong_user)
        end

        it "redirects to root" do
          delete micropost_path(micropost)
          expect(response).to redirect_to root_path
        end

        it "does't delete a post" do
          expect {
            delete micropost_path(micropost)
          }.to_not change(Micropost, :count)
        end
      end

      context "as a correct user" do
        before do
          user = micropost.user
          log_in(user)
        end

        it "deletes a post" do
          expect {
            delete micropost_path(micropost)
          }.to change(Micropost, :count).by -1
        end
      end
    end

    context "as an anonymous user" do
      it "redirects to login_path" do
        delete micropost_path(micropost)
        expect(response).to redirect_to login_path
      end
      it "doesn't delete a post" do
        expect{
          delete micropost_path(micropost)
        }.to_not change(Micropost, :count)
      end
    end
  end
end
