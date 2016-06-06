# The database needs to be in a left in a clean state after each example is
# run. By default, this is achieved by running each example in a single
# transaction, and rolling back that transaction before the next example
# starts.
#
# This doesn't work for Capybara features that use Poltergeist because
# Poltergeist runs in a separate thread, and [by design] transactions can't be
# shared between threads. RSpec must commit any required setup as individual
# transactions for these examples so that Poltergeist can see them, and this
# means that the database will be in a dirty state once the example is
# finished.
#
# A solution would be to truncate the database after every example, but this is
# inefficient, and so the best option is to use `database_cleaner` to
# dynamically decide whether the database needs to be truncated between each
# example.
RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  # Only feature specs use Capybara.
  config.before(:each, type: :feature) do
    # Capybara is set up to use the Rack driver whenever JavaScript does not
    # need to be tested. The Rack driver runs within the same thread and so
    # works fine with transactions.
    if Capybara.current_driver == :rack_test
      DatabaseCleaner.strategy = :transaction
    else
      DatabaseCleaner.strategy = :truncation
    end
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
