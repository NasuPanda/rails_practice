module LoginSupport

  def log_in_system(user)
    visit login_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
  end

  def log_in_request(user)
    post login_path, params: { session: { email: user.email,
      password: user.password } }
  end

  def is_logged_in?
    !session[:user_id].nil?
  end

  def log_in_as(user)
    session[:user_id] = user.id
  end
end

RSpec.configure do |config|
  config.include LoginSupport
end