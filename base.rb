#  TODO
# rake tasks. Only one (db:populate?, plus 2 from Limerick? (validate_models and indices:missing?))
# bootstrap (move to plugin)
# 
# form_builder
# testdb
# 
# Replace test_helper.rb with template
# Add "ENV['BENCHMARK'] ||= 'none'" to test.rb
# Add filter_parameter_logging :password to ApplicationController
# Install jquery
#

# Remove unnecessary Rails files
run 'rm README'
run 'rm public/index.html'
run 'rm public/favicon.ico'
run 'rm public/images/rails.png'

# Remove Prototype
run 'rm public/javascripts/prototype.js'
run 'rm public/javascripts/controls.js'
run 'rm public/javascripts/dragdrop.js'
run 'rm public/javascripts/effects.js'

# Plugins
plugin 'inherited_resources', :git => 'git://github.com/josevalim/inherited_resources.git'
plugin 'annotate_models', :git => 'git://github.com/ctran/annotate_models.git'
plugin 'xss_terminate', :git => 'git://github.com/look/xss_terminate.git'
plugin 'test_benchmark', :git => 'git://github.com/timocratic/test_benchmark.git'
plugin 'will_paginate', :git => 'git://github.com/mislav/will_paginate.git'
plugin 'foreigner', :git => 'git://github.com/matthuhiggins/foreigner.git'
plugin 'authlogic', :git => 'git://github.com/binarylogic/authlogic.git' if yes?('Add authentication? (y/n)')
plugin 'parallel_specs', :git => 'git://github.com/grosser/parallel_specs.git'
plugin 'formastic', :git => 'git://github.com/justinfrench/formtastic.git'
plugin 'rails_datatables', :git => 'git://github.com/phronos/rails_datatables.git'
plugin 'inaction_mailer', :git => 'git://github.com/cwninja/inaction_mailer.git'
plugin 'hoptoad', :git => 'git://github.com/thoughtbot/hoptoad_notifier.git'
plugin 'inaccessible_attributes', :git => 'git://github.com/jondahl/inaccessible_attributes.git'

if yes?("Use PaperClip? (y/n)")
  plugin 'paperclip', :git => 'git://github.com/thoughtbot/paperclip.git'
end

if yes?("Use PostgreSQL? (y/n)")
  plugin 'schema_validations', :git => 'git://github.com/harukizaemon/schema_validations.git'
end

# Gems
gem "Roman2K-rails-test-serving", :lib => "rails_test_serving"
gem "ar_mailer", :source => "http://gemcutter.org"

if yes?('Shoulda testing stack? (y/n)')
  gem 'mocha'
  gem 'thoughtbot-factory_girl', :lib => 'factory_girl'
  gem 'thoughtbot-shoulda', :lib => 'shoulda'
end

if yes?('Add Cucumber stack? (y/n)')
  gem "webrat"
  gem "cucumber"
end

rake('db:create') if yes?('Create development database? (y/n)')
# Install gems on local system
rake('gems:install', :sudo => true) if yes?('Install gems on local system? (y/n)')

# Unpack gems into vendor/gems
rake('gems:unpack:dependencies') if yes?('Unpack gems into vendor directory? (y/n)')

# Freeze Rails into vendor/rails
freeze!

# Install and configure capistrano
if yes?('Install Capistrano on your local system? (y/n)')
  run "sudo gem install capistrano" 
  capify!

  file 'Capfile', <<-FILE
    load 'deploy' if respond_to?(:namespace) # cap2 differentiator
    Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
    load 'config/deploy'
  FILE
end

git :init

file ".gitignore", <<-END
.DS_STORE
log/*.log
tmp/**/*
db/*.sqlite3
*.tmproj
public/javascripts/all.js
public/stylesheets/all.css
coverage.data
coverage/*
*.swp
END

run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"

git :add => "."
git :commit => "-m 'Initial commit by Phronos base template'"

