ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)

# Prevent database truncation if the environment is production.
abort('Rails is running in production mode!') if Rails.env.production?

# Don't add additional requires here. Put them in dedicated files in
# `spec/support` instead.
require 'spec_helper'
require 'rspec/rails'

# Load `.rb` files from `spec/support' and its subdirectories.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Apply pending migrations before the tests are run.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Automatically mix in different behaviours to tests based on their file
  # location. For example, enable calls to `get` and `post` in specs under
  # `spec/controllers`; the alternative is to explicitly tag specs with their
  # type. See <https://relishapp.com/rspec/rspec-rails/docs> for a list of the
  # available types.
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces. Arbitrary gems may also be
  # filtered via: `config.filter_gems_from_backtrace("gem name")`.
  config.filter_rails_from_backtrace!
end
