module SignInModule
  def sign_in_as(user)
    # ログイン画面へ移動
    visit login_path
    
    # ログインフォームへ入力
    fill_in 'email', with: user.email
    fill_in 'password', with: user.password
    click_button 'サインイン'

    # ログインができている
    expect(page).to have_content 'ログインしました。'
  end

  def admin_sign_in_as(user)
    # ユーザー管理 ログイン画面へ移動
    visit admins_users_path

    # ログインフォームへ入力
    fill_in 'email', with: user.email
    fill_in 'password', with: user.password
    click_button 'サインイン'

    # ログインができている
    expect(page).to have_content 'ログインしました。'
  end
end