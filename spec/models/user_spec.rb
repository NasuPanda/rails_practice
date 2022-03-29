require 'rails_helper'

RSpec.describe User, type: :model do
  it 'saves an email as lower case' do
    user = FactoryBot.build(:user)
    mixed_case_email = 'Foo@ExAmPle.coM'
    user.email = mixed_case_email
    user.save
    expect(mixed_case_email.downcase).to eq user.reload.email
  end

  describe 'validation' do
    let(:user) { FactoryBot.build(:user) }

    context 'with valid attributes' do
      it 'is valid with a name, email and password' do
        expect(user).to be_valid
      end

      it 'is valid with valid format emails' do
        valid_addresses = %w[
          user@example.com USER@foo.COM A_US-ER@foo.bar.org
          first.last@foo.jp alice+bob@baz.cn
        ]
        valid_addresses.each do |valid_address|
          user.email = valid_address
          expect(user).to be_valid
        end
      end
    end

    context 'with invalid attributes' do
      it 'is invalid without a name' do
        user.name = ''
        expect(user).not_to be_valid
      end

      it 'is invalid witout an email' do
        user.email = ''
        expect(user).not_to be_valid
      end

      it 'is invalid with a too long name' do
        user.name = 'a' * 51
        expect(user).not_to be_valid
      end

      it 'is invalid with a too long email' do
        user.email = "#{'a' * 244}@example.com"
        expect(user).not_to be_valid
      end

      it 'is invalid with invalid format emails' do
        invalid_addresses = %w[
          user@example,com user_at_foo.org user.name@example.
          foo@bar_baz.com foo@bar+baz.com
        ]
        invalid_addresses.each do |invalid_address|
          user.email = invalid_address
          expect(user).not_to be_valid
        end
      end

      it 'is invalid with a duplicate email' do
        duplicate_user = user.dup
        duplicate_user.email = user.email.upcase
        user.save
        expect(duplicate_user).not_to be_valid
      end

      it 'is invalid without a password' do
        user.password = user.password_confirmation = '' * 6
        expect(user).not_to be_valid
      end

      it 'is invalid with a too short password' do
        user.password = user.password_confirmation = 'abcde'
        expect(user).not_to be_valid
      end
    end
  end

  describe '#authenticated?' do
    let(:user) { FactoryBot.create(:user) }

    it 'returns false if digest is nil' do
      expect(user).not_to be_authenticated(:remember, '')
    end
  end

  describe '#follow and #unfollow' do
    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:user) }

    it 'can follow the other user' do
      expect(user).not_to be_following(other_user)

      user.follow(other_user)

      expect(user).to be_following(other_user)
      expect(other_user.followers).to be_include(user)
    end

    it 'can unfollow the other user' do
      user.follow(other_user)
      expect(user).to be_following(other_user)
      user.unfollow(other_user)
      expect(user).not_to be_following(other_user)
    end
  end

  describe '#feed' do
    let(:user) { FactoryBot.create(:user, :with_posts) }
    let(:user_following) { FactoryBot.create(:user, :with_posts) }
    let(:user_unfollowed) { FactoryBot.create(:user, :with_posts) }

    before do
      user.follow(user_following)
    end

    it "displays user's own posts" do
      user.microposts.each do |post_self|
        expect(user.feed).to be_include(post_self)
      end
    end

    it "displays following user's posts" do
      user_following.microposts.each do |post_following|
        expect(user.feed).to be_include(post_following)
      end
    end

    it "doesn't display unfollowed user's posts" do
      user_unfollowed.microposts.each do |post_unfollowed|
        expect(user.feed).not_to be_include(post_unfollowed)
      end
    end
  end
end
