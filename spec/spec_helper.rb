# This file is automatically required before every test run.
# See <http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration>.
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    # Include text for chained helper methods in the `description` and
    # `failure_message` attributes for custom matchers. For example,
    #
    #     be_bigger_than(2).and_smaller_than(4).description
    #
    # will give "be bigger than 2 and smaller than 4" rather than just
    # "be bigger than 2".
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    # Prevent mocking/stubbing a method that does not exist [on a real object].
    mocks.verify_partial_doubles = true
  end

  # Allow RSpec to persist some state between runs in order to support the
  # `--only-failures` and `--next-failure` CLI options.
  config.example_status_persistence_file_path = 'spec/persistence.log'

  # Enforce the use of the new expectation syntax.
  config.disable_monkey_patching!

  # Be more verbose when running a single spec file.
  config.default_formatter = 'doc' if config.files_to_run.one?

  # Run specs in a random order to surface order dependencies.
  #
  # The random seed is printed after each run. To debug an order dependency
  # that surfaced with a specific random seed, re-run the specs with the seed
  # set explicitly via `--seed`.
  config.order = :random
  Kernel.srand config.seed
end
