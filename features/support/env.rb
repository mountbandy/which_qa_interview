require 'bundler/setup'
require 'capybara'
require 'capybara/dsl'
require 'capybara/cucumber'
require 'rspec'
require 'selenium-webdriver'
require 'pry'

Capybara.register_driver :selenium_chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.default_driver = :selenium_chrome

Before('@small_screen') do
  page.driver.browser.manage.window.resize_to(320,568)
end