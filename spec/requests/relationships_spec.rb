require 'rails_helper'

RSpec.describe "Relationships", type: :request do
  describe "#create" do
    context "as a logged in user" do
      # it "" do
      # end
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
    let!(:relationship) { FactoryBot.create(:relationship) }
    context "as a logged in user" do
      # it "" do
      # end
    end
    context "as a non-logged in user" do
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
