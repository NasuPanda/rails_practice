require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "account_activation" do
    let(:user) { FactoryBot.create(:user)}
    let(:mail) { UserMailer.account_activation(user) }
    let(:from_address) { "noreply@example.com" }

    describe "header" do
      it "sends to the user's email address" do
        expect(mail.to).to eq [user.email]
      end

      it "sends with the correct subject" do
        expect(mail.subject).to eq("Account activation")
      end

      it "sends from the correct email address" do
        expect(mail.from).to eq [from_address]
      end
    end

    describe "body" do
      before do
        user.activation_token = User.new_token
      end
      it "includes the user's name" do
        expect(mail.body.encoded).to match(user.name)
      end

      it "includes the user's email" do
        expect(mail.body.encoded).to match(CGI.escape(user.email))
      end

      it "includes the activation token" do
        expect(mail.body.encoded).to match(user.activation_token)
      end
    end
  end

  # describe "password_reset" do
  #   let(:mail) { UserMailer.password_reset }

  #   it "renders the headers" do
  #     expect(mail.subject).to eq("Password reset")
  #     expect(mail.to).to eq(["to@example.org"])
  #     expect(mail.from).to eq(["from@example.com"])
  #   end

  #   it "renders the body" do
  #     expect(mail.body.encoded).to match("Hi")
  #   end
  # end

end
