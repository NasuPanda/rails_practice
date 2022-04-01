require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  let(:user) { FactoryBot.create(:user) }
  let(:from_address) { 'noreply@example.com' }

  describe 'account_activation' do
    let(:mail) { described_class.account_activation(user) }

    describe 'header' do
      it "sends to the correct user's email address" do
        expect(mail.to).to eq [user.email]
      end

      it 'sends with a correct subject' do
        expect(mail.subject).to eq('Account activation')
      end

      it 'sends from a correct email address' do
        expect(mail.from).to eq [from_address]
      end
    end

    describe 'body' do
      it "includes a user's name" do
        expect(mail.body.encoded).to match(user.name)
      end

      it "includes a user's email" do
        expect(mail.body.encoded).to match(CGI.escape(user.email))
      end

      it 'includes the activation token' do
        expect(mail.body.encoded).to match(user.activation_token)
      end
    end
  end

  describe 'password_reset' do
    let(:mail) { described_class.password_reset(user) }

    before do
      user.reset_token = User.new_token
    end

    describe 'header' do
      it "sends to the user's email address" do
        expect(mail.to).to eq [user.email]
      end

      it 'sends with the correct subject' do
        expect(mail.subject).to eq('Password reset')
      end

      it 'sends from the correct email address' do
        expect(mail.from).to eq [from_address]
      end
    end

    describe 'body' do
      it "includes the user's email" do
        expect(mail.body.encoded).to match(CGI.escape(user.email))
      end

      it 'includes the reses token' do
        expect(mail.body.encoded).to match(user.reset_token)
      end
    end
  end
end
