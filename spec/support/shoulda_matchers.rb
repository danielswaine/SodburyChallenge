# Shoulda is a collection of matchers for Rails applications.
# See <https://github.com/thoughtbot/shoulda-matchers>.
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
