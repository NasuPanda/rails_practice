require 'rails_helper'

RSpec.describe "Sign up page", type: :request do
  describe "new" do
    it "responds successfully" do
      get signup_path
      expect(response).to be_successful
      expect(response).to have_http_status "200"
    end
  end
end