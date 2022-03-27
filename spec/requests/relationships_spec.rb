require 'rails_helper'

RSpec.describe "Relationships", type: :request do
  describe "#create" do
    context "as a logged in user" do
      before do
        @user = FactoryBot.create(:user)
        @other_user = FactoryBot.create(:user)
        log_in @user
      end

      it "creates a relationship by the standard way" do
        expect{
          post relationships_path, params: { followed_id: @other_user.id }
        }.to change(Relationship, :count).by 1
      end

      it "creates a relationship by the Ajax" do
        expect{
          post relationships_path, params: { followed_id: @other_user.id }, xhr: true
        }.to change(Relationship, :count).by 1
      end
    end

    context "as a non-logged in user" do
      it "redirects to login_path" do
        post relationships_path
        expect(response).to redirect_to login_path
      end

      it "doesn't create a relationship" do
        expect{
          post relationships_path
        }.to_not change(Relationship, :count)
      end
    end
  end

  describe "#destroy" do
    context "as a logged in user" do
      before do
        @user = FactoryBot.create(:user)
        @other_user = FactoryBot.create(:user)
        log_in @user
      end

      it "deletes a relationship by the standard way" do
        @user.follow(@other_user)
        created_relationship = @user.active_relationships.find_by(followed_id: @other_user.id)
        expect{
          delete relationship_path(created_relationship)
        }.to change(Relationship, :count).by -1
      end

      it "deletes a relationship by the Ajax" do
        @user.follow(@other_user)
        created_relationship = @user.active_relationships.find_by(followed_id: @other_user.id)
        expect{
          delete relationship_path(created_relationship), xhr: true
        }.to change(Relationship, :count).by -1
      end
    end

    context "as a non-logged in user" do
      let!(:relationship) { FactoryBot.create(:relationship) }

      it "redirects to login_path" do
        delete relationship_path(relationship)
        expect(response).to redirect_to login_path
      end

      it "doesn't delete a relationship" do
        expect{
          delete relationship_path(relationship)
        }.to_not change(Relationship, :count)
      end
    end
  end

end
