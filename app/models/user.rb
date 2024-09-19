# frozen_string_literal: true

class User < ApplicationRecord
  belongs_to :organization
  has_secure_password
end
