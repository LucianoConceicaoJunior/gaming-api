# frozen_string_literal: true

class LeaderboardRow < ApplicationRecord
  belongs_to :user
  validates :score, presence: true, numericality: { greater_than: 0 }
  validates :day, presence: true, numericality: { greater_than: 0 }
  validates :week, presence: true, numericality: { greater_than: 0 }
  validates :month, presence: true, numericality: { greater_than: 0 }
  validates :year, presence: true, numericality: { greater_than: 0 }
  validates :user_id, presence: true
end
