require 'rails_helper'

RSpec.describe 'PasswordResets', type: :request do
  let(:user) { FactoryBot.create(:user) }

  before do
    ActionMailer::Base.deliveries.clear
  end

  describe '#new' do
    it 'has a correct input form' do
      get new_password_reset_path
      expect(response.body).to include 'name="password_reset[email]"'
    end
  end

  describe '#create' do
    context 'with a valid email address' do
      it 'creates reset digest' do
        post password_resets_path, params: { password_reset: { email: user.email } }
        user.reload
        expect(user.reset_digest).not_to be_nil
      end

      it 'sends a email' do
        expect {
          post password_resets_path, params: { password_reset: { email: user.email } }
        }.to change(ActionMailer::Base.deliveries, :count).by 1
      end

      it 'has a info flash' do
        post password_resets_path, params: { password_reset: { email: user.email } }
        expect(flash[:info]).not_to be_empty
      end

      it 'redirects to root' do
        post password_resets_path, params: { password_reset: { email: user.email } }
        expect(response).to redirect_to root_path
      end
    end

    context 'with an invalid email address' do
      it 'has a danger flash' do
        post password_resets_path, params: { password_reset: { email: '' } }
        expect(flash[:danger]).not_to be_empty
      end

      it 'renders /password_resets/new' do
        post password_resets_path, params: { password_reset: { email: '' } }
        expect(response.body).to include full_title('Forgot password')
      end

      it "doesn't create a reset digest" do
        post password_resets_path, params: { password_reset: { email: '' } }
        user.reload
        expect(user.reset_digest).to be_nil
      end
    end
  end

  describe '#edit' do
    before do
      post password_resets_path, params: { password_reset: { email: user.email } }
      @user = controller.instance_variable_get(:@user)
    end

    context 'with valid attributes' do
      it 'accesses successfully' do
        get edit_password_reset_path(@user.reset_token, email: @user.email)
        expect(response.body).to include full_title('Reset password')
      end

      it 'has a correct hidden form' do
        # ?????????????????????????????????????????????????????????
        form = "<input type=\"hidden\" name=\"email\" id=\"email\" value=\"#{@user.email}\" />"

        get edit_password_reset_path(@user.reset_token, email: @user.email)
        expect(response.body).to include form
      end
    end

    context 'with invalid attributes' do
      it 'redirects to root with an invalid email' do
        get edit_password_reset_path(@user.reset_token, email: '')
        expect(response).to redirect_to root_path
      end

      it 'redirects to root with an invalid token' do
        get edit_password_reset_path('Invalid token', email: @user.email)
        expect(response).to redirect_to root_path
      end
    end

    context 'as an inactivated user' do
      it 'redirects to root' do
        @user.toggle!(:activated)
        get edit_password_reset_path(@user.reset_token, email: @user.email)
        expect(response).to redirect_to root_path
      end
    end

    context 'with expired token' do
      before do
        @user.update_attribute(:reset_sent_at, 3.hours.ago)
      end

      it 'redirects to new_password_reset_path' do
        get edit_password_reset_path(@user.reset_token, email: @user.email)
        expect(response).to redirect_to new_password_reset_path
      end
    end
  end

  describe '#update' do
    before do
      post password_resets_path, params: { password_reset: { email: user.email } }
      @user = controller.instance_variable_get(:@user)
    end

    context 'with valid attributes' do
      it 'will be logged in' do
        patch password_reset_path(@user.reset_token), params: {
          email: @user.email,
          user: { password: 'newPassword', password_confirmation: 'newPassword' }
        }
        expect(is_logged_in?).to be_truthy
      end

      it 'has a success flash' do
        patch password_reset_path(@user.reset_token), params: {
          email: @user.email,
          user: { password: 'newPassword', password_confirmation: 'newPassword' }
        }
        expect(flash[:success]).not_to be_empty
      end

      it "redirects to user's profile" do
        patch password_reset_path(@user.reset_token), params: {
          email: @user.email,
          user: { password: 'newPassword', password_confirmation: 'newPassword' }
        }
        expect(response).to redirect_to user
      end

      it "changes user's password" do
        patch password_reset_path(@user.reset_token), params: {
          email: @user.email,
          user: { password: 'newPassword', password_confirmation: 'newPassword' }
        }
        old_password = @user.password_digest
        @user.reload
        expect(@user).not_to be_authenticated(:password, old_password)
      end

      it 'sets a reset_digest to nil' do
        patch password_reset_path(@user.reset_token), params: {
          email: @user.email,
          user: { password: 'newPassword', password_confirmation: 'newPassword' }
        }
        @user.reload
        expect(@user.reset_digest).to be_nil
      end
    end

    context 'with invalid attributes' do
      it 'has a error message with invalid password and password_confirmation' do
        patch password_reset_path(@user.reset_token), params: {
          email: @user.email,
          user: { password: 'newPassword', password_confirmation: 'wrongPassword' }
        }
        expect(response.body).to include '<div id="error_explanation">'
      end

      it 'has a error message with empty password' do
        patch password_reset_path(@user.reset_token), params: {
          email: @user.email,
          user: { password: '', password_confirmation: '' }
        }
        expect(response.body).to include '<div id="error_explanation">'
      end
    end

    context 'with expired token' do
      before do
        @user.update_attribute(:reset_sent_at, 3.hours.ago)
      end

      it 'has a correct error message of expired' do
        patch password_reset_path(@user.reset_token), params: {
          email: @user.email,
          user: { password: 'newPassword', password_confirmation: 'newPassword' }
        }
        follow_redirect!
        expect(response.body).to include 'Password reset has expired'
      end

      it 'redirects to new_password_reset_path' do
        patch password_reset_path(@user.reset_token), params: {
          email: @user.email,
          user: { password: 'newPassword', password_confirmation: 'newPassword' }
        }
        expect(response).to redirect_to new_password_reset_path
      end
    end
  end
end
