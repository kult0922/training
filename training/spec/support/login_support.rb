module LoginSupport
  def login(user)
    visit new_sessions_path
    fill_in 'email', with: user.email
    fill_in 'password', with: user.password
    click_button I18n.t('sessions.new.login_button')
  end
end
