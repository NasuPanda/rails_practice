require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  describe '#current_user' do
    let(:user) { FactoryBot.create(:user) }

    before do
      remember(user)
    end

    context 'if session is nil' do
      it 'returns right user' do
        expect(user).to eq current_user
        expect(logged_in?).to be_truthy
      end
    end

    context 'if remember digest is wrong' do
      it 'returns nil' do
        user.update_attribute(:remember_digest, User.digest(User.new_token))
        expect(current_user).to be_nil
      end
    end
  end
end
