Rails.application.config.generators do |g|
  g.factory_girl suffix: 'factory'
  g.fixture_replacement :factory_girl
end
