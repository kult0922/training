# frozen_string_literal: true

module SpecHelper
  # feature/system spec
  def login_as(user)
    visit login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'ログイン'
  end

  # request spec
  def login_request_as(user)
    params = { session: { email: user.email, password: user.password } }
    post login_path, params: params
  end
end
