# frozen_string_literal: true

module Api
  module Constants
    module Type
      MANAGEMENT = 'management'
      GAMING = 'gaming'
    end

    module Regex
      TYPE_REGEX = /management|gaming/
    end
    module Messages
      AUTHENTICATION_FAILED = 'Authentication failed'
      USER_SIGNED_OUT = 'User signed out'
      PROJECT_NOT_FOUND = 'Project not found'
      LEADERBOARD_NOT_FOUND = 'Leaderboard not found'
      COULD_NOT_CREATE_USER = 'Could not create user'
      INVALID_REFRESH_TOKEN = 'Invalid Refresh Token'
      MISSING_REFRESH_TOKEN = 'Missing Refresh Token'
      MISSING_PARAMETERS = 'Missing Parameters'
      GREATER_THAN_ZERO = 'must be greater than 0'
      UNKNOWN_FIELD_TYPE = 'Unknown field type'
      COULD_NOT_CREATE_RECORD = 'Could not create record'
    end
  end
end
