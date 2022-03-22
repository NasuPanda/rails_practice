require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "#new" do
    it "responds successfully" do
      get signup_path
      expect(response).to have_http_status :ok
    end

    it "has a correct title" do
      get signup_path
      expect(response.body).to include full_title("Sign up")
    end
  end

  describe "#create" do
    let(:user) { FactoryBot.create(:user) }
    let(:valid_user_params) { FactoryBot.attributes_for(:user) }
    let(:invalid_user_params) { FactoryBot.attributes_for(:invalid_user) }

    context "with valid information" do
      it "creates a user" do
        expect{
          post users_path, params: { user: valid_user_params }
        }.to change(User, :count).by 1
      end

      it "redirects to users/id" do
        post users_path, params: { user: valid_user_params }
        created_user = User.last
        expect(response).to redirect_to created_user
      end

      it "is logged in when successfully created" do
        post users_path, params: { user: valid_user_params }
        expect(is_logged_in?).to be_truthy
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

  describe "#edit" do
    let(:user) { FactoryBot.create(:user) }

    context "as a logged in user" do
      before do
        log_in(user)
      end

      it "has a correct title" do
        get edit_user_path(user)
        expect(response.body).to include full_title("Edit user")
      end
    end

    context "as a non logged in user" do
      it "has a flash" do
        get edit_user_path(user)
        expect(flash).to be_any
      end

      it "redirects to login_path" do
        get edit_user_path(user)
        expect(response).to redirect_to login_path
      end
    end

    context "as a wrong user" do
      before do
        wrong_user = FactoryBot.create(:another_user)
        log_in wrong_user
      end

      it "redirects to root" do
        get edit_user_path(user)
        expect(response).to redirect_to root_url
      end
    end

  end

  describe "#update" do
    let(:user) { FactoryBot.create(:user) }

    context "as a logged in user" do
      before do
        log_in(user)
      end

      context "with valid information" do
        before do
          @another_user_params = { name: "Another name",
            email: "another@gmail.com",
            password: "",
            password_confirmation: "" }
          patch user_path(user), params: { user: @another_user_params }
        end

        it "edits a user" do
          user.reload
          expect(user.name).to eq @another_user_params[:name]
          expect(user.email).to eq @another_user_params[:email]
        end

        it "redirects to users/id" do
          expect(response).to redirect_to user
        end

        it "has a success flash" do
          expect(flash).to be_any
        end
      end

      context "with invalid information" do
        before do
          @invalid_user_params = FactoryBot.attributes_for(:invalid_user)
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

    context "as a non logged in user" do
        before do
          @another_user_params = { name: "Another name",
            email: "another@gmail.com",
            password: "",
            password_confirmation: "" }

          patch user_path(user), params: { user: @another_user_params }
        end

        it "can't edit" do
          user.reload
          expect(user.name).to_not eq @another_user_params[:name]
          expect(user.email).to_not eq @another_user_params[:email]
        end

        it "redirects to root" do
          expect(response).to redirect_to login_path
        end

        it "has a error flash" do
          expect(flash).to be_any
        end
    end

    context "as a wrong user" do
      before do
        wrong_user = FactoryBot.create(:another_user)
        another_user_params = { name: "Another name",
          email: "another@gmail.com",
          password: "",
          password_confirmation: "" }

        log_in wrong_user
        patch user_path(user), params: { user: another_user_params }
      end

      it "redirects to root" do
        expect(response).to redirect_to root_url
      end
    end
  end


end
