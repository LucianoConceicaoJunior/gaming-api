# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action do
    kind = request.url.downcase.match(Api::Constants::Regex::TYPE_REGEX).to_s
    case kind
    when Api::Constants::Type::MANAGEMENT
      authenticate_with_api_key
    when Api::Constants::Type::GAMING
      authenticate_and_set_user
    else
      raise ActionController::UnknownFormat
    end
  end

  def authenticate_with_api_key
    authenticate_or_request_with_http_token do |token, options|
      @organization = Organization.find_by(api_key: token)
    end
  end
end
