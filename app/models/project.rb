# frozen_string_literal: true

class Project < ApplicationRecord
  belongs_to :organization
  has_many :leaderboards, dependent: :destroy
  validates :name, presence: true
end
