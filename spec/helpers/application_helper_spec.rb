require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "#full_title" do
    let(:base_title) { 'Ruby on Rails Tutorial Sample App' }

    context "exist argment string" do
      it "returns argment string + base title" do
        expect(full_title("Page Title")).to eq "Page Title | #{base_title}"
      end
    end

    context "not exist argment string" do
      it "returns base title" do
        expect(full_title).to eq "#{base_title}"
      end
    end
  end

end