require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  let(:base_title) { "Ruby on Rails Tutorial Sample App" }

  describe "root" do
    it "responds successfully" do
      get root_path
      expect(response).to have_http_status :ok
    end

    it "has a correct title" do
      get root_path
      expect(response.body).to include "#{base_title}"
    end
  end

  describe "#help" do
    it "responds successfully" do
      get help_path
      expect(response).to have_http_status :ok
    end
    it "has a correct title" do
      get help_path
      expect(response.body).to include "Help | #{base_title}"
    end
  end

  describe "#about" do
    it "responds successfully" do
      get about_path
      expect(response).to have_http_status :ok
    end
    it "has a correct title" do
      get about_path
      expect(response.body).to include "About | #{base_title}"
    end
  end

  describe "contact" do
    it "responds successfully" do
      get contact_path
      expect(response).to have_http_status :ok
    end
    it "has a correct title" do
      get contact_path
      expect(response.body).to include "Contact | #{base_title}"
    end
  end

end