RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :selenium, options: {
      browser: :remote,
      url: ENV.fetch("SELENIUM_DRIVER_URL"),
      desired_capabilities: :chrome
    }
    Capybara.server_host = Socket.ip_address_list.detect(&:ipv4_private?).ip_address
    Capybara.server_port = 3001
    host! "http://#{Capybara.server_host}:#{Capybara.server_port}"
  end
end
