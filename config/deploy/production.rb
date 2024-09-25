# frozen_string_literal: true

set :branch, 'main'
set :stage, :production

set :server_address, '18.234.47.154'
server fetch(:server_address), port: 22, user: 'ubuntu', roles: [ :web, :app, :db ], ssh_options: { forward_agent: true }
