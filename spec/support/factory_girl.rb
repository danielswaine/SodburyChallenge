# `factory_girl` is a flexible replacement for test fixtures.
# See <https://github.com/thoughtbot/factory_girl_rails>.
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    begin
      DatabaseCleaner.start
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean
    end
  end
end
