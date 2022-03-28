require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe "GET /users/new" do
    it "responds successfully" do
      get signup_path
      expect(response).to have_http_status :ok
    end

    it "has a correct title" do
      get signup_path
      expect(response.body).to include full_title("Sign up")
    end
  end

  describe "GET /users/id" do
    let(:inactivated_user) { FactoryBot.create(:user, :inactivated) }

    context "visit inactivated user" do
      it "redirects to root" do
        log_in user
        get user_path(inactivated_user)
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "POST /users" do
    let(:valid_user_params) { FactoryBot.attributes_for(:user) }
    let(:invalid_user_params) { FactoryBot.attributes_for(:user, :invalid) }

    context "with valid information" do
      before do
        ActionMailer::Base.deliveries.clear
      end

      it "creates a user" do
        expect{
          post users_path, params: { user: valid_user_params }
        }.to change(User, :count).by 1
      end

      it "redirects to root" do
        post users_path, params: { user: valid_user_params }
        created_user = User.last
        expect(response).to redirect_to root_path
      end

      it "exists 1 email" do
        post users_path, params: { user: valid_user_params }
        expect(ActionMailer::Base.deliveries.size).to eq 1
      end

      it "hasn't yet been activated" do
        post users_path, params: { user: valid_user_params }
        expect(User.last).to_not be_activated
      end
    end

    context "with invalid information" do
      it "doesn't create a user" do
        expect{
          post users_path, params: { user: invalid_user_params }
        }.to_not change(User, :count)
      end
    end
  end

  describe "GET users/edit/id" do
    context "as a logged in user" do
      before do
        log_in(user)
      end

      it "has a correct title" do
        get edit_user_path(user)
        expect(response.body).to include full_title("Edit user")
      end
    end

    context "as a non-logged in user" do
      it "has a flash" do
        get edit_user_path(user)
        expect(flash).to be_any
      end

      it "redirects to login_path" do
        get edit_user_path(user)
        expect(response).to redirect_to login_path
      end

      it "does friendly forwarding only the first time and redirects the subsequent logins to the default" do
        # 未ログインでeditへアクセス
        get edit_user_path(user)
        # 1回目のログイン(フレンドリーフォワーディングされる)
        log_in user
        expect(response).to redirect_to edit_user_path(user)
        # 2回目のログイン
        log_out
        log_in user
        expect(response).to redirect_to user
      end
    end

    context "as a wrong user" do
      before do
        wrong_user = FactoryBot.create(:user)
        log_in wrong_user
      end

      it "redirects to root" do
        get edit_user_path(user)
        expect(response).to redirect_to root_path
      end
    end

  end

  describe "PATCH /users" do
    it "can't change admin attribute via web" do
      expect(user).to_not be_admin

      log_in user
      patch user_path(user), params: { user: {
          password: "password",
          password_confirmation: "password",
          admin: true
        }
      }
      user.reload
      expect(user).to_not be_admin
    end

    context "as a logged in user" do
      before do
        log_in(user)
      end

      context "with valid information" do
        before do
          @new_params = {
            name: "Another name",
            email: "another@gmail.com",
            password: "",
            password_confirmation: ""
          }
          patch user_path(user), params: { user: @new_params }
        end

        it "edits a user" do
          user.reload
          expect(user.name).to eq @new_params[:name]
          expect(user.email).to eq @new_params[:email]
        end

        it "has a success flash" do
          expect(flash).to be_any
        end
      end

      context "with invalid information" do
        before do
          @invalid_user_params = FactoryBot.attributes_for(:user, :invalid)
          patch user_path(user), params: { user: @invalid_user_params }
        end

        it "doesn't edit a user" do
          user.reload
          expect(user.name).to_not eq @invalid_user_params[:name]
          expect(user.email).to_not eq @invalid_user_params[:email]
          expect(user.password).to_not eq @invalid_user_params[:password]
          expect(user.password_confirmation).to_not eq @invalid_user_params[:password_confirmation]
        end

        it "redirects to edit page" do
          expect(response.body).to include full_title("Edit user")
        end

        it "has correct error messages of 'The form contains 3 errors'" do
          expect(response.body).to include "The form contains 3 errors"
        end
      end
    end

    context "as a non-logged in user" do
      before do
        @new_params = { name: "Another name",
          email: "another@gmail.com",
          password: "",
          password_confirmation: "" }
      end

      it "can't edit" do
        patch user_path(user), params: { user: @new_params }
        user.reload
        expect(user.name).to_not eq @new_params[:name]
        expect(user.email).to_not eq @new_params[:email]
      end

      it "redirects to root" do
        patch user_path(user), params: { user: @new_params }
        expect(response).to redirect_to login_path
      end

      it "has a error flash" do
        patch user_path(user), params: { user: @new_params }
        expect(flash).to be_any
      end
    end

    context "as a wrong user" do
      before do
        wrong_user = FactoryBot.create(:user)
        new_params = { name: "Another name",
          email: "another@gmail.com",
          password: "",
          password_confirmation: "" }

        log_in wrong_user
        patch user_path(user), params: { user: new_params }
      end

      it "redirects to root" do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "GET /users" do
    context "as a logged in user" do
      before do
        30.times do
          FactoryBot.create(:user)
        end
      end

      it "has a correct title" do
        log_in user
        get users_path
        expect(response.body).to include full_title("All users")
      end

      it "has a pagination" do
        log_in user
        get users_path
        pagination = '<div role="navigation" aria-label="Pagination" class="pagination">'
        expect(response.body).to include pagination
      end

      it "has a link for each user" do
        log_in user
        get users_path
        User.paginate(page: 1).each do |user|
          expect(response.body).to include "<a href=\"#{user_path(user)}\">"
        end
      end
    end

    context "as a non-logged in user" do
      it "redirects to login_path" do
        get users_path
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "DELETE /users/id" do
    let!(:admin) { FactoryBot.create(:user, :admin) }
    let!(:other_user) { FactoryBot.create(:user) }

    context "as a non-logged in user" do
      it "redirects to login_path" do
        delete user_path(other_user)
        expect(response).to redirect_to login_path
      end

      it "can't delete" do
        expect {
          delete user_path(other_user)
        }.to_not change(User, :count)
      end
    end

    context "as a logged in user" do
      context "as a non-admin user" do
        before do
          log_in user
        end

        it "redirects to root" do
          delete user_path(other_user)
          expect(response).to redirect_to root_path
        end

        it "can't delete a user" do
          expect {
            delete user_path(other_user)
          }.to_not change(User, :count)
        end
      end

      context "as an admin user" do
        before do
          log_in admin
        end

        it "can delete a user" do
          expect{
            delete user_path(other_user)
          }.to change(User, :count).by -1
        end
      end
    end
  end

end
