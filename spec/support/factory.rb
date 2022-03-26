module FactorySupport
  def create_posts_different_posting_time
    FactoryBot.create(:micropost, :some_time_ago)
    FactoryBot.create(:micropost, :yesterday)
    FactoryBot.create(:micropost, :last_week)
    FactoryBot.create(:micropost, :last_month)
  end
end

RSpec.configure do |config|
  config.include FactorySupport
end