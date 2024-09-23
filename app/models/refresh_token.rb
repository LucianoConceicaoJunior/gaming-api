# frozen_string_literal: true

class RefreshToken < ApplicationRecord
  belongs_to :user
  belongs_to :project, optional: true
end
