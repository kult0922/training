module LoginSupport
  def login(user)
    visit login_path
    fill_in 'session_account_name', with: user.account_name
    fill_in 'session_password', with: user.password
    click_on 'ログイン'
  end
end