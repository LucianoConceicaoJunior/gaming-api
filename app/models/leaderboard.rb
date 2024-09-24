# frozen_string_literal: true

class Leaderboard < ApplicationRecord
  SORT_REGEX = /asc|desc/
  enum :sort_type, { ascent: 0, descent: 1 }
  enum :period_type, { daily: 0, weekly: 1, monthly: 2, yearly: 3, overall: 4 }
  enum :row_type, { best: 0, latest: 1, accumulative: 2, all_entries: 3 }
  belongs_to :project
  validates :name, presence: true
  validates :period_type, presence: true
  validates :sort_type, presence: true
  validates :row_type, presence: true
end
