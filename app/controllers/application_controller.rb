# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action do
    kind = request.url.downcase.match(/management|gaming/).to_s
    case kind
    when Api::Constants::Type::MANAGEMENT
      :authenticate
    else
      raise ActionController::UnknownFormat
    end
  end

  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      @organization = Organization.find_by(api_key: token)
    end
  end
end
