RSpec.configure do |config|
  config.before(:each, type: :system) do
    # browser check ON
    # driven_by(:selenium_chrome)

    # browser check OFF
    driven_by(:selenium_chrome_headless)
  end
end