RSpec.configure do |config|
  DatabaseCleaner.allow_remote_database_url = true

  DatabaseCleaner.strategy = :deletion

  config.before do
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end
end
