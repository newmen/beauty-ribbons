# Remote server name
server_url = 'ribbons'

# Secured configuration files
secured_files = %w(initializers/secret_token.rb secure_settings.yml)

# Bundler
require 'bundler/capistrano'
set :bundle_without, [:development, :test]

# RVM
require 'rvm/capistrano'
set :rvm_ruby_string, '1.9.3-p392'
set :default_shell, "/bin/bash --login"

# Server setup
server server_url, :app, :web, :db, primary: true

# Git
set :repository, 'git://github.com/newmen/beauty-ribbons.git'
set :scm, :git
set :deploy_via, :remote_cache
ssh_options[:forward_agent] = true

# Remote path
set :application, 'beauty-ribbons'
set :deploy_to, "/opt/www/#{application}"
set :use_sudo, false

# Rails
set :rails_env, 'production'

# Cleanup
set :keep_releases, 3
after 'deploy:restart', 'deploy:cleanup'

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, roles: :app, except: { no_release: true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :create_secured_configuration, roles: :app do
    secured_files.each do |file|
      remote_path = "#{server_url}:#{shared_path}/config/"

      shared_config_dir = "#{shared_path}/config"
      run "mkdir -p #{shared_config_dir}"

      file_dirname = File.dirname(file)
      unless file_dirname == '.'
        run "mkdir -p #{shared_config_dir}/#{file_dirname}"
        remote_path << "#{file_dirname}/"
      end

      `scp config/#{file} #{remote_path}`
    end
  end

  task :link_secured_configuration, roles: :app do
    secured_files.each do |file|
      run "ln -s #{shared_path}/config/#{file} #{release_path}/config/#{file}"
    end
  end
end

after 'deploy:setup', 'deploy:create_secured_configuration'
before 'deploy:assets:precompile', 'deploy:link_secured_configuration'

namespace :sqlite do
  task 'copy_prev_db_files' do
    %w(production.sqlite3 schema.rb).each do |file|
      file_db_path = "db/#{file}"
      prev_db_path = "#{previous_release}/#{file_db_path}"
      run "if [[ -f #{prev_db_path} ]]; then cp #{prev_db_path} #{current_release}/#{file_db_path}; fi"
    end
  end

end

# Migrations
after 'deploy:update_code', 'sqlite:copy_prev_db_files'
after 'deploy:update_code', 'deploy:migrate'
