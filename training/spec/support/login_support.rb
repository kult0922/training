module LoginSupport
  def login(user)
    visit new_sessions_path
    fill_in 'email', with: user.email
    fill_in 'password', with: user.password
    click_button 'ログイン'
  end
end

RSpec.configure do |config|
  config.include LoginSupport
end
