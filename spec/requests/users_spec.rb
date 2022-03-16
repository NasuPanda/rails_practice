require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "#new" do
    it "responds successfully" do
      get signup_path
      expect(response).to have_http_status :ok
    end

    it "have a correct title" do
      get signup_path
      expect(response.body).to include full_title("Sign up")
    end
  end
end