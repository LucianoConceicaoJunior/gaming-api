# frozen_string_literal: true

class Organization < ApplicationRecord
  has_many :projects, dependent: :destroy
  before_create :generate_api_key
  validates :name, presence: true
  validates :api_key, presence: true

  private
  def generate_api_key
    self.api_key = SecureRandom.urlsafe_base64(64)
  end
end
