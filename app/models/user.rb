# frozen_string_literal: true

class User < ApplicationRecord
  belongs_to :organization
  api_guard_associations refresh_token: 'refresh_tokens', blacklisted_token: 'blacklisted_tokens'
  has_many :refresh_tokens, dependent: :delete_all
  has_many :blacklisted_tokens, dependent: :delete_all
  has_secure_password
end
