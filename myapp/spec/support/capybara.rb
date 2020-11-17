RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by :selenium, using: :headless_chrome, options: { args: ["headless", "disable-gpu", "no-sandbox", "disable-dev-shm-usage"] }
  end
end

module CapybaraHelper
  def visit_with_login(path, username: user.name, password: 'password')
    visit path

    if current_path.eql? login_path
      fill_in I18n.t('username'), with: username
      fill_in I18n.t('password'), with: password
      click_on I18n.t('login')
    end

    visit path unless current_path.eql? path
  end
end
