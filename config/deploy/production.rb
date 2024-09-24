# frozen_string_literal: true

set :branch, 'main'
set :stage, :production

set :deploy_to, "/var/www/#{fetch(:application)}/#{fetch(:stage)}"
set :puma_pid, "#{shared_path}/tmp/pids/puma-#{fetch(:stage)}.pid"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-#{fetch(:stage)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma-#{fetch(:stage)}.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma-#{fetch(:stage)}.pid"
set :puma_access_log, "#{release_path}/log/puma-#{fetch(:stage)}.error.log"
set :puma_error_log,  "#{release_path}/log/puma-#{fetch(:stage)}.access.log"
