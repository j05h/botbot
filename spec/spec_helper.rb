$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))

require 'slack-ruby-bot/rspec'
require 'not_respond'
require 'bot'

VCR.configure do |config|
  config.cassette_library_dir = File.join(File.dirname(__FILE__), 'cassettes')
  config.hook_into :webmock
  config.default_cassette_options = { record: :new_episodes }
  config.configure_rspec_metadata!
end

