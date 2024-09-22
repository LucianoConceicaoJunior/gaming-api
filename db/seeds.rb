# frozen_string_literal: true

organization = Organization.where(name: '5Aliens').first_or_create!(api_key: SecureRandom.urlsafe_base64(64))
project = Project.where(name: 'Hero', organization:).first_or_create!
Leaderboard.where(name: 'Weekly', period_type: :weekly, sort_type: :descent, row_type: :best, project:).first_or_create!
Leaderboard.where(name: 'Overall', period_type: :overall, sort_type: :descent, row_type: :best, project:).first_or_create!

if Rails.env.development?
  5.times do
    organization = Organization.where(name: Faker::Company.name).first_or_create!(api_key: SecureRandom.urlsafe_base64(64))
    3.times do
      project = Project.where(name: Faker::App.name, organization:).first_or_create!
      Leaderboard.where(name: 'Weekly', period_type: :weekly, sort_type: :descent, row_type: :best, project:).first_or_create!
    end
  end
end
