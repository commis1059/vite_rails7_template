require "bundler"
require_relative "lib/actions"

extend Lib::Actions

# Database
template 'config/database.yml', force: true do |content|
  content % {
    project_name: ENV.fetch("PROJECT_NAME").then {|name| name.empty? ? File.basename(Dir.pwd) : name },
    pool: '<%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>',
    username: '<%= ENV.fetch("MYSQL_USERNAME") { Rails.application.credentials.dig(:mysql, :username) } %>',
    password: '<%= ENV.fetch("MYSQL_PASSWORD") { Rails.application.credentials.dig(:mysql, :password) } %>',
    host: '<%= ENV.fetch("MYSQL_HOST") { Rails.application.credentials.dig(:mysql, :host) } %>',
    port: '<%= ENV.fetch("MYSQL_PORT") { Rails.application.credentials.dig(:mysql, :port) } %>',
  }
end

# .gitignore
run 'curl -L https://www.gitignore.io/api/osx,rails,jetbrains,vue > .gitignore'

# Gem
gem 'vite_rails'
gem_group :development do
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end
gem_group :development, :test do
  gem 'brakeman', require: false
  gem 'bullet', require: false
end
gem_group :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
end

after_bundle do
  # For Vite Ruby
  run 'bundle exec vite install'

  # For RSpec
  run 'bin/rails g rspec:install'
  # Enable the line: Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }
  uncomment_lines 'spec/rails_helper.rb', Regexp.escape("Dir[Rails.root.join")
  copy_file 'spec/support/factory_bot.rb'
  copy_file 'spec/support/time_helpers.rb'
  file 'config/initializers/generators.rb' do
    <<~EOS
    # frozen_string_literal: true
    
    Rails.application.config.generators do |g|
      g.helper false
      g.test_framework :rspec, view_specs: false, controller_specs: false, fixture: true
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
      g.stylesheets = false
      g.javascripts = false
    end
    EOS
  end

  # For Bullet
  environment env: :development do
    <<~EOS
    config.after_initialize do
      Bullet.enable = true
      Bullet.console = true
      Bullet.rails_logger = true
    end
    EOS
  end
  environment env: :test do
    <<~EOS
    config.after_initialize do
      Bullet.enable = true
      Bullet.rails_logger = true
      Bullet.raise = true
    end
    EOS
  end

  # For Rubocop
  run 'bundle exec rubocop --auto-gen-config'

  # Addition
  puts <<~EOS

    ---
    Installation is complete.
    You need to execute `EDITOR="vi" bin/rails credentials:edit` for each environment.
  
    Ex.
    $ EDITOR="vi" bin/rails credentials:edit -e development
  
    Then, configure the following to connect the DB.
     
    mysql:
      username:
      password:
      host:
      port:

  EOS
end
