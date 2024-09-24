# frozen_string_literal: true

server '18.234.47.154', user: 'ubuntu', roles: %w[web app db]
set :ssh_options, {
  forward_agent: true,
  auth_methods: %w[publickey],
  keys: %w[/home/luciano/.ssh/luciano_ec2_keys.pem]
}
