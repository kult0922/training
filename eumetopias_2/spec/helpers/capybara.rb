require 'capybara/rspec'
require 'selenium-webdriver'

RSpec.configure do |config|
    config.include Capybara::DSL

    # javascript無
    config.before(:each, type: :system) do
        driven_by :rack_test
    end

    # javascript有
    config.before(:each, type: :system, js: true) do
        driven_by :selenium_chrome_headless, screen_size: [1280, 800], options: {
           browser: :chrome
        } do |driver_option|

            # Chrome オプション追加設定
            driver_option.add_argument('disable-notifications') 
            driver_option.add_argument('disable-translate')
            driver_option.add_argument('disable-extensions')
            driver_option.add_argument('disable-infobars')
            driver_option.add_argument('disable-gpu')
            driver_option.add_argument('no-sandbox')
            driver_option.add_argument('lang=ja')
            driver_option.add_argument('headless')
        end

        # Capybara設定
        Capybara.javascript_driver = :selenium_chrome_headless
        Capybara.run_server = true
        Capybara.default_selector = :css
        Capybara.default_max_wait_time = 5
        Capybara.ignore_hidden_elements = true
    end
end
