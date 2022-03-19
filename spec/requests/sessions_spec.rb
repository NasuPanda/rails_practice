require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "#new" do
    it "responds successfully" do
      get login_path
      expect(response).to have_http_status :ok
    end
  end
end
