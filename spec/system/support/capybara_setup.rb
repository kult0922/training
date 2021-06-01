CAPYBARA_DRIVERS.each do |driver|
  Capybara.register_driver driver[:key] do |app|
    client = Selenium::WebDriver::Remote::Http::Default.new
    client.timeout = 100
    opts = {browser: driver[:browser], http_client: client}
    opts[:profile] = Selenium::WebDriver::Firefox::Profile.new
    # キャッシュを使わない設定
    opts[:profile]['browser.cache.disk.enable'] = false
    opts[:profile]['browser.cache.memory.enable'] = false
    opts[:profile]['browser.cache.offline.enable'] = false
    opts[:profile]['network.http.use-cache'] = false
  end
end
