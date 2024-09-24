# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano
lock '~> 3.19.1'

set :server_address, '18.234.47.154'

server fetch(:server_address), port: 22, user: 'ubuntu', roles: %w[web app db]
set :ssh_options, {
  forward_agent: true,
  auth_methods: %w[publickey],
  keys: %w[/home/luciano/.ssh/luciano_ec2_keys.pem]
}

set :puma_preload_app, true
set :application, 'five_aliens_api'
set :repo_url, 'git@bitbucket.org:5aliens/five_aliens_backend_api.git'
set :user, 'ubuntu'
set :use_sudo, true
set :linked_files, %w[config/database.yml config/master.key]
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
set :upload_roles, %w[web app db]

set :keep_releases, 1
set :migration_role, :app
set :pty, true
# set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w[~/.ssh/id_rsa.pub] }
set :nginx_sites_available_path, '/etc/nginx/sites-available'
set :nginx_sites_enabled_path, '/etc/nginx/sites-enabled'
set :deploy_via, :remote_cache
set :copy_exclude, [ '.git' ]

set :rvm_ruby_version, '3.3.5'

namespace :puma do
  desc 'Create Puma dirs'
  task :create_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  desc 'Restart Nginx'
  task :nginx_restart do
    on roles(:app) do
      execute 'sudo service nginx restart'
    end
  end

  before :start, :create_dirs
  after :start, :nginx_restart
end

namespace :deploy do
  desc 'Make sure local git is in sync with remote.'
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/#{fetch(:branch)}`
        Rails.logger.debug { "WARNING: HEAD is not the same as origin/#{fetch(:branch)}" }
        Rails.logger.debug 'Run `git push` to sync changes.'
        raise
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke! 'puma:restart'
    end
  end

  before :starting,     :check_revision
  before :finishing,    ':linked_files:upload'
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
end
