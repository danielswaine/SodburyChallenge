# Capybara simulates user interaction with web pages.
# See <https://github.com/jnicklas/capybara>.

require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'

Capybara.javascript_driver = :poltergeist
