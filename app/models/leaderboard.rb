# frozen_string_literal: true

class Leaderboard < ApplicationRecord
  enum :sort, { asc: 0, desc: 1 }
  enum :kind, { daily: 0, weekly: 1, monthly: 2, yearly: 3, overall: 4 }
  belongs_to :project
  validates :name, presence: true
  validates :kind, presence: true
  validates :sort, presence: true
end
