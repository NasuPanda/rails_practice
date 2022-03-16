require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "#new" do
    it "responds successfully" do
      get :new
      expect(response).to be_successful
    end
  end
end